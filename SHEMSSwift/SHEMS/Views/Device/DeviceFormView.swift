//
//  DeviceFormView.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 27/09/2024.
//

import Foundation
import SwiftUI

struct DeviceFormView: View {
    @Binding var form: DeviceForm
    
    var body: some View {
        List {
            Section(header: Text("Device Details")) {
                TextField("Name", text: $form.name)
                TextField("Manufacturer", text: $form.manufacturer)
                TextField("Model", text: $form.model)
                TextField("Location", text: $form.location)
                VStack(alignment: .leading) {
                    Text("Type")
                        .foregroundColor(Color(uiColor: UIColor.systemGray2))
                    Picker("Type", selection: $form.type) {
                        ForEach(DeviceType.allCases, id: \.self) { value in
                            Text(value.rawValue)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                }
            }
        }
        .scrollDisabled(true)
    }
}
