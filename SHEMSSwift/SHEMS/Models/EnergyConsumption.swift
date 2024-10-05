//
//  EnergyConsumption.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 25/09/2024.
//

import Foundation

struct EnergyConsumption: Codable, Equatable, IdentifiedItem, Chartable {
    let id: Int
    let timestamp: Date
    let powerUsage: Double
}
