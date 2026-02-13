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
    @State private var showPassword = false
    @State private var goToSignUpPage = false
    //    @State private var isLoggedIn = false
    //    @State private var showAlert = false
    //    @State private var alertMessage = ""
    //    @State private var forgotPassword = false
    
    var body: some View {

            NavigationStack {
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Enter your details to login into your account!")
                    
                        .padding()
                    
                   
                    VStack {

                            TextField("Enter your email address", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .cornerRadius(3)
                                .padding()
                        
                        TextField("Enter your password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .cornerRadius(3)
                            .padding()
                        
                    }
                    .padding()

                }
                NavigationLink {
                    SignUp()
                } label: {
                    Text("Log In")
                        .padding()
                        .font(.caption)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .buttonStyle(.bordered)
                }
                .padding()
                HStack {
                    Text("dont have an account?                  ")
                        .padding(30)
                    Spacer()
                    
                    Button("Sign up") {
                        goToSignUpPage = true
                        
                    }
        //                Spacer()
        //                .padding()
                    .offset(x: -87, y: 0)
                    
                }
                .padding()
                
    //            HStack {
    //                if showPassword {
    //                    TextField("Password", text: $password)
    //            } else {
    //                SecureField("Password", text: $password)
    //            }
    //            }
                
            }
        }
}

#Preview {
    SignIn()
}





