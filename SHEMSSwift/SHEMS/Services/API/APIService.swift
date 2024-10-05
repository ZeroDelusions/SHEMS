//
//  APIService.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 20/09/2024.
//

import Foundation
import Alamofire
import Combine

final class APIService: Singleton, APIServiceProtocol {
    static let shared = APIService()
    
    private let baseURL: URL
    private let session: Session
    private let timeoutInterval: TimeInterval = 30
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        
        let eventMonitors: [EventMonitor] = {
            #if DEBUG
            return [AlamofireLogger()]
            #else
            return []
            #endif
        }()
        
        self.baseURL = {
            var components = URLComponents()
            components.scheme = "http"
            components.host = "localhost"
            components.port = 8080
            components.path = "/api/v1"
            return components.url!
        }()
        
        self.session = Session(configuration: configuration, eventMonitors: eventMonitors)
    }
    
    func request<D: Decodable, E: Encodable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        parameters: E? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<D, APIError> {
        let url = baseURL.appending(path: endpoint)
        
        let encodedParameters = parameters?.dictionary ?? parameters as? [String: Any]

        return session.request(url, method: method, parameters: encodedParameters, encoding: encoding, headers: headers)
            .validate()
            .publishDecodable(type: D.self, decoder: Self.jsonDecoder)
            .tryMap { response -> D in
                if let error = response.error {
                    throw self.mapToAPIError(error)
                }
                
                // Handle empty response for Void type
                if D.self == Void.self {
                    return () as! D // Cast Void to D
                }
                
                // Decode response for non-Void types
                guard let data = response.data else {
                    throw APIError.unknownError("Response data is nil")
                }
                
                let decodedValue = try Self.jsonDecoder.decode(D.self, from: data)
                return decodedValue
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .unknownError(error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func mapToAPIError(_ error: AFError) -> APIError {
        switch error {
        case .responseValidationFailed(reason: .unacceptableStatusCode(let code)):
            switch code {
            case 401:
                return .unauthorized
            default:
                return .httpError(code)
            }
        case .responseSerializationFailed(reason: .decodingFailed(let error)):
            return .decodingError(error)
        default:
            return .networkError(error)
        }
    }
    
    private static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // Try decoding with fractional seconds
            let iso8601FormatterWithFractionalSeconds = ISO8601DateFormatter()
            iso8601FormatterWithFractionalSeconds.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = iso8601FormatterWithFractionalSeconds.date(from: dateString) {
                return date
            }
            
            // Fallback to decoding without fractional seconds
            let iso8601Formatter = ISO8601DateFormatter()
            iso8601Formatter.formatOptions = [.withInternetDateTime]
            
            if let date = iso8601Formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        }
        return decoder
    }()
}


