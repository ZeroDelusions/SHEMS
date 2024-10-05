//
//  DeviceListItem.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 28/09/2024.
//

import Foundation
import SwiftUI

struct DeviceListItem: View {
    @ObservedObject var deviceViewModel: DeviceViewModel
    @State private var deviceForm: DeviceForm
    private let device: Device
    
    init(device: Device, deviceViewModel: DeviceViewModel) {
        self.device = device
        self.deviceViewModel = deviceViewModel
        self._deviceForm = State(initialValue: DeviceForm(device: device))
    }
    
    var body: some View {
        HStack {
            Image(systemName: device.type.sfSymbolName + (deviceForm.status ? ".fill" : ""))
                .font(.title)
            Text(device.name)
            
            HStack {
                Toggle("", isOn: $deviceForm.status)
                    .onChange(of: deviceForm.status) {
                        deviceViewModel.updateDevice(deviceForm.toDevice())
                    }
            }
        }
    }
}
