//
//  DeviceType.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 28/09/2024.
//

import Foundation
import SwiftUI

enum DeviceType: String, Codable, CaseIterable {
    case thermostat = "Thermostat"
    case lightBulb = "Light Bulb"
    case smartPlug = "Smart Plug"
    case securityCamera = "Security Camera"
    case smartDoorLock = "Smart Door Lock"
    case refrigerator = "Refrigerator"
    case washingMachine = "Washing Machine"
    case dryer = "Dryer"
    case dishwasher = "Dishwasher"
    case airConditioner = "Air Conditioner"
    case waterHeater = "Water Heater"
    case oven = "Oven"
    case microwave = "Microwave"
    case vacuumCleaner = "Vacuum Cleaner"
    case smartTV = "Smart TV"
    case fan = "Fan"
    case speaker = "Smart Speaker"
    case garageDoorOpener = "Garage Door Opener"
    case smokeDetector = "Smoke Detector"
    case sprinkler = "Smart Sprinkler"
    case electricCarCharger = "Electric Car Charger"
    case homeBattery = "Home Battery"

    var backendValue: String {
        self.rawValue.uppercased().replacingOccurrences(of: " ", with: "_")
    }

    var sfSymbolName: String {
        switch self {
        case .thermostat: return "thermometer"
        case .lightBulb: return "lightbulb"
        case .smartPlug: return "powerplug"
        case .securityCamera: return "camera"
        case .smartDoorLock: return "lock"
        case .refrigerator: return "refrigerator"
        case .washingMachine: return "washer"
        case .dryer: return "dryer"
        case .dishwasher: return "dishwasher"
        case .airConditioner: return "air.conditioner.horizontal"
        case .waterHeater: return "drop.degreesign"
        case .oven: return "oven"
        case .microwave: return "microwave"
        case .vacuumCleaner: return "heater.vertical"
        case .smartTV: return "tv"
        case .fan: return "fan"
        case .speaker: return "speaker"
        case .garageDoorOpener: return "door.garage.open"
        case .smokeDetector: return "smoke"
        case .sprinkler: return "sprinkler"
        case .electricCarCharger: return "bolt.car"
        case .homeBattery: return "batteryblock"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        let humanReadableValue = rawValue.capitalized.replacingOccurrences(of: "_", with: " ")
        
        if let deviceType = DeviceType(rawValue: humanReadableValue) {
            self = deviceType
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid device type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.backendValue)
    }
}
