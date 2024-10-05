//
//  AuthenticatedService.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 22/09/2024.
//

import Foundation
import Alamofire
import Combine

protocol AuthenticatedService {
    var apiService: APIServiceProtocol { get }
    var baseEndpoint: String { get }
    func authenticatedRequest<D: Decodable, E: Encodable>(_ endpoint: String, method: HTTPMethod, parameters: E?, encoding: ParameterEncoding) -> AnyPublisher<D, APIError>
}

extension AuthenticatedService {
    func authenticatedRequest<D: Decodable, E: Encodable>(_ endpoint: String, method: HTTPMethod = .get, parameters: E? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> AnyPublisher<D, APIError> {
        guard let idToken = AuthService.shared.getIdToken() else {
            return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(idToken)"]
        return apiService.request(baseEndpoint + endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}

