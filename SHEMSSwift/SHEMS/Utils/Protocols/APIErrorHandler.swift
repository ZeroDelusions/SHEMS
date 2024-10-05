//
//  APIErrorHandler.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 21/09/2024.
//

import Foundation
import SwiftUI
import Combine

protocol APIErrorHandler: ObservableObject {
    var apiError: APIError? { get set }
}

extension APIErrorHandler {
    func setError(_ error: APIError) {
        self.apiError = error
    }
    func clearError() {
        self.apiError = nil
    }
}


