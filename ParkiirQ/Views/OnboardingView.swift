//
//  OnboardingView.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import SwiftUI
import CoreLocation

struct OnboardingView: View {
    @AppStorage("showOnboarding") var showOnboarding = true
    var location = LocationRequest()
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Spacer()
            VStack {
                Text("Welcome to ParkiirQ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.primary)
                Text("Find parking and EV charger easier")
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 30) {
                FeatureItem(
                    icon: "parkingsign.circle",
                    title: "Informasi parkir terbaru",
                    description: "Ketahui secara langsung kondisi parkir di tempat tujuan anda"
                )
                
                FeatureItem(
                    icon: "ev.charger",
                    title: "Lokasi SPKLU",
                    description: "Dapatkan informasi akurat mengenai lokasi SPKLU"
                )
                
                FeatureItem(
                    icon: "leaf.fill",
                    title: "Berkontribusi dalam menjaga lingkungan",
                    description: "Dengan mempercepat proses pencarian parkir, emisi yang dikeluarkan ikut berkurang"
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            VStack(alignment: .center, spacing: 5) {
                Image(systemName: "mappin.circle")
                    .resizable()
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 32, height: 32)
                Text("ParkiirQ memerlukan lokasi akurat perangkat anda. Dengan menekan 'Selanjutnya', anda memberikan izin ParkiirQ untuk menggunakan lokasi anda")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                
                Button("Selanjutnya") {
                    location.requestAuthorization()
                }
                .font(.headline)
                .padding(12)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(Color.accentColor)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.top, 20)
            }
        }
        .padding(.all, 40)
        .interactiveDismissDisabled()
        .onReceive(NotificationCenter.default.publisher(for: .isLocationAuthorized)) {
            object in
            
            let status = object.object as? Bool ?? false
            showOnboarding = !status
        }
    }
    
    
    @ViewBuilder
    func FeatureItem(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.accentColor)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }
        }
    }
}

#Preview {
    struct Preview: View {
        
        @State var showSheet = true
        
        var body: some View {
            HStack {}
                .sheet(isPresented: $showSheet) {
                    OnboardingView()
                }
        }
    }
    
    return Preview()
}
