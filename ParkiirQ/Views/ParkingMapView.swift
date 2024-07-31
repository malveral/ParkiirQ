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
    
    @State var showMainSheet = false
    @State var selectedParkingLot: Parking?
    @State var parkingLots: [Parking] = []
    @State var showReportView = false
    
    
    var body: some View {
        ZStack {
            BeaconListenerView() {
                showMainSheet = true
            }
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
        .toolbarBackground(
            Color(.secondarySystemBackground),
            for: .navigationBar
        )
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(NotificationCenter.default.publisher(for: .wantsToReportIssue)) { object in
            print("Received")
            let result = object.object as? Bool ?? false
            showMainSheet = !result
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showReportView = result
            }
        }
        .onChange(of: location.firstLoadFinished) {
            showMainSheet = location.firstLoadFinished
        }
        .onChange(of: selectedParkingLot) {
            showMainSheet = selectedParkingLot == nil
        }
        .navigationDestination(isPresented: $showReportView) {
            ReportIssueView()
        }
        .sheet(isPresented: $showMainSheet) {
            MainBottomDrawerView(lastLocation: location.userCoords) { parking in
                self.showMainSheet = false
                self.selectedParkingLot = parking
            }
        }
        .sheet(item: $selectedParkingLot) { parkingLot in
            ParkingDetailView(
                parking: parkingLot,
                lastLocation: location.userCoords
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                if location.firstLoadFinished {
                    showMainSheet = true
                }
            }
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
                .foregroundStyle(
                    parking.hasSpklu
                    ? Color.green
                    : Color.blue,
                    Color(.systemBackground)
                )
                .onTapGesture {
                    self.showMainSheet = false
                    self.selectedParkingLot = parking
                }
        }.tag("parkinglot-\(parking.id)")
    }
    
    func getParkingLots() async {
        do {
            let parkingLots: [Parking] =  try await Parking.fetchAll()
            
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
