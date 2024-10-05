//
//  LoginView.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 20/09/2024.
//

import Foundation
import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            if authViewModel.isAuthenticated {
                Text("Welcome, you're logged in!")
                Button("Sign Out") {
                    authViewModel.signOut()
                }
            } else {
                Button("Sign In with Google") {
                    authViewModel.signIn()
                }
            }
        }
        .buttonStyle(PickerButtonStyle())
        .errorAlert(for: authViewModel) {
            authViewModel.signIn()
        }
    }
}
