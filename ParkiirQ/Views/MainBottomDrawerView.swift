//
//  MainBottomDrawerView.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import SwiftUI
import CoreLocation

struct MainBottomDrawerView: View {
    
    var lastLocation: CLLocation
    let selectedParkingLot: (_ parking: Parking) -> Void
    
    @AppStorage("favorites") var favorites = FavoritedLocation()
    @State private var parkingLots: [Parking] = []
    @State private var favoritedParkingLots: [Parking] = []
    @State private var isSharingLocation = false
    
    var nearestParkigLots: [Parking] {
        parkingLots.filter {
            
            let parkingLoc = CLLocation(
                latitude: $0.lat,
                longitude: $0.long
            )
            
            // 1KM
            return lastLocation
                .distance(from: parkingLoc)
                .isLess(than: 1000)
        }
    }
    
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
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Daftar parkiran")
                    .font(.title)
                    .bold()
            }
            .padding(.top, 25)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView([]) {
                if !favoritedParkingLots.isEmpty {
                    VStack {
                        HStack{
                            SectionTitle("Favorit")
                            Spacer()
                        }
                        ScrollView(.horizontal){
                            HStack(spacing: 16){
                                ForEach(favoritedParkingLots, id: \.self) { parking in
                                    VStack{
                                        Button(action: {
                                            selectedParkingLot(parking)
                                        }, label: {
                                            Image(systemName: SymbolUtilities().getSymbol(.parkingSign))         
                                                .padding(14)
                                                .background(Circle()
                                                    .fill(Color(.tertiarySystemFill))
                                                )
                                        })
                                        .bold()
                                        .foregroundStyle(.teal)
                                        Text(parking.title)
                                            .font(.caption)
                                            .frame(maxWidth: 54)
                                            .lineLimit(1)
                                            .fixedSize()
                                    }
                                }
                            }
                        }
                    } .padding(.horizontal)
                }
                
                if !nearestParkigLots.isEmpty {
                    VStack{
                        HStack{
                            SectionTitle("Paling dekat")
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        ForEach(nearestParkigLots) { parking in
                            
                            HStack{
                                Text(parking.title)
                                    .frame(maxWidth: 250)
                                    .lineLimit(1)
                                    .fixedSize()
                                Spacer()
                                Image(systemName: SymbolUtilities().getSymbol(.chevronRight))
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .onTapGesture {
                                selectedParkingLot(parking)
                            }
                        }
                    }
                    .padding(.bottom, 26)
                }
                
                ShareLink(
                    item: URL(string: "http://maps.apple.com/?daddr=\( lastLocation.coordinate.latitude),\( lastLocation.coordinate.longitude)")!,
                    subject: Text("Saya sedang disini"),
                    message: Text("Berikut adalah lokasi saya saat ini: \(URL(string: "http://maps.apple.com/?daddr=\( lastLocation.coordinate.latitude),\(lastLocation.coordinate.longitude)")!)"),
                    preview: SharePreview("Bagikan lokasi saat ini", image: Image("mappin_share"))
                ) {
                    Label("Bagikan lokasi saya", systemImage: SymbolUtilities().getSymbol(.share))
                }
                .buttonStyle(ButtonStyleUtility().getStyle(.defaultStyle))
                .padding(.horizontal)
                
                Button {
                    NotificationCenter
                        .default
                        .post(name: .wantsToReportIssue, object: true)
                } label: {
                    Label(
                        "Laporkan Masalah",
                        systemImage: SymbolUtilities().getSymbol(.reportIssue)
                    )
                }
                .buttonStyle(ButtonStyleUtility().getStyle(.defaultStyle))
                .padding(.horizontal)
                
            }
            .ignoresSafeArea()
            
        }
        .interactiveDismissDisabled()
        .frame(maxWidth: .infinity, alignment: .leading)
        .presentationDetents([.fraction(0.20), .fraction(0.75)])
        .presentationBackgroundInteraction(
            .enabled(upThrough: .fraction(0.20))
        )
        .task {
            await getParkingLots()
        }
    }
    
    func getParkingLots() async {
        do {
            let parkingLots: [Parking] =  try await Parking.fetchAll()
            
            await MainActor.run {
                self.parkingLots = parkingLots
                self.favoritedParkingLots = parkingLots.filter {
                    favorites.contains($0.id)
                }
            }
            
        } catch {
            print("Fail to get parking lots")
        }
    }
}

#Preview {
    HStack{}
        .sheet(isPresented: .constant(true)) {
            MainBottomDrawerView(lastLocation: CLLocation(latitude: 0, longitude: 0)) {
                _ in
                print("Parking selected")
            }
        }
}
