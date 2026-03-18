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
        @State private var reEnterPassword = ""
        
        var body: some View {
            NavigationStack {
                VStack {
                    Text("Sign up")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Create an account")
                    
                    TextField("Enter your full name", text: $fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .cornerRadius(3)
                        .padding()
                    
                    
                    TextField("example@gmail.com", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .cornerRadius(3)
                        .padding()
                    
                    
                    TextField("enter password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .cornerRadius(3)
                        .padding()
                    
                    SecureField("re-enter password", text: $reEnterPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .cornerRadius(3)
                        .padding()
                    
                }
                .padding()
                
                NavigationLink {
                    HomePage()
                } label: {
                    Text("Sign up")
                        .padding()
                        .font(.caption)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .buttonStyle(.bordered)
                }
            }
        }
    }

#Preview {
    SignUp()
}
