//
//  Singleton.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 25/09/2024.
//

import Foundation

protocol Singleton {
    static var shared: Self { get }
}
