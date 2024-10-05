//
//  LoadingModifier.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 01/10/2024.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .padding()
            Text("Loading...")
                .font(.caption)
        }
        .background(Color(UIColor.systemBackground).opacity(0.8))
        .cornerRadius(8)
    }
}


struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                LoadingView()
            }
        }
    }
}

extension View {
    func loadingOverlay(isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading))
    }
}

