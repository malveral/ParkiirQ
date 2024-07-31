//
//  ContentView.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import SwiftUI

struct ContentView: View {
    var location = LocationRequest()
    @AppStorage("showOnboarding") var showOnboarding = true
    @State var locationAuthorized = false
    
    var body: some View {
        NavigationStack {
            if !locationAuthorized {
                Text("Tidak bisa mendapatkan akses lokasi")
            } else {
                ParkingMapView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .isLocationAuthorized)) {
            object in
            locationAuthorized = object.object as? Bool ?? false
        }
        .onAppear {
            locationAuthorized = location.isAuthorized
            showOnboarding = !location.isAuthorized
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
