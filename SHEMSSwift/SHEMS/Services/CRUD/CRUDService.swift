//
//  CRUDService.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 25/09/2024.
//

import Foundation
import Combine
import Alamofire

class CRUDService<D: Decodable, E: Encodable>: BaseService, CRUD {
    var readEndpoint: String
    var readAllEndpoint: String
    var createEndpoint: String
    var updateEndpoint: String
    var deleteEndpoint: String
    
    init(
        baseEndpoint: String = "",
        readEndpoint: String = "",
        readAllEndpoint: String = "",
        createEndpoint: String = "",
        updateEndpoint: String = "",
        deleteEndpoint: String = ""
    ) {
        self.readEndpoint = readEndpoint
        self.readAllEndpoint = readAllEndpoint
        self.createEndpoint = createEndpoint
        self.updateEndpoint = updateEndpoint
        self.deleteEndpoint = deleteEndpoint
        super.init(baseEndpoint: baseEndpoint)
    }
}
