//
//  HomePage.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("appIcon2")
                    .resizable()
                    .frame(width: 300,height: 300)
                Spacer()
      
                NavigationLink {
//                    TabPage()
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
                
                NavigationLink {
//                    Notes_Page()
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
                
                NavigationLink {
//                    Meetings(showWebView: "https://zoom.us/signin")
//                    Zoom_Meetings_Page(showWebView: "https://zoom.us/signin")
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
                

                        NavigationLink {
//                            Settings_Page()
                        } label: {
                            Image(systemName: "gearshape.2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding()
                                .foregroundStyle(.black)
                                .padding()
                        }
                        .offset(x: 150)
                        Spacer()
                    

                
            }
            .navigationTitle("Apex Pitch")
            .navigationSubtitle("Track your startup ideas.")
            
            
            
        }
    }
}

#Preview {
    HomePage()
}
