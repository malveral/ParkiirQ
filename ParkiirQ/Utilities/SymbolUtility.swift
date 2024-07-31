//
//  SymbolUtility.swift
//  ParkiirQ
//
//  Created by Marcell JW on 31/07/24.
//

import SwiftUI

enum SFSymbol {
    case chevronRight
    case chevronLeft
    case bookmark
    case electricStation
    case markMyLocation
    case reportIssue
    case motorcycle
    case car
    case parkingSign
    case plus
    case share
    case pin
}

struct SymbolUtilities {
    func getSymbol(_ name: SFSymbol) -> String {
        switch name {
        case .chevronLeft:
            return "chevron.backward"
            
        case .chevronRight:
            return "chevron.forward"
            
        case .bookmark:
            return "bookmark.fill"
            
        case .electricStation:
            return "bolt.car.fill"
            
        case .markMyLocation:
            return "location.north"
            
        case .reportIssue:
            return "exclamationmark.circle.fill"
            
        case .motorcycle:
            return "Motorcycle"
            
        case .car:
            return "car.fill"
            
        case .parkingSign:
            return "parkingsign"
            
        case .plus:
            return "plus"
            
        case .share:
            return "location.fill"
            
        case .pin:
            return "mappin"
        }
    }
}

#Preview {
    
    VStack {
        Image(systemName: SymbolUtilities().getSymbol(.chevronLeft)
        )
        Image(systemName: SymbolUtilities().getSymbol(.chevronRight)
        )
        
        Image(systemName: SymbolUtilities().getSymbol(.bookmark)
        )
        Image(systemName: SymbolUtilities().getSymbol(.electricStation)
        )
        Image(systemName: SymbolUtilities().getSymbol(.markMyLocation)
        )
        Image(systemName: SymbolUtilities().getSymbol(.reportIssue)
        )
        Image(SymbolUtilities().getSymbol(.motorcycle))
        Image(systemName: SymbolUtilities().getSymbol(.car)
        )
        Image(systemName: SymbolUtilities().getSymbol(.parkingSign)
        )
    }

}
