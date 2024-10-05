//
//  DeviceFilterView.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 28/09/2024.
//

import SwiftUI

struct DeviceFilterView: View {
    @ObservedObject var viewModel: DeviceFilterViewModel
    @State private var selectedLocation: String?
    @State private var selectedType: String?
    @State private var selectedManufacturer: String?
    @State private var selectedStatus: Bool?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        let isFiltered = selectedLocation != nil || selectedType != nil || selectedManufacturer != nil || selectedStatus != nil
        
        if isFiltered {
            Button("Reset") {
                withAnimation {
                    selectedLocation = nil
                    selectedType = nil
                    selectedManufacturer = nil
                    selectedStatus = nil
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .background(Color(uiColor: UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .transition(.blurReplace)
            .animation(.spring, value: isFiltered)
        }
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            FilterPickerView(selectedValue: $selectedLocation, filter: viewModel.locationFilter) { newValue in
                viewModel.applyFilter(viewModel.locationFilter, value: newValue)
            }
            
            FilterPickerView(selectedValue: $selectedType, filter: viewModel.typeFilter) { newValue in
                viewModel.applyFilter(viewModel.typeFilter, value: newValue)
            }
            
            FilterPickerView(selectedValue: $selectedManufacturer, filter: viewModel.manufacturerFilter) { newValue in
                viewModel.applyFilter(viewModel.manufacturerFilter, value: newValue)
            }
            
            FilterPickerView(selectedValue: $selectedStatus, filter: viewModel.statusFilter) { newValue in
                viewModel.applyFilter(viewModel.statusFilter, value: newValue)
            }
        }
    }
}

