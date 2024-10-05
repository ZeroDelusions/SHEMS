//
//  ChartViewModel.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 29/09/2024.
//

import Foundation
import Combine

fileprivate typealias NavigationLevel = (detailLevel: AggregationLevel, start: Date, end: Date)

class ChartViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var aggregatedData: [EnergyConsumption] = []
    private(set) var aggregationLevel: AggregationLevel = .hourly
    private var navigationStack: [NavigationLevel] = []
    
    private let energyConsumptionViewModel: EnergyConsumptionViewModel
    private let deviceFilterViewModel: DeviceFilterViewModel
    private let dateRangeViewModel: DateRangeViewModel
    private let calendar = Calendar.current
    private var startDate: Date
    private var endDate: Date
    
    private var timer: Timer? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init(energyConsumptionViewModel: EnergyConsumptionViewModel, deviceFilterViewModel: DeviceFilterViewModel, dateRangeViewModel: DateRangeViewModel) {
        
        self.energyConsumptionViewModel = energyConsumptionViewModel
        self.deviceFilterViewModel = deviceFilterViewModel
        self.dateRangeViewModel = dateRangeViewModel
        self.startDate = dateRangeViewModel.startDate
        self.endDate = dateRangeViewModel.endDate
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.fetchData()
        }

        // Publishers
        self.energyConsumptionViewModel.$items
            .assign(to: &self.$aggregatedData)
        
        Publishers.CombineLatest3(
            self.deviceFilterViewModel.$selectedDevice,
            self.dateRangeViewModel.$startDate,
            self.dateRangeViewModel.$endDate
        )
        .sink { [weak self] _, start, end in
            guard let self else { return }
            self.startDate = start
            self.endDate = end
            self.reset()
        }
        .store(in: &cancellables)
        
        // Initial configuration
        updateDetailLevel()
        fetchData()
    }
    
    // Chart navigation
    
    func navigateForward(to date: Date) {
        guard canNavigateForward else { return }
        
        self.navigationStack.append((self.aggregationLevel, startDate, endDate))
        self.aggregationLevel = self.aggregationLevel.next
        updateDateRange(date)

        fetchData()
    }
    
    func navigateBack() {
        if let lastStackValue = self.navigationStack.popLast() {
            self.aggregationLevel = lastStackValue.detailLevel
            self.startDate = lastStackValue.start
            self.endDate = lastStackValue.end
            
            fetchData()
        }
    }
    
    var canNavigateForward: Bool { self.aggregationLevel != .minutely }
    var canNavigateBack: Bool { !self.navigationStack.isEmpty }
    
    // Chart modification
    
    var chartTitle: String {
        "\(self.aggregationLevel.rawValue.capitalized) consumption of \(self.deviceFilterViewModel.selectedDevice?.name ?? "all devices")"
    }
    
    var shouldUseBarChart: Bool {
        return aggregationLevel > .hourly
    }
    
    // X-Axis configuration
    
    var xAxisUnit: Calendar.Component {
        switch aggregationLevel {
        case .minutely: return .minute
        case .hourly: return .hour
        case .daily: return .day
        case .weekly: return .weekOfYear
        case .monthly: return .month
        }
    }
    
    var xAxisStrideUnit: Calendar.Component {
        switch aggregationLevel {
        case .minutely: return .minute
        case .hourly: return .hour
        case .daily: return .day
        case .weekly: return .weekOfYear
        case .monthly: return .month
        }
    }
    
    var xAxisStrideCount: Int {
        switch aggregationLevel {
        case .minutely: return 15
        case .hourly: return 4
        case .daily, .weekly, .monthly: return 1
        }
    }
    
    var xAxisLabelFormat: Date.FormatStyle {
        switch aggregationLevel {
        case .minutely: return .dateTime.minute()
        case .hourly: return .dateTime.hour()
        case .daily: return .dateTime.day()
        case .weekly: return .dateTime.week()
        case .monthly: return .dateTime.month()
        }
    }
    
    // MARK: - Private
    
    private func reset() {
        updateDetailLevel()
        self.navigationStack.removeAll()
        fetchData()
    }
    
    private func fetchData() {
        if let selectedDevice = deviceFilterViewModel.selectedDevice {
            energyConsumptionViewModel.fetchDeviceAggregatedEnergyConsumptions(selectedDevice, from: self.startDate, to: self.endDate, aggregationLevel: self.aggregationLevel)
        } else {
            energyConsumptionViewModel.fetchAllAggregatedEnergyConsumptions(from: self.startDate, to: self.endDate, aggregationLevel: self.aggregationLevel)
        }
    }
    
    private func updateDetailLevel() {
        if let dayCount = self.calendar.dateComponents([.day], from: startDate, to: endDate).day {
            switch dayCount {
            case 0..<1:
                self.aggregationLevel = .hourly
            case 1..<7:
                self.aggregationLevel = .daily
            case 7..<30:
                self.aggregationLevel = .weekly
            case 30...:
                self.aggregationLevel = .monthly
            default:
                self.aggregationLevel = .hourly
            }
        }
    }
    
    private func updateDateRange(_ date: Date) {
        let (start, end) = getDateRange(date, by: self.aggregationLevel)
        self.startDate = start
        self.endDate = end
    }
    
    // Get date range for aggregation level that it is `child` of
    private func getDateRange(_ date: Date, by level: AggregationLevel) -> (start: Date, end: Date) {
        switch level {
        case .minutely: return (date.startOfHour, date.endOfHour)
        case .hourly: return (date.startOfDay, date.endOfDay)
        case .daily: return (date.startOfWeek, date.endOfWeek)
        case .weekly: return (date.startOfMonth, date.endOfMonth)
        case .monthly: return (date.startOfYear, date.endOfYear)
        }
    }
}
