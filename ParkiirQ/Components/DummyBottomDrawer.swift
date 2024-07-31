//
//  DummyBottomDrawer.swift
//  ParkiirQ
//
//  Created by Marcell JW on 31/07/24.
//

import SwiftUI

struct DummyBottomDrawer: View {
    
    @State var showingCredits = true
    @State var favorites: [String] = ["Lot 1", "Lot 2", "Lot 3"]
    @State var parkingsNearby: [String] = ["Lot 1", "Lot 2", "Lot 3"]
    
    var body: some View {
        Button("Show Credits") {
            showingCredits.toggle()
        }
        .sheet(isPresented: $showingCredits) {
            Text("Parking Lots")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 30)
                .padding(.horizontal)
            ScrollView{
                Group {
                    HStack{
                        Text("Favorites")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    ScrollView(.horizontal){
                        HStack(spacing: 16){
                            if favorites.isEmpty {
                                Text("No favorite parking found")
                            } else {
                                ForEach(0..<favorites.count + 1) { item in
                                    //ganti sesuai yang disimpan user
                                    VStack{
                                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                            Image(systemName: SymbolUtilities().getSymbol(.parkingSign))         .padding(14)
                                                .background(Circle().fill(Color("GrayButton")))
                                        })
                                        .bold()
                                        .foregroundStyle(.teal)
                                        Text("park 12345")
                                            .font(.caption)
                                            .frame(maxWidth: 54)
                                            .lineLimit(1)
                                            .fixedSize()
                                    }
                                }
                        }
                        }
                    }
                }
                .padding(.horizontal)
                VStack{
                        HStack{
                            Text("Parkings Nearby")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                    ForEach(0..<parkingsNearby.count + 1) { lot in
                        HStack{
                            //nama tempat parkirnya
                            Text("Lot 1")
                                .frame(maxWidth: 250)
                                .lineLimit(1)
                                .fixedSize()
                            Spacer()
                            Image(systemName: SymbolUtilities().getSymbol(.chevronRight))
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                .padding(.bottom, 26)
                Button(action: {}, label: {
                    HStack{
                        Image(systemName: SymbolUtilities().getSymbol(.share))
                        Text("Share My Location")
                    }
                }).buttonStyle(ButtonStyleUtility().getStyle(.defaultStyle))
                    .padding(.horizontal)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack{
                        Image(systemName: SymbolUtilities().getSymbol(.reportIssue))
                        Text("Report an Issue")
                    }
                }).buttonStyle(ButtonStyleUtility().getStyle(.defaultStyle))
                    .padding(.horizontal)
            }
            .presentationDetents([.fraction(0.20), .fraction(0.65)])
        }
    }

}

#Preview {
    DummyBottomDrawer(favorites: ["Park 1", "Park 2"], parkingsNearby: ["Lot 1", "Lot 2"])
}

