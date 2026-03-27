//
//  ContentView.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

struct ContentView: View {
    // Stores the app's auth state.
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            // Show the home page when the user is signed in.
            if authViewModel.isAuthenticated {
                HomePage(authViewModel: authViewModel)
            } else {
                // Show the welcome page when the user is signed out.
                WelcomePage(authViewModel: authViewModel)
            }
        }
        .task {
            // Restore any existing user session on launch.
            await authViewModel.getInitialSession()
        }
    }
}

#Preview {
    ContentView()
}
