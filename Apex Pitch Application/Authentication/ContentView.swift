//
//  ContentView.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

/// Root container that switches between the signed-out and signed-in flows.
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
            // Restore any existing user session on launch so the user does not have to sign in every time.
            await authViewModel.getInitialSession()
        }
    }
}

#Preview {
    ContentView()
}
