//
//  SignIn.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

struct SignIn: View {
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 50) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sign In")
                        .font(.system(size: 34, weight: .bold))
                    
                    Text("Enter your credentials to access your account")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                
                // Form Fields
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
                    
                    // Remember Me & Forgot Password
                    HStack {
                        Toggle(isOn: $rememberMe) {
                            Text("Remember me")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                    }
                    .padding(.top, 8)
                }
                NavigationLink {
                    HomePage()
                } label: {
                    Text("Log In")
                        .frame(width: 340)
                        .padding()
                        .font(.caption)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .buttonStyle(.bordered)
                }
                .padding(.top, 16)
                
                Spacer()
                
                // Sign Up Link
                HStack {
                    Text("Don't have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    
                    // Sign up action
                    NavigationLink {
                        SignUp()
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
    SignIn()
}





