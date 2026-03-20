//
//  SignUp.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

struct SignUp: View {

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                
                //Header
                VStack(alignment: .leading, spacing: 10) {
                    //                Spacer()
                    
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
                
            //Textfields
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
                    
                    
                    //Navigation to Pages
                    NavigationLink {
//                                HomePage()
                    }label: {
                        Text("Sign Up")
                            .frame(width: 340)
                            .padding()
                            .font(.caption)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                            .buttonStyle(.bordered)
                    }
                    .padding(.top, 10)
                    
                    //Navigation to login page
                    HStack {
                        Text("Already have an account?")
                        
                        NavigationLink {
                                SignIn()
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
                .background(Color.white)
            }
        }
    }

#Preview {
    SignUp()
}
