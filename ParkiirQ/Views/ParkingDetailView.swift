//
//  ParkingDetailView.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import SwiftUI
import MapKit
import Supabase

struct ParkingDetailView: View {
    @AppStorage("favorites") var favorites = FavoritedLocation()
    
    @State var pgChannel: RealtimeChannelV2?
    
    var parking: Parking
    
    var lastLocation: CLLocation
    
    var isFavorited: Bool {
        return favorites.contains(parking.id)
    }
    
    var distanceFromUser: Double {
        return CLLocation(
            latitude: parking.lat,
            longitude: parking.long
        ).distance(from: lastLocation)
    }
    
    @State private var parkingSpots: [ParkingSpot] = []
    
    @ViewBuilder
    func SectionTitle(_ title: String) -> some View {
        Text(title)
            .textCase(nil)
            .listRowInsets(EdgeInsets(
                top: 15,
                leading: 0,
                bottom: 10,
                trailing: 0
            ))
            .font(.title3)
            .bold()
            .foregroundStyle(Color.primary)
            .padding(0)
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(parking.title)
                        .font(.title)
                        .bold()
                    HStack {
                        Button {
                            goToParking()
                        } label: {
                            Label("Navigasi", systemImage: "car.fill")
                        }
                        .font(.headline)
                        .padding(12)
                        .foregroundStyle(.white)
                        .background(Color.accentColor)
                        .clipShape(.rect(cornerRadius: 10))
                        
                        Button {
                            setFavorited()
                        } label: {
                            Label(isFavorited
                                  ? "Hapus dari favorit"
                                  : "Tambah ke favorit",
                                  systemImage: isFavorited ? "star.fill" : "star")
                        }
                        .font(.headline)
                        .padding(12)
                        .foregroundStyle(isFavorited ? .accent : Color(.secondaryLabel))
                        .background(Color(.tertiarySystemFill))
                        .clipShape(.rect(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                List {
                    Section(header: SectionTitle("Detail")) {
                        if parking.hasSpklu {
                            HStack {
                                Image(systemName: "ev.charger.fill")
                                    .foregroundStyle(Color.accentColor)
                                VStack(alignment: .leading) {
                                    Text("SPKLU Tersedia")
                                    Text(parking.spkluInfo)
                                        .font(.subheadline)
                                        .foregroundStyle(Color.secondary)
                                }
                            }
                        }
                        
                        HStack {
                            Image(systemName: "point.topleft.down.to.point.bottomright.filled.curvepath")
                                .foregroundStyle(Color.accentColor)
                            Text("\(distanceFromUser.twoDigitString) meter dari posisi anda")
                            
                        }
                        
                    }
                    
                    Section(header: SectionTitle("Parkir tersedia")) {
                        if parkingSpots.isEmpty {
                            Text("Data parkir kosong.")
                        } else {
                            ForEach(parkingSpots) { spot in
                                HStack {
                                    Label(spot.code,
                                          systemImage: spot.available ? "checkmark" : "xmark")
                                    Spacer()
                                    Text(spot.shortInfo)
                                        .foregroundStyle(Color.secondary)
                                }
                            }
                        }
                    }
                    
                    Section {
                        ShareLink(
                            item: URL(string: "http://maps.apple.com/?daddr=\( parking.lat),\(parking.long)")!,
                            subject: Text("Saya sedang disini"),
                            message: Text("Saya sedang berada di parkiran \(parking.title): \(URL(string: "http://maps.apple.com/?daddr=\( parking.lat),\(parking.long)")!)"),
                            preview: SharePreview("Bagikan lokasi parkir ini", image: Image("mappin_share"))
                        ) {
                            Label("Bagikan tempat parkir", systemImage: SymbolUtilities().getSymbol(.share))
                        }
                    }
                }
            }
            .padding(.top, 25)
        }
        .task {
            await getAvailableSpot()
            if pgChannel == nil {
                await subscribeToChanges()
            }
        }
        .onDisappear {
            Task {
                print("PG Channel unsubscribe")
                await pgChannel?.unsubscribe()
                pgChannel = nil
            }
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium])
    }
    
    func subscribeToChanges() async {
        print("Subscribing")
        
        self.pgChannel = supabase.channel("ibeaconsim")
        
        let changeStream = pgChannel?.postgresChange(
            UpdateAction.self,
            schema: "public",
            table: "parking_spots"
        )
        
        Task {
            if let stream = changeStream {
                for await _ in stream {
                    await getAvailableSpot()
                    print("Change detected")
                }
            }
        }
        
        await pgChannel?.subscribe()
        
    }
    
    func setFavorited() {
        let index = favorites.firstIndex(of: parking.id)
        
        guard let index else {
            favorites.append(parking.id)
            return
        }
        
        favorites.remove(at: index)
    }
    
    func goToParking() {
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: parking.coordinate))
        destination.name = parking.title
        
        MKMapItem.openMaps(
            with: [ destination],
            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        )
    }
    
    func getAvailableSpot() async {
        do {
            
            let spots: [ParkingSpot] =  try await supabase
                .from("parking_spots")
                .select("*")
                .eq("parking_space_id", value: parking.id)
                .execute()
                .value
            
            await MainActor.run {
                print("Spots found", spots)
                self.parkingSpots = spots
            }
            
        } catch {
            print("Fail to get parking lots", error.localizedDescription)
        }
    }
}

#Preview {
    HStack {}
        .sheet(isPresented: .constant(true)) {
            ParkingDetailView(
                parking: Parking.mock.first!,
                lastLocation: CLLocation(latitude: 0, longitude: 0)
            )
        }
    
}
