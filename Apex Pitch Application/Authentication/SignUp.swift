//
//  SignUp.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

struct SignUp: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                //MARK: Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text("Enter your credentials to access your account")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 25)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    TextField("Enter your name", text: $fullName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
                
                //email textfield
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    TextField("your@email.com", text: $email)
                        .autocapitalization(.none)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
                
                //Password
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    SecureField("••••••••", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
                
                //Passwords (re-enter)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm Password")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    SecureField("••••••••", text: $confirmPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
                
                // Prevents the request from being sent unless both password fields agree.
                Button("Sign up"){
                    if password != confirmPassword {
                        authViewModel.errorMessage = "Passwords do not match."
                        authViewModel.statusMessage = nil
                        return
                    }
                    Task {
                        await authViewModel.signUp(email: email, password: password)
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
                
                // Show the status text only when a message is available.
                if let statusMessage = authViewModel.statusMessage {
                    Text(statusMessage)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }
                
                // Show the error text only when the view model provides one.
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                // Gives existing users a way back to the sign-in screen.
                HStack {
                    Text("Already have an account?")
                    
                    NavigationLink {
                        SignIn(authViewModel: authViewModel)
                    }label: {
                        Text("Login")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                }
                .font(.footnote)
                .foregroundColor(.gray)
                .offset(y: 20)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    SignUp(authViewModel: AuthViewModel())
}
