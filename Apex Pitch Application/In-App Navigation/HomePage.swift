//
//  HomePage.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI
internal import Combine

struct HomePage: View {
    @ObservedObject var authViewModel: AuthViewModel
    @AppStorage("darkMode") var darkMode: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Image("appIcon2")
                    .resizable()
                    .frame(width: 300,height: 300)
                Spacer()
                
                //MARK: Link to tabs page
                NavigationLink {
                    TabPage()
                } label: {
                    Text("Add idea")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // This makes the label expand horizontally
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
                
                //MARK: link to the notes page
                NavigationLink {
                       FeedbackNotesView()
                } label: {
                    Text("Add notes")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // This makes the label expand horizontally
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
                
                //MARK: Link to the meetings page
                NavigationLink {
                    meetingsPage(showWebView: "https://zoom.us/signin")
                } label: {
                    Text("Meetings")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // This makes the label expand horizontally
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
                
                //MARK: Link to the Settings page
                NavigationLink {
                    Settings(authViewModel: authViewModel)
                } label: {
                    Image(systemName: "gearshape.2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding()
                        .foregroundStyle(.blue)
                        .padding()
                }
                .offset(x: 150)
                Spacer()
                
            }
            .navigationTitle("Apex Pitch")
            .navigationSubtitle("Track your startup ideas.")
        }
        .preferredColorScheme(darkMode ? .dark : .light)
    }
}

#Preview {
    HomePage(authViewModel: AuthViewModel())
}
