//
//  Parking.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import Foundation
import MapKit

struct Parking: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let lat: Double
    let long: Double
    let title: String
    let spkluInfo: String
    
    var hasSpklu: Bool {
        !self.spkluInfo.contains("SP_NA")
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case lat = "lat"
        case long = "long"
        case title = "title"
        case spkluInfo = "spklu_info"
    }
}

extension Parking {
    static func fetchAll() async throws -> [Parking] {
        let parkingLots: [Parking] =  try await supabase
            .from("parkings")
            .select()
            .execute()
            .value
        
        return parkingLots
    }
}

extension Parking {
    static let mock: [Parking] = [
        .init(id: 1, lat: -7.29681, long: 110.49237, title: "Skibidi", spkluInfo: "SP_NA")
    ]
}
