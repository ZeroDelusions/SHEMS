//
//  APIServiceProtocol.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 02/10/2024.
//

import Foundation
import Combine
import Alamofire

protocol APIServiceProtocol {
    func request<D: Decodable, E: Encodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: E?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
    ) -> AnyPublisher<D, APIError>
}
