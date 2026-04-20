//
//  SignIn.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

struct SignIn: View {
    // Shared auth object so the view can trigger sign-in and react to loading or error changes.
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 50) {
                // MARK: Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sign In")
                        .font(.system(size: 34, weight: .bold))
                    
                    Text("Enter your credentials to access your account")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                
                // MARK: Form Fields
                VStack(spacing: 20) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        TextField("your@email.com", text: $email)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        SecureField("••••••••", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    .padding(.top, 8)
                }
                
                // Starts the async sign-in request with the values currently entered in the form.
                Button("Log in") {
                    Task {
                        await authViewModel.signIn(email: email, password: password)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .font(.callout)
                .foregroundStyle(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .contentShape(Rectangle())
                .buttonStyle(.plain)
                
                // Keeps the user informed while Supabase is processing the sign-in request.
                if authViewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                }
                
                // Surfaces any authentication failure from the view model directly under the button.
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                    
                }
                
                Spacer()
                
                // Provides a direct path to account creation when the user is new to the app.
                HStack {
                    Text("Don't have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    NavigationLink {
                        SignUp(authViewModel: authViewModel)
                    }label: {
                        Text("Create an account")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        
    }
}
#Preview {
    SignIn(authViewModel: AuthViewModel())
}



