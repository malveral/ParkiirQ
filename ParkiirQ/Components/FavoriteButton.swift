//
//  FavoriteButton.swift
//  ParkiirQ
//
//  Created by Marcell JW on 31/07/24.
//

import SwiftUI

struct FavoriteButton: View {
    
    let iconName: String
    let name: String
    
    init(iconName: String = SymbolUtilities().getSymbol(.bookmark), _ name: String) {
        self.iconName = iconName
        self.name = name
    }
    
    var body: some View {
        
        VStack(alignment: .center){
            
            Image(systemName: iconName)
                .padding(10)
                .background(Color("GrayButton"))
                .clipShape(Circle())
                .foregroundStyle(Color.blue)

            Text(name)
                .font(.system(size: 12))
            
        }
        
    }
}

#Preview {
    FavoriteButton("Park 1")
}
