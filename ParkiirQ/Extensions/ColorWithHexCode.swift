//
//  ColorWithHexCode.swift
//  ParkiirQ
//
//  Created by Marcell JW on 31/07/24.
//

import Foundation
import SwiftUI


extension Color {
    init(hex: Int, opacity: Double = 1) {
        
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
    
//    init(hexCode: String, opacity: Double = 1.0) {
//        
//        var hexToInt = hexCode.replacingOccurrences(of: "#", with: "", options: NSString.CompareOptions.literal, range: nil)
//        
//        
//        let newHex = Int(String(format:"%02X", hexToInt)) ?? 0
//        
//        self.init(
//            .sRGB,
//            red: Double((newHex >> 16) & 0xff) / 255,
//            green: Double((newHex >> 08) & 0xff) / 255,
//            blue: Double((newHex >> 00) & 0xff) / 255,
//            opacity: opacity
//        )
//    }
    
}

#Preview {
    
    VStack {
        Circle()
            .foregroundStyle(Color(hex: 0x0d98ba))
        Circle()
            .foregroundStyle(Color(hex: 0xE3E5E4))
        
//        Circle()
//            .foregroundStyle(Color(hexCode: "0d98ba"))
//        Circle()
//            .foregroundStyle(Color(hexCode: "E3E5E4"))
        
    }
    
}
