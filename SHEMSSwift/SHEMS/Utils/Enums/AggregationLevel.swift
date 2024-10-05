//
//  AggregationLevel.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 29/09/2024.
//

import Foundation

enum AggregationLevel: String, Equatable, Comparable, Codable {
    case minutely
    case hourly
    case daily
    case weekly
    case monthly
    
    static func < (lhs: AggregationLevel, rhs: AggregationLevel) -> Bool {
        return lhs.order < rhs.order
    }
    
    static func > (lhs: AggregationLevel, rhs: AggregationLevel) -> Bool {
        return lhs.order > rhs.order
    }
    
    static func == (lhs: AggregationLevel, rhs: AggregationLevel) -> Bool {
        return lhs.order == rhs.order
    }
    
    static func != (lhs: AggregationLevel, rhs: AggregationLevel) -> Bool {
        return lhs.order != rhs.order
    }
    
    private var order: Int {
        switch self {
        case .minutely: return 1
        case .hourly: return 2
        case .daily: return 3
        case .weekly: return 4
        case .monthly: return 5
        }
    }
    
    // Coding
    
    private var backendValue: String {
        self.rawValue.uppercased()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        let lowercasedRawValue = rawValue.lowercased()
        
        if let aggregationLevel = AggregationLevel(rawValue: lowercasedRawValue) {
            self = aggregationLevel
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid aggregation level")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.backendValue)
    }
}

