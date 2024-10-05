//
//  AlamofireLogger.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 02/10/2024.
//

import Foundation
import Alamofire

struct AlamofireLogger: EventMonitor {
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else { return }
        if let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) {
            print(json)
        } else if let string = String(data: data, encoding: .utf8) {
            print(string)
        }
    }
}
