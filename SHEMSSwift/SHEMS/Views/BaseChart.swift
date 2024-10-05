//
//  BaseChart.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 25/09/2024.
//

import Foundation
import SwiftUI
import Charts

struct BaseChart: View {
    @ObservedObject var viewModel: ChartViewModel
    @State private var chartSelection: Date?
    @State private var selectedEntry: EnergyConsumption?
    
    private var areaBackground: Gradient {
        Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.1)])
    }
    
    var body: some View {
        VStack {
            chartNavigation
            chart
                .animation(.spring, value: viewModel.aggregatedData)
        }
    }
    
    // MARK: - Subviews
    
    private var chartNavigation: some View {
        HStack {
            if viewModel.canNavigateBack {
                Button(action: viewModel.navigateBack) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
            Spacer()
            Text(viewModel.chartTitle)
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var chart: some View {
        Chart(viewModel.aggregatedData) { entry in
            if viewModel.shouldUseBarChart {
                BarMark(
                    x: .value("Time", entry.timestamp, unit: viewModel.xAxisUnit),
                    y: .value("Energy Consumption", entry.powerUsage)
                )
            } else {
                LineMark(
                    x: .value("Time", entry.timestamp, unit: viewModel.xAxisUnit),
                    y: .value("Energy Consumption", entry.powerUsage)
                )
                .symbol(.circle)
                .interpolationMethod(.catmullRom)
                
                AreaMark(
                    x: .value("Time", entry.timestamp, unit: viewModel.xAxisUnit),
                    y: .value("Energy Consumption", entry.powerUsage)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(areaBackground)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: viewModel.xAxisStrideUnit, count: viewModel.xAxisStrideCount)) { _ in
                AxisValueLabel(format: viewModel.xAxisLabelFormat, centered: true)
            }
        }
        .scrollDisabled(true)
        .frame(height: 300)
        .padding()
        .tappableChart(
            data: viewModel.aggregatedData,
            selectedPoint: $selectedEntry,
            xValue: { $0.timestamp },
            yValue: { $0.powerUsage },
            onSelectPoint: { entry in
                viewModel.navigateForward(to: entry.timestamp)
            }
        )
    }
}
