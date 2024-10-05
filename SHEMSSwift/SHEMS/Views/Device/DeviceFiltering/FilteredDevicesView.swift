//
//  FilteredDevicesView.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 28/09/2024.
//

import SwiftUI

struct FilteredDevicesView: View {
    @ObservedObject private var deviceViewModel: DeviceViewModel
    @ObservedObject private var filterViewModel: DeviceFilterViewModel
    @State private var isEditViewPresented: Bool = false
    @State private var showHint: Bool = true
    
    init(deviceViewModel: DeviceViewModel, filterViewModel: DeviceFilterViewModel) {
        self.deviceViewModel = deviceViewModel
        self.filterViewModel = filterViewModel
    }
    
    var body: some View {
        List(filterViewModel.filteredDevices, id: \.id) { device in
            let isSelected = filterViewModel.selectedDevice?.id ?? -1 == device.id
            
            Button {
                filterViewModel.selectDevice(isSelected ? nil : device)
            } label: {
                DeviceListItem(device: device, deviceViewModel: deviceViewModel)
            }
            .listRowInsets(EdgeInsets())
            .padding()
            .background(isSelected ? Color.secondary.opacity(0.15) : .clear)
            .animation(.easeInOut.delay(0.05), value: isSelected)
            .swipeActions(edge: .leading) {
                Button {
                    isEditViewPresented.toggle()
                } label: {
                    Image(systemName: "pencil")
                }
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    deviceViewModel.deleteDevice(device)
                    if isSelected { filterViewModel.selectDevice(nil) }
                } label: {
                    Image(systemName: "trash.fill")
                }
                .tint(.red)
            }
            .sheet(isPresented: $isEditViewPresented) {
                EditDeviceView(deviceViewModel: deviceViewModel, device: device)
            }
        }
    }
}
