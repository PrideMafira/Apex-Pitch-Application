//
//  AuthViewModel.swift
//  Apex Pitch Application
//
//  Created by admin on 25/3/2026.
//

import SwiftUI
import Supabase
internal import Combine

@MainActor

class AuthViewModel: ObservableObject {
    // Stores the active Supabase session.
    @Published var session: Session?
    // Tracks whether the user is signed in.
    @Published var isAuthenticated = false
    // Controls loading indicators during auth requests.
    @Published var isLoading = false
    // Holds any error message to show in the UI.
    @Published var errorMessage: String?
    // Holds success or status text for the UI.
    @Published var statusMessage: String?
    
    // Returns the current user's id if a session exists.
    var currentUserId: String? {
        session?.user.id.uuidString
    }
    
    // Returns the current user's email in a cleaned format.
    var currentUserEmail: String? {
        session?.user.email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    //MARK: Checks for an existing saved session when the app starts.
    func getInitialSession() async {
        do {
            let current = try await supabase.auth.session
            self.session = current
            self.isAuthenticated = true
            self.errorMessage = nil
            self.statusMessage = nil
        } catch {
            self.session = nil
            self.isAuthenticated = false
            // Prints a debug message when no active session is found.
            print("No active session: \(error.localizedDescription)")
        }
    }
    
    //MARK: Creates a new account with Supabase using the entered email and password.
    func signUp(email: String, password: String) async {
        // Removes accidental spaces from the email before sending it.
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        errorMessage = nil
        statusMessage = nil
        isLoading = true
        
        // Always stop the loading state when this function finishes.
        defer{ isLoading = false }
        do {
            let result = try await supabase.auth.signUp(email: trimmedEmail, password: password)
            self.session = result.session
            self.isAuthenticated = self.session != nil
            
            _ = result.user
            statusMessage = "Successfully created"
            
            // If there is no session yet, the account was created but not signed in automatically.
            if result.session == nil{
                statusMessage = "Account created."
            }
            
        } catch {
            self.errorMessage = error.localizedDescription
            // Prints the sign-up failure for debugging.
            print("Sign up failed: \(error.localizedDescription)")
        }
    }
    
    //MARK: Signs an existing user into the app.
    func signIn(email: String, password: String) async {
        // Cleans the email before sending it to Supabase.
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        errorMessage = nil
        statusMessage = nil
        isLoading = true
        
        // Always stop the loading state when sign-in finishes.
        defer{ isLoading = false }
        
        do {
            let result = try await supabase.auth.signIn(email: trimmedEmail, password: password)
            self.session = result
            self.isAuthenticated = self.session != nil
            self.errorMessage = nil
            
        } catch {
            self.session = nil
            self.isAuthenticated = false
            
            // Prints the sign-in failure for debugging.
            print("Sign in failed: \(error.localizedDescription)")
        }
    }
    
    //MARK: Signs the current user out and clears local auth state.
    func  logOut() async {
        do {
            try await supabase.auth.signOut()
            self.session = nil
            self.isAuthenticated = false
            self.errorMessage = nil
            self.statusMessage = nil
            
        } catch {
            self.errorMessage = error.localizedDescription
            // Prints the logout failure for debugging.
            print("Log Out failed: \(error.localizedDescription)")
        }
    }
}
