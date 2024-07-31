//
//  ContentView.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        VStack {
            Map()
                .mapStyle(.hybrid(elevation: .realistic, pointsOfInterest: .all, showsTraffic: true))
        }
    }
}

#Preview {
    ContentView()
}
