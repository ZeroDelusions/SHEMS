//
//  EnergyConsumptionService.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 25/09/2024.
//

import Foundation
import Combine
import Alamofire

struct EnergyConsumptionPeriod: Encodable {
    let start: Date
    let end: Date
}

struct AggregatedEnergyConsumptionRequest: Encodable {
    let start: Date
    let end: Date
    let aggregationLevel: AggregationLevel
    
    enum CodingKeys: String, CodingKey {
        case start, end, aggregationLevel
    }
}

final class EnergyConsumptionService: ReadOnlyService<EnergyConsumption, EnergyConsumptionPeriod>, Singleton {
    static let shared = EnergyConsumptionService()
    
    init() {
        super.init(baseEndpoint: "/energy-consumption")
    }
    
    func getDeviceAggregatedEnergyConsumptions(_ device: Device, period: EnergyConsumptionPeriod, aggregationLevel: AggregationLevel) -> AnyPublisher<[EnergyConsumption], APIError> {
        let parameters = AggregatedEnergyConsumptionRequest(
            start: period.start,
            end: period.end,
            aggregationLevel: aggregationLevel
        )
        return authenticatedRequest("/device/\(device.id)/aggregated", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
    }
    
    func getAllAggregatedEnergyConsumptions(period: EnergyConsumptionPeriod, aggregationLevel: AggregationLevel) -> AnyPublisher<[EnergyConsumption], APIError> {
        let parameters = AggregatedEnergyConsumptionRequest(
            start: period.start,
            end: period.end,
            aggregationLevel: aggregationLevel
        )
        return authenticatedRequest("/all-devices/aggregated", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
    }
    
    func getDeviceEnergyConsumptions(_ device: Device, period: EnergyConsumptionPeriod) -> AnyPublisher<[EnergyConsumption], APIError> {
        return getAll(path: "/device/\(device.id)", parameters: period)
    }
    
    func getAllEnergyConsumptions(period: EnergyConsumptionPeriod) -> AnyPublisher<[EnergyConsumption], APIError> {
        return getAll(path: "/all-devices", parameters: period)
    }
    
    func getDeviceLastEnergyConsumption(_ device: Device) -> AnyPublisher<[EnergyConsumption], APIError> {
        return getAll(path: "/device/\(device.id)/latest")
    }
}
