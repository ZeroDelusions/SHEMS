//
//  BaseService.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 21/09/2024.
//

import Foundation
import Combine
import Alamofire

class BaseService: AuthenticatedService {    
    let apiService: APIServiceProtocol
    var baseEndpoint: String
    
    init(apiService: APIServiceProtocol = APIService.shared, baseEndpoint: String = "") {
        self.apiService = apiService
        self.baseEndpoint = baseEndpoint
    }
}

extension BaseService {
    func request<D: Decodable, E: Encodable>(_ endpoint: String, method: HTTPMethod = .get, parameters: E? = nil, encoding: ParameterEncoding = URLEncoding(destination: .methodDependent)) -> AnyPublisher<D, APIError> {
        return self.apiService.request(baseEndpoint + endpoint, method: method, parameters: parameters, encoding: encoding, headers: nil)
    }
}
