//
//  User.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 20/09/2024.
//

import Foundation

struct User: Codable, IdentifiedItem {
    let id: Int
    let googleId: String?
    let email: String
    let name: String
}
