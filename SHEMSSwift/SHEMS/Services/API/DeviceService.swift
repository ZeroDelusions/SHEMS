//
//  DeviceService.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 20/09/2024.
//

import Foundation
import Combine

final class DeviceService: CRUDService<Device, Device>, Singleton {
    static let shared = DeviceService()
    
    init() {
        super.init(baseEndpoint: "/device")
    }
}
