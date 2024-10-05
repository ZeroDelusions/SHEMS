//
//  ErrorAlert.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 02/10/2024.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var message: String
}

struct ErrorAlert: ViewModifier {
    @Binding var apiError: APIError?
    var action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .alert(item: Binding<AlertItem?>(
                get: { apiError.map { AlertItem(message: $0.localizedDescription) } },
                set: { _ in apiError = nil }
            )) { alertItem in
                if let action {
                    Alert(
                        title: Text("Error"),
                        message: Text(alertItem.message),
                        primaryButton: .default(Text("Retry")) { action() },
                        secondaryButton: .cancel()
                    )
                } else {
                    Alert(title: Text("Error"), message: Text(alertItem.message))
                }
            }
    }
}
