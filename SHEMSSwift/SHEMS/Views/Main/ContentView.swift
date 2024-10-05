//
//  ContentView.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 20/09/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isAuthenticated {
            MainView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
