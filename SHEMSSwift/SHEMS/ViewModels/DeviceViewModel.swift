//
//  DeviceViewModel.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 20/09/2024.
//

import Foundation
import Combine
import SwiftUI

class DeviceViewModel: BaseViewModel<Device> {
    private let deviceService: DeviceService
    
    init(deviceService: DeviceService = DeviceService.shared) {
        self.deviceService = deviceService
        super.init()
    }
    
    func fetchDevices() {
        let fetchPublisher = deviceService.getAll()
        fetchItems(using: fetchPublisher)
    }

    func addDevice(_ device: Device) {
        let addPublisher = deviceService.add(parameters: device)
        addItem(using: addPublisher)
    }
    
    func updateDevice(_ device: Device) {
        let addPublisher = deviceService.update(parameters: device)
        updateItem(using: addPublisher)
    }
    
    func deleteDevice(_ device: Device, delay: TimeInterval = 0.3) {
        // Wait for button (.destruction) role animation to end
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // Optimistically remove the device from the items array
            guard let index = self.items.firstIndex(where: { $0.id == device.id }) else { return }
            let removedDevice = self.items.remove(at: index)
            // Delete from backend
            let deletePublisher = self.deviceService.delete(item: device)
            self.deleteItem(using: deletePublisher, completionHandler: { [weak self] completion in
                switch completion {
                case .finished:
                    // Deletion successful, no further action needed
                    break
                case .failure(let error):
                    // Re-add the device back to the list if deletion fails
                    withAnimation {
                        self?.items.insert(removedDevice, at: index)
                    }
                    self?.setError(error)
                }
            })
        }
    }

}
