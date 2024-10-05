//
//  AuthViewModel.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 22/09/2024.
//

import Foundation
import Combine

class AuthViewModel: BaseViewModel<NoData> {
    @Published var isAuthenticated: Bool = false
    
    private let authService: AuthService
    private let userService: UserService
    
    init(authService: AuthService = .shared, userService: UserService = .shared) {
        self.authService = authService
        self.userService = userService
        super.init()
        
        authService.$isAuthenticated
            .assign(to: &$isAuthenticated)
    }
    
    func initializeAuthFlow() {
        restorePreviousSignIn()
    }

    func signIn() {
        authService.signIn()
            .sink(receiveCompletion: handleCompletion(_:),
                  receiveValue: { [weak self] in
                      self?.authenticateBackendUser()
                  })
            .store(in: &cancellables)
    }
    
    func signOut() {
        authService.signOut()
    }
    
    func restorePreviousSignIn() {
        authService.restorePreviousSignIn()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] in
                      self?.authenticateBackendUser()
                  })
            .store(in: &cancellables)
    }
    
    private func authenticateBackendUser() {
        authService.authenticateWithBackend()
            .sink(receiveCompletion: handleCompletion(_:),
                  receiveValue: { user in
                      assert(true, "Backend user authenticated: \(user)")
                  })
            .store(in: &cancellables)
    }

    func handleOpenURL(_ url: URL) {
        authService.handleOpenURL(url)
    }
}
