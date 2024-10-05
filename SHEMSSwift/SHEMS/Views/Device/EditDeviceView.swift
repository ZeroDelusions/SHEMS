//
//  EditDeviceView.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 24/09/2024.
//

import Foundation
import SwiftUI

struct EditDeviceView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var deviceViewModel: DeviceViewModel
    @State private var deviceForm: DeviceForm
    let device: Device
    
    init(deviceViewModel: DeviceViewModel, device: Device) {
        self.device = device
        self.deviceViewModel = deviceViewModel
        _deviceForm = State(initialValue: DeviceForm(device: device))
    }
    
    var body: some View {
        NavigationView {
            DeviceFormView(form: $deviceForm)
                .navigationTitle("Edit \(device.name)")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Update") {
                            deviceViewModel.updateDevice(deviceForm.toDevice())
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
        .presentationDetents([.fraction(0.7)])
    }
}
