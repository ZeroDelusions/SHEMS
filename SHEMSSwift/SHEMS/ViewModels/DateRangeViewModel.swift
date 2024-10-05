//
//  DateRangeViewModel.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 29/09/2024.
//

import Foundation

class DateRangeViewModel: ObservableObject {
    @Published var startDate: Date
    @Published var endDate: Date
    
    init(startDate: Date = Date(), endDate: Date = Date()) {
        self.startDate = startDate.startOfDay
        self.endDate = endDate.endOfDay
    }
    
    func updateStartDate(_ date: Date) {
        startDate = date.startOfDay
    }
    
    func updateEndDate(_ date: Date) {
        endDate = date.endOfDay
    }
}
