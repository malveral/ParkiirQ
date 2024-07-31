//
//  FavoritedLocation.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import Foundation

typealias FavoritedLocation = [Int]

extension FavoritedLocation: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(FavoritedLocation.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
