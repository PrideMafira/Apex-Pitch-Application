//
//  Settings.swift
//  Apex Pitch Application
//
//  Created by admin on 23/3/2026.
//
//

import SwiftUI
import Supabase

struct Settings: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var notificationsEnabled = true
    @AppStorage("darkMode") var darkMode: Bool = false
    @Environment(\.dismiss) var dismiss 
    
    //Local state to hold data fetched from Supabase
    @State private var userName: String = "Loading..."
    @State private var userEmail: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 15) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(userName)
                                .font(.headline)
                            Text(userEmail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("Account")) {
                    NavigationLink(destination: ProfileView()) {
                        Label("Profile", systemImage: "person.circle")
                    }
                    
                    //                    NavigationLink(destination: Text("Change Password View")) {
                    //                        Label("Change Password", systemImage: "lock")
                    //                    }
                }
                
                // Preferences Section
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $darkMode) {
                        Label("Dark Mode", systemImage: "moon")
                    }
                }
                
                // About Section
                Section(header: Text("About")) {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0").foregroundStyle(.secondary)
                    }
                }
                
                // MARK: Logs the user out through the shared auth view model.
                Section {
                    Button("Log Out", role: .destructive) {
                        Task {
                            await authViewModel.logOut()
                        }
                    }
                    .disabled(authViewModel.isLoading)
                }
            }
            .navigationTitle("Settings")
            
            // MARK: Quick return path back to the signed-in dashboard.
            NavigationLink {
                HomePage(authViewModel: authViewModel)
            } label: {
                Image(systemName: "house")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding()
                    .foregroundStyle(.blue)
                    .padding()
            }
            .offset(x: -150, y: 20)
            
            Spacer()
                .preferredColorScheme(darkMode ? .dark : .light)
        }
        
        //MARK: to pull the data from Supabase to display it on the app
        .task {
            do {
                let currentUser = try await supabase.auth.session.user
                let fetchedProfile: UserProfile = try await supabase
                    .from("profiles")
                    .select()
                    .eq("id", value: currentUser.id)
                    .single()
                    .execute()
                    .value
                
                self.userName = fetchedProfile.full_name ?? "No Name"
                self.userEmail = fetchedProfile.email ?? currentUser.email ?? ""
            } catch {
                print("Settings Load Error: \(error)")
                self.userName = "Profile Error"
            }
        }
    }
}

#Preview {
    Settings(authViewModel: AuthViewModel())
}

