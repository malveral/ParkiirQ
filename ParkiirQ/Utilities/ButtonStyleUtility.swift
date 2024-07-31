//
//  ButtonStyleUtility.swift
//  FromScratch
//
//  Created by Marcell JW on 31/07/24.
//

import SwiftUI

// MARK: The core ButtonStyle and Utility

enum ButtonStyles {
    case defaultStyle
}

struct ButtonStyleUtility {
    
    func getStyle(_ name: ButtonStyles) -> some ButtonStyle {
        
        switch name {
        case .defaultStyle:
            return DefaultActionButtonStyle()
            
        }
    }
    
    func getDefaultActionStyle() -> some ButtonStyle {
        return DefaultActionButtonStyle()
    }
    
}

    // MARK: Various Button Style Structs

struct DefaultActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.medium)
            .padding()
            .frame(maxWidth:.infinity)
            .background(Color("GrayButton"))
            .foregroundStyle(.blue)
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

#Preview {
    
    VStack {
        Button("Report an Issue") {
        }
        .buttonStyle(ButtonStyleUtility().getDefaultActionStyle())
        
        FavoriteButton("Park 1")
    }
    
}
