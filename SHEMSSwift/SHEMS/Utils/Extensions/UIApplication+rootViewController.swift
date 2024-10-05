//
//  UIApplication+rootViewController.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 21/09/2024.
//

import Foundation
import UIKit

extension UIApplication {
    func rootViewController() -> UIViewController? {
        guard let window = connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) else {
            return nil
        }
        return window.rootViewController
    }
}
