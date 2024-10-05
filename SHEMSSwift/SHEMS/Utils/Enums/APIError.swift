//
//  APIError.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 02/10/2024.
//

import Foundation
import Alamofire

enum APIError: Error {
    case networkError(AFError)
    case decodingError(Error)
    case invalidURL
    case unauthorized
    case httpError(Int)
    case unknownError(String? = nil)
    
    var localizedDescription: String {
        switch self {
        case .networkError(let afError):
            return "Network error: \(afError.localizedDescription)"
        case .decodingError(let error):
            return "Failed to process the server response: \(error.localizedDescription)"
        case .invalidURL:
            return "Invalid URL"
        case .unauthorized:
            return "Unauthorized access to endpoint"
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode)"
        case .unknownError(let message):
            return message ?? "An unknown error occurred"
        }
    }
}
