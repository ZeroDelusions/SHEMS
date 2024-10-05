//
//  Device.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 20/09/2024.
//

import Foundation

struct Device: Codable, Hashable, IdentifiedItem {
    let id: Int
    let name: String
    let type: DeviceType
    let manufacturer: String
    let model: String
    let powerRating: Double
    let status: Bool
    let installationDate: Date
    let location: String
}
