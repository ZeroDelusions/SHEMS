//
//  EnergyConsumptionViewModel.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 25/09/2024.
//

import Foundation
import Combine

class EnergyConsumptionViewModel: BaseViewModel<EnergyConsumption> {
    private let energyConsumptionService: EnergyConsumptionService
    
    init(energyConsumptionService: EnergyConsumptionService = EnergyConsumptionService.shared) {
        self.energyConsumptionService = energyConsumptionService
        super.init()
    }
    
    func fetchAllEnergyConsumptions(from: Date, to: Date, modify: (([EnergyConsumption])  -> [EnergyConsumption])? = nil) {
        let period = EnergyConsumptionPeriod(start: from, end: to)
        let fetchPublisher = energyConsumptionService.getAllEnergyConsumptions(period: period)
        fetchItems(using: fetchPublisher, successHandler: modify)
    }
    
    func fetchDeviceEnergyConsumptions(_ device: Device, from: Date, to: Date, modify: (([EnergyConsumption])  -> [EnergyConsumption])? = nil) {
        let period = EnergyConsumptionPeriod(start: from, end: to)
        let fetchPublisher = energyConsumptionService.getDeviceEnergyConsumptions(device, period: period)
        fetchItems(using: fetchPublisher, successHandler: modify)
    }
    
    func fetchDeviceLastEnergyConsumptions(_ device: Device) {
        let fetchPublisher = energyConsumptionService.getDeviceLastEnergyConsumption(device)
        fetchItems(using: fetchPublisher)
    }
    
    // MARK: - Aggregated -
    
    func fetchAllAggregatedEnergyConsumptions(from: Date, to: Date, aggregationLevel: AggregationLevel, modify: (([EnergyConsumption])  -> [EnergyConsumption])? = nil) {
        let period = EnergyConsumptionPeriod(start: from, end: to)
        let fetchPublisher = energyConsumptionService.getAllAggregatedEnergyConsumptions(period: period, aggregationLevel: aggregationLevel)
        fetchItems(using: fetchPublisher, successHandler: modify)
    }
    
    func fetchDeviceAggregatedEnergyConsumptions(_ device: Device, from: Date, to: Date, aggregationLevel: AggregationLevel, modify: (([EnergyConsumption])  -> [EnergyConsumption])? = nil) {
        let period = EnergyConsumptionPeriod(start: from, end: to)
        let fetchPublisher = energyConsumptionService.getDeviceAggregatedEnergyConsumptions(device, period: period, aggregationLevel: aggregationLevel)
        fetchItems(using: fetchPublisher, successHandler: modify)
    }
}
