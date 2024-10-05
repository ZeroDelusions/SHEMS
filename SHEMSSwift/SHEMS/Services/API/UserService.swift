//
//  UserService.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 22/09/2024.
//

import Foundation
import Alamofire
import Combine

final class UserService: ReadOnlyService<User, NoData>, Singleton {
    static let shared = UserService()
    
    init() {
        super.init(
            baseEndpoint: "/auth",
            readEndpoint: "/success"
        )
    }
}

