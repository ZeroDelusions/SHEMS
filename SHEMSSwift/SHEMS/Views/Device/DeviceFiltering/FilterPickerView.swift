//
//  FilterPickerView.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 28/09/2024.
//

import SwiftUI

struct FilterPickerView<T: Hashable>: View {
    @Binding var selectedValue: T?
    let filter: Filter<T>
    let onChange: (T?) -> Void
    @State private var showPickerSheet = false

    var body: some View {
        ZStack {
            Button {
                showPickerSheet.toggle()
            } label: {
                HStack {
                    Text(filter.name)
                    Spacer()
                    Text(selectedValue != nil ? String(describing: selectedValue!) : "Any")
                        .foregroundColor(.gray)
                }
            }
            .buttonStyle(PickerButtonStyle())
            .sheet(isPresented: $showPickerSheet) {
                sheetContent
                    .presentationDetents([.fraction(0.4)])
            }
        }
    }
    
    // MARK: - Subviews
    
    var sheetContent: some View {
        VStack {
            Text(filter.name)
                .font(.headline)
                .padding()

            pickerContent
                .pickerStyle(.wheel)
                .padding()

            Button("Done") {
                showPickerSheet.toggle()
            }
            .padding()
        }
    }
    
    var pickerContent: some View {
        Picker(filter.name, selection: Binding(
            get: { selectedValue ?? nil },
            set: { newValue in
                selectedValue = newValue
                onChange(newValue)
            }
        )) {
            Text("Any").tag(nil as T?)
            ForEach(filter.options, id: \.self) { option in
                Text(String(describing: option)).tag(option as T?)
            }
        }
    }
}

