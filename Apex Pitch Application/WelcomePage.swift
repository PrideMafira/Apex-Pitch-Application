//
//  WelcomePage.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

struct WelcomePage: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("appIcon2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 380, height: 350)
                    .cornerRadius(20)
                    .foregroundStyle(.tint)
                Text("Welcome to Apex Pitch")
                    .font(.largeTitle)
                    .bold()
//                    .padding()
                
                Text("From first idea to First Investor!")
                    .font(.system(size: 23))
                    .padding()
            }
            .padding()
            
            NavigationLink {
               SignIn()
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
    }
}

#Preview {
    WelcomePage()
}
