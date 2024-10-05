//
//  ChartSelectableOverlay.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 29/09/2024.
//

import Foundation
import SwiftUI
import Charts

struct TappableChartModifier<T: Chartable>: ViewModifier {
    let data: [T]
    @Binding var selectedPoint: T?
    let xValue: (T) -> Date
    let yValue: (T) -> Double
    let maxDistance: CGFloat
    let onSelectPoint: ((T) -> Void)?
    
    @State private var dragLocation: CGPoint = .zero
    
    func body(content: Content) -> some View {
        content
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    updateSelection(at: value.location, proxy: proxy, geometry: geometry)
                                }
                        )
                }
            }
    }
    
    private func updateSelection(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let relativeXPosition = location.x / geometry.size.width
        guard let firstDate = data.first.map(xValue),
              let lastDate = data.last.map(xValue) else { return }
        
        // Interpolate the date based on the X position between the first and last points
        let timeInterval = lastDate.timeIntervalSince(firstDate)
        let interpolatedDate = firstDate.addingTimeInterval(timeInterval * relativeXPosition)
        
        if let closestPoint = data.min(by: {
            abs(xValue($0).timeIntervalSince(interpolatedDate)) <
            abs(xValue($1).timeIntervalSince(interpolatedDate))
        }) {
            selectedPoint = closestPoint
            onSelectPoint?(closestPoint)
        }
    }

    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

extension View {
    func tappableChart<T: Chartable>(
        data: [T],
        selectedPoint: Binding<T?>,
        xValue: @escaping (T) -> Date,
        yValue: @escaping (T) -> Double,
        maxDistance: CGFloat = 200,
        onSelectPoint: ((T) -> Void)? = nil
    ) -> some View {
        self.modifier(TappableChartModifier(
            data: data,
            selectedPoint: selectedPoint,
            xValue: xValue,
            yValue: yValue,
            maxDistance: maxDistance,
            onSelectPoint: onSelectPoint
        ))
    }
}

extension CGPoint {
    func offset(in rect: CGRect) -> CGPoint {
        CGPoint(x: self.x + rect.minX, y: self.y + rect.minY)
    }
}
