//
//  CRUDProtocols.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 02/10/2024.
//

import Foundation
import Combine
import Alamofire

// MARK: - Protocols

protocol IdentifiedItem: Encodable, Identifiable {
    var id: Int { get }
}

class NoData: Codable, IdentifiedItem {
    var id: Int
}

protocol APIDecodable {
    associatedtype D: Decodable
}

protocol APIEncodable {
    associatedtype E: Encodable
}

protocol APICodable: APIDecodable, APIEncodable { }

protocol Readable: APICodable {
    var readEndpoint: String { get }
    var readAllEndpoint: String { get }
    func get(path: String, parameters: E?) -> AnyPublisher<D, APIError>
    func getAll(path: String, parameters: E?) -> AnyPublisher<[D], APIError>
}

protocol Creatable: APICodable {
    var createEndpoint: String { get }
    func add(path: String, parameters: E) -> AnyPublisher<D, APIError>
}

protocol Updatable: APICodable {
    var updateEndpoint: String { get }
    func update(path: String, id: Int, parameters: E) -> AnyPublisher<D, APIError>
    func update(path: String, parameters: any IdentifiedItem) -> AnyPublisher<D, APIError>
}

protocol Deletable: APICodable {
    var deleteEndpoint: String { get }
    func delete(path: String, id: Int, parameters: E?) -> AnyPublisher<D, APIError>
    func delete(path: String, item: any IdentifiedItem, parameters: E?) -> AnyPublisher<D, APIError>
}

protocol CRUD: Readable, Creatable, Updatable, Deletable { }

// MARK: - Protocols extensions

extension Readable where Self: AuthenticatedService {
    func get(path: String = "", parameters: E? = nil) -> AnyPublisher<D, APIError> {
        return authenticatedRequest(self.readEndpoint, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
    }
    
    func getAll(path: String = "", parameters: E? = nil) -> AnyPublisher<[D], APIError> {
        return authenticatedRequest(self.readAllEndpoint + path, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
    }
}

extension Creatable where Self: AuthenticatedService {
    func add(path: String = "", parameters: E) -> AnyPublisher<D, APIError> {
        return authenticatedRequest(self.createEndpoint + path, method: .post, parameters: parameters)
    }
}

extension Updatable where Self: AuthenticatedService {
    func update(path: String = "", parameters: any IdentifiedItem) -> AnyPublisher<D, APIError> {
        return authenticatedRequest(self.updateEndpoint + path + "/\(parameters.id)", method: .put, parameters: parameters)
    }
    
    func update(path: String = "", id: Int, parameters: E) -> AnyPublisher<D, APIError> {
        return authenticatedRequest(self.updateEndpoint + path + "/\(id)", method: .put, parameters: parameters)
    }
}

extension Deletable where Self: AuthenticatedService {
    func delete(path: String = "", id: Int, parameters: E? = nil) -> AnyPublisher<D, APIError> {
        return authenticatedRequest(self.deleteEndpoint + path + "/\(id)", method: .delete, parameters: parameters)
    }
    
    func delete(path: String = "", item: any IdentifiedItem, parameters: E? = nil) -> AnyPublisher<D, APIError> {
        return authenticatedRequest(self.deleteEndpoint + path + "/\(item.id)", method: .delete, parameters: parameters)
    }
}
