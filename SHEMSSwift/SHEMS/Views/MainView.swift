//
//  MainView.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 21/09/2024.
//

import Foundation
import SwiftUI

struct MainView: View {
    @StateObject private var deviceViewModel: DeviceViewModel
    @StateObject private var filterViewModel: DeviceFilterViewModel
    @StateObject private var energyConsumptionViewModel: EnergyConsumptionViewModel
    @StateObject private var dateRangeViewModel: DateRangeViewModel
    @StateObject private var chartViewModel: ChartViewModel
    
    @State private var timer: Timer? = nil
    @State private var isAddDeviceSheetPresented: Bool = false
    
    init() {
        let deviceVM = DeviceViewModel()
        let deviceFilterVM = DeviceFilterViewModel(deviceViewModel: deviceVM)
        let dateRangeVM = DateRangeViewModel()
        let energyConsumptionVM = EnergyConsumptionViewModel()
        
        _deviceViewModel = StateObject(wrappedValue: deviceVM)
        _filterViewModel = StateObject(wrappedValue: deviceFilterVM)
        _energyConsumptionViewModel = StateObject(wrappedValue: energyConsumptionVM)
        _dateRangeViewModel = StateObject(wrappedValue: dateRangeVM)
        _chartViewModel = StateObject(wrappedValue: ChartViewModel(
            energyConsumptionViewModel: energyConsumptionVM, 
            deviceFilterViewModel: deviceFilterVM,
            dateRangeViewModel: dateRangeVM
        ))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                BaseChart(viewModel: chartViewModel)
                DateRangeSelectorView(viewModel: dateRangeViewModel)
                DeviceFilterView(viewModel: filterViewModel)
                FilteredDevicesView(deviceViewModel: deviceViewModel, filterViewModel: filterViewModel)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddDeviceSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isAddDeviceSheetPresented) {
                        AddDeviceView(deviceViewModel: deviceViewModel)
                    }
                }
            }
        }
        .onAppear {
            deviceViewModel.fetchDevices()
        }
        .errorAlert(for: deviceViewModel) {
            deviceViewModel.fetchDevices()
        }
    }
}
