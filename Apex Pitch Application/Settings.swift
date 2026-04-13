//
//  Settings.swift
//  Apex Pitch Application
//
//  Created by admin on 23/3/2026.
//
import SwiftUI

struct Settings: View {
    @State private var notificationsEnabled = true
    @AppStorage("darkMode") var darkMode: Bool = false
    @Environment(\.dismiss) var dismiss // Used to go back home
    
    var body: some View {
        NavigationStack {
            Form {
                // Account Section - Now Clickable!
                Section(header: Text("Account")) {
                    NavigationLink(destination: ProfileView()) {
                        Label("Profile", systemImage: "person.circle")
                    }
                    
                    NavigationLink(destination: Text("Change Password View")) {
                        Label("Change Password", systemImage: "lock")
                    }
                }
                
                // Preferences Section
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell")
                    }
                    
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
                
                // Logout Section
                Section {
                    Button(role: .destructive) {
                        // Action here
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log Out")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(darkMode ? .dark : .light)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss() // Standard way to go back
                    } label: {
                        Image(systemName: "house")
                    }
                }
            }
        }
    }
}

#Preview {
    Settings()
}
