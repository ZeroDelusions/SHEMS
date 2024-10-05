//
//  DeviceForm.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 27/09/2024.
//

import Foundation

struct DeviceForm: IdentifiedItem {
    var id: Int = 0
    var name: String = ""
    var type: DeviceType = .lightBulb
    var manufacturer: String = ""
    var model: String = ""
    var powerRating: Double = 0
    var status: Bool = false
    var location: String = ""
    
    init(device: Device? = nil) {
        if let device = device {
            id = device.id
            name = device.name
            type = device.type
            manufacturer = device.manufacturer
            model = device.model
            powerRating = device.powerRating
            status = device.status
            location = device.location
        }
    }
    
    func toDevice() -> Device {
        return Device(id: id,
                      name: name,
                      type: type,
                      manufacturer: manufacturer,
                      model: model,
                      powerRating: powerRating,
                      status: status,
                      installationDate: Date(),
                      location: location)
    }
}
