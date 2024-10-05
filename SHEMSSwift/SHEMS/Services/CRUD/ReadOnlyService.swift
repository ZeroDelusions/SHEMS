//
//  ReadOnlyService.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 02/10/2024.
//

import Foundation

class ReadOnlyService<D: Decodable, E: Encodable>: BaseService, Readable {
    var readEndpoint: String
    var readAllEndpoint: String
    
    init(baseEndpoint: String = "", readEndpoint: String = "", readAllEndpoint: String = "") {
        self.readEndpoint = readEndpoint
        self.readAllEndpoint = readAllEndpoint
        super.init(baseEndpoint: baseEndpoint)
    }
}
