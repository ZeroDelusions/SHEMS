//
//  AuthService.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 21/09/2024.
//

import Foundation
import GoogleSignIn
import Combine

final class AuthService: ObservableObject, Singleton {
    static let shared = AuthService()
    
    @Published var user: GIDGoogleUser?
    @Published var isAuthenticated: Bool = false

    private init() {}

    func signIn() -> AnyPublisher<Void, APIError> {
        return Future { promise in
            guard let rootViewController = UIApplication.shared.rootViewController() else {
                promise(.failure(APIError.unknownError("No root view controller found")))
                return
            }

            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
                if let error = error {
                    promise(.failure(APIError.unknownError(error.localizedDescription)))
                    return
                }
                
                guard let result = signInResult else {
                    promise(.failure(APIError.unknownError("Sign in failed with unknown error")))
                    return
                }

                self?.user = result.user
                self?.isAuthenticated = true
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.user = nil
        self.isAuthenticated = false
    }
    
    func restorePreviousSignIn() -> AnyPublisher<Void, APIError> {
        return Future { promise in
            GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                if let error = error {
                    promise(.failure(APIError.unknownError(error.localizedDescription)))
                    return
                }

                self?.user = user
                self?.isAuthenticated = user != nil
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }

    // Handles opening URLs for Google sign-in process
    func handleOpenURL(_ url: URL) {
        GIDSignIn.sharedInstance.handle(url)
    }

    func authenticateWithBackend() -> AnyPublisher<User, APIError> {
        return UserService.shared.get()
    }

    func getIdToken() -> String? {
        return user?.idToken?.tokenString
    }
}
