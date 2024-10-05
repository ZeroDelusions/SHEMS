//
//  SHEMSApp.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 20/09/2024.
//

import SwiftUI
import GoogleSignIn

@main
struct SHEMSApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .onOpenURL { url in
                    authViewModel.handleOpenURL(url)
                }
                .onAppear {
                    authViewModel.initializeAuthFlow()
                }
        }
    }
}

