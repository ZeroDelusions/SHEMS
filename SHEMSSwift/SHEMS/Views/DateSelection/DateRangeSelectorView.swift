//
//  DateRangeSelectorView.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 27/09/2024.
//

import Foundation
import SwiftUI

struct DateRangeSelectorView: View {
    @ObservedObject var viewModel: DateRangeViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var maxDate: Date { return viewModel.endDate }
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            DateSelectionButton(title: "From", maxDate: maxDate, date: Binding(
                get: { viewModel.startDate },
                set: { viewModel.updateStartDate($0) }
            ))
            DateSelectionButton(title: "To", maxDate: Date(), date: Binding(
                get: { viewModel.endDate },
                set: { viewModel.updateEndDate($0) }
            ))
        }
    }
}


