//
//  WelcomePage.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

/// First screen shown to signed-out users before entering the auth flow.
struct WelcomePage: View {
    @ObservedObject var authViewModel: AuthViewModel
    @AppStorage("darkMode") var darkMode: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Hero branding for the app's landing experience.
                Image("appIcon2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 380, height: 350)
                    .cornerRadius(20)
                    .foregroundStyle(.tint)
                Text("Welcome to Apex Pitch")
                    .font(.largeTitle)
                    .bold()
                Text("From first idea to First Investor!")
                    .font(.system(size: 23))
                    .padding()
            }
            .padding()
            
            // Moves the user into the sign-in flow while preserving the shared auth view model.
            NavigationLink {
                SignIn(authViewModel: authViewModel)
            } label: {
                Text("Get Started!")
                    .padding()
                    .font(.title)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .buttonStyle(.bordered)
                    .padding()
            }
        }
        .preferredColorScheme(darkMode ? .dark : .light)
    }
}

#Preview {
    WelcomePage(authViewModel: AuthViewModel())
}
