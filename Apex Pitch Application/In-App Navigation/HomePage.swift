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
                
                //MARK: Opens the idea management area where users can browse and create startup ideas.
                NavigationLink {
                    TabPage()
                } label: {
                    Text("Add idea")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
                
                //MARK: Opens the feedback note workflow for capturing investor or meeting takeaways.
                NavigationLink {
                    FeedbackNotesView()
                } label: {
                    Text("Add notes")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
                
                //MARK: Opens the embedded meetings screen for quick access to Zoom.
                NavigationLink {
                    meetingsPage(showWebView: "https://zoom.us/signin")
                } label: {
                    Text("Meetings")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
                
                //MARK: Keeps account and preference controls available without crowding the main actions.
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
