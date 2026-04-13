//
//  Settings.swift
//  Apex Pitch Application
//
//  Created by admin on 23/3/2026.
//
import SwiftUI

struct Settings: View {
    @State private var notificationsEnabled = true
      @State private var darkMode = false
  
      var body: some View {
          NavigationStack {
              Form {
  
                  // Account Section
                  Section(header: Text("Account")) {
                      HStack {
                          Image(systemName: "person.circle")
                              .foregroundStyle(.primary)
                          Text("Profile")
                      }
  
                      HStack {
                          Image(systemName: "lock")
                              .foregroundStyle(.primary)
                          Text("Change Password")
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
                      .toggleStyle(SwitchToggleStyle(tint: .blue))
                  }

  
                  // About Section
                  Section(header: Text("About")) {
                      HStack {
                          Text("Version")
                          Spacer()
                          Text("1.0.0")
                              .foregroundStyle(.secondary)
                      }
                  }
  
                  // Logout Section
                  Section {
                      Button(role: .destructive) {
                          // Handle logout
                      } label: {
                          Text("Log Out")
                      }
                  }
              }
              .navigationTitle("Settings")
          }
          .preferredColorScheme(darkMode ? .dark : .light)
      }
}

#Preview {
    Settings()
}
