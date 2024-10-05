//
//  DeviceFilterViewModel.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 28/09/2024.
//

import Foundation
import Combine

struct Filter<T: Hashable> {
    let name: String
    let keyPath: KeyPath<Device, T>
    let predicate: (T) -> Bool
    let options: [T]
}

class DeviceFilterViewModel: ObservableObject {
    @Published private(set) var activeFilters: [String: Any] = [:]
    @Published private(set) var selectedDevice: Device?
    
    var locationFilter: Filter<String>
    var typeFilter: Filter<String>
    var manufacturerFilter: Filter<String>
    var statusFilter: Filter<Bool>
    
    private let deviceViewModel: DeviceViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(deviceViewModel: DeviceViewModel) {
        self.deviceViewModel = deviceViewModel
        
        locationFilter = Filter(name: "Location", keyPath: \.location, predicate: { _ in true }, options: [])
        typeFilter = Filter(name: "Type", keyPath: \.type.rawValue, predicate: { _ in true }, options: [])
        manufacturerFilter = Filter(name: "Manufacturer", keyPath: \.manufacturer, predicate: { _ in true }, options: [])
        statusFilter = Filter(name: "Status", keyPath: \.status, predicate: { _ in true }, options: [true, false])
        
        self.deviceViewModel.$items
            .sink { [weak self] items in
                self?.updateFilterOptions(items)
            }
            .store(in: &self.cancellables)
    }
    
    // Dynamically update filters based on chosen values
    func updateFilterOptions(_ devices: [Device]) {
        let locations = Array(Set(devices.map { $0.location })).sorted()
        locationFilter = Filter(name: "Location", keyPath: \.location, predicate: { _ in true }, options: locations)
        
        let manufacturers = Array(Set(devices.map { $0.manufacturer })).sorted()
        manufacturerFilter = Filter(name: "Manufacturer", keyPath: \.manufacturer, predicate: { _ in true }, options: manufacturers)
        
        let types = Array(Set(devices.map { $0.type.rawValue })).sorted(by: { $0 < $1 })
        typeFilter = Filter(name: "Type", keyPath: \.type.rawValue, predicate: { _ in true }, options: types)
    }

    var filteredDevices: [Device] {
        deviceViewModel.items.filter { device in
            activeFilters.allSatisfy { (key, value) in
                switch key {
                case "Location":
                    return (value as? String).map { device.location == $0 } ?? true
                case "Type":
                    return (value as? String).map { device.type.rawValue == $0 } ?? true
                case "Manufacturer":
                    return (value as? String).map { device.manufacturer == $0 } ?? true
                case "Status":
                    return (value as? Bool).map { device.status == $0 } ?? true
                default:
                    return true
                }
            }
        }
    }
    
    func applyFilter<T>(_ filter: Filter<T>, value: T?) {
        if let value = value {
            activeFilters[filter.name] = value
        } else {
            activeFilters.removeValue(forKey: filter.name)
        }
    }
    
    func selectDevice(_ device: Device?) {
        selectedDevice = device
    }
}
