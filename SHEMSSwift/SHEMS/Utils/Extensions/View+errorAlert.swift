//
//  View+errorAlert.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 21/09/2024.
//

import Foundation
import SwiftUI

extension View {
    func errorAlert<T: APIErrorHandler>(for viewModel: T, action: @escaping () -> Void) -> some View {
        self.modifier(ErrorAlert(apiError: Binding(
            get: { viewModel.apiError },
            set: { viewModel.apiError = $0 }
        ), action: action))
    }
}
