//
//  OnboardingView.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import SwiftUI

struct OnboardingView: View {
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
                    title: "Real-time parking information",
                    description: "Know in real-time the parking situation on your location"
                )
                
                FeatureItem(
                    icon: "ev.charger",
                    title: "EV Charging location",
                    description: "Find out if your destination has EV charging nearby"
                )
                
                FeatureItem(
                    icon: "leaf.fill",
                    title: "Save the earth",
                    description: "lorem ipsum"
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            VStack(alignment: .center, spacing: 5) {
                Image(systemName: "mappin.circle")
                    .resizable()
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 32, height: 32)
                Text("ParkiirQ requires your exact location when using the app. Click continue to agree and start using ParkiirQ")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                
                Button("Continue") {
                    
                }
                .font(.headline)
                .padding(12)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(Color.accentColor)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.top, 20)
            }
        }.padding(.all, 40)
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
