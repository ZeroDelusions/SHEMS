//
//  AddDeviceView.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 24/09/2024.
//

import Foundation
import SwiftUI

struct AddDeviceView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var deviceViewModel: DeviceViewModel
    @State private var deviceForm = DeviceForm()
    
    init(deviceViewModel: DeviceViewModel) {
        self.deviceViewModel = deviceViewModel
    }
    
    var body: some View {
        NavigationView {
            DeviceFormView(form: $deviceForm)
                .navigationTitle("Add New Device")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            addDevice()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            
        }
        .presentationDetents([.fraction(0.7)])
        
    }
    
    private func addDevice() {
        let newDevice = deviceForm.toDevice()
        deviceViewModel.addDevice(newDevice)
        presentationMode.wrappedValue.dismiss()
    }
}
