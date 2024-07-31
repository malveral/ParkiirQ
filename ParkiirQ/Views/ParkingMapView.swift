//
//  ParkingMapView.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import SwiftUI
import MapKit
import Supabase
import SwiftUINavigation

struct ParkingMapView: View {
    
    @State var location = LocationManager()
    @State var position: MapCameraPosition = .userLocation(
        followsHeading: true, fallback: .automatic
    )
    
    @State var search = ""
    @State var selectedParkingLot: Parking?
    @State var parkingLots: [Parking] = []
    
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                UserAnnotation()
                ForEach(parkingLots) { parking in
                    ParkingMarker(for: parking)
                }
            }
            
            if !location.firstLoadFinished {
                Color.gray.opacity(0.5)
                    .ignoresSafeArea()
                ProgressView()
            }
        }
        .navigationTitle("ParkiirQ")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $search)
        .sheet(item: $selectedParkingLot) { parkingLot in
            ParkingDetailView(
                parking: parkingLot,
                lastLocation: location.userCoords
            )
        }
        .onAppear {
            Task {
                await getParkingLots()
                // await subscribeToChanges()
            }
        }
    }
    
    func subscribeToChanges() async {
        print("Subscribing")
        let channel = supabase.channel("parkiirq")
        
        let changeStream = channel.postgresChange(
            AnyAction.self
        )
        
        Task {
            for await _ in changeStream {
                await getParkingLots()
                print("Change detected")
            }
        }
        
        await channel.subscribe()
        
    }
    
    @MapContentBuilder
    func ParkingMarker(for parking: Parking) -> some MapContent {
        
        Annotation(parking.title, coordinate: parking.coordinate) {
            Image(systemName: "parkingsign.circle.fill")
                .font(.title)
                .foregroundStyle(Color.accentColor)
                .onTapGesture {
                    self.selectedParkingLot = parking
                }
        }.tag("parkinglot-\(parking.id)")
    }
    
    func getParkingLots() async {
        do {
            
            let parkingLots: [Parking] =  try await supabase
                .from("parkings")
                .select()
                .execute()
                .value
            
            await MainActor.run {
                self.parkingLots = parkingLots
            }
            
        } catch {
            print("Fail to get parking lots")
        }
    }
}

#Preview {
    ParkingMapView()
}
