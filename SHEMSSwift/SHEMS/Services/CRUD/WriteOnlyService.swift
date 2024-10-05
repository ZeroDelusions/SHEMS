//
//  WriteOnlyService.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 02/10/2024.
//

import Foundation

class WriteOnlyService<D: Decodable, E: Encodable>: BaseService, Creatable, Updatable, Deletable {
    var createEndpoint: String
    var updateEndpoint: String
    var deleteEndpoint: String
    
    init(
        baseEndpoint: String = "",
        createEndpoint: String = "",
        updateEndpoint: String = "",
        deleteEndpoint: String = ""
    ) {
        self.createEndpoint = createEndpoint
        self.updateEndpoint = updateEndpoint
        self.deleteEndpoint = deleteEndpoint
        super.init(baseEndpoint: baseEndpoint)
    }
}
