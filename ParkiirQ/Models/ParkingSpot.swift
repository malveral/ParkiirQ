//
//  ParkingSpot.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import Foundation

struct ParkingSpot: Codable, Identifiable {
    let id: Int
    let parkingSpaceId: Int
    let code: String
    let available: Bool
    let shortInfo: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case parkingSpaceId = "parking_space_id"
        case code = "code"
        case available = "available"
        case shortInfo = "short_info"
    }
}
