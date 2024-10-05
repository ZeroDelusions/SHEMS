//
//  DateSelectionButton.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 02/10/2024.
//

import Foundation
import SwiftUI

struct DateSelectionButton: View {
    var title: String
    let maxDate: Date
    @Binding var date: Date
    @State private var isPresented = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            HStack {
                Text(title)
                Spacer()
                Text(dateFormatter.string(from: date))
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(PickerButtonStyle())
        .sheet(isPresented: $isPresented) {
            VStack {
                Text("Select \(title)")
                    .font(.headline)
                    .padding()
                
                DatePicker("", selection: $date, in: ...maxDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                
                Button("Done") {
                    isPresented = false
                }
                .padding()
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
}
