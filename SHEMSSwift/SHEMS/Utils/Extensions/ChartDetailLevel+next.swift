//
//  ChartDetailLevel+next.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 29/09/2024.
//

import Foundation

extension AggregationLevel {
    var next: AggregationLevel {
        switch self {
        case .minutely: return .minutely
        case .hourly: return .minutely
        case .daily: return .hourly
        case .weekly: return .daily
        case .monthly: return .weekly
        }
    }
}
