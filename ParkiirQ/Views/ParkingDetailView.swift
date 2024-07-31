//
//  ParkingDetailView.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import SwiftUI
import MapKit

struct ParkingDetailView: View {
    var parking: Parking
    var lastLocation: CLLocation
    
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
                            
                        } label: {
                            Label("Tambah ke favorit", systemImage: "star")
                        }
                        .font(.headline)
                        .padding(12)
                        .foregroundStyle(Color(.secondaryLabel))
                        .background(Color(.secondarySystemBackground))
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
                }
            }
            .padding(.top, 25)
        }
        .task {
            await getAvailableSpot()
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium])
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
            print("Fail to get parking lots")
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
