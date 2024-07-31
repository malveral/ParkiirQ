//
//  DummyBottomDrawer.swift
//  ParkiirQ
//
//  Created by Marcell JW on 31/07/24.
//

import SwiftUI

struct DummyBottomDrawer: View {
    
    @State var showingCredits = true
    
    var body: some View {
        Button("Show Credits") {
            showingCredits.toggle()
        }
        .sheet(isPresented: $showingCredits) {
            Text("This app was brought to you by Hacking with Swift")
                .presentationDetents([.fraction(0.15)])
        }
    }

}

#Preview {
    DummyBottomDrawer()
}
