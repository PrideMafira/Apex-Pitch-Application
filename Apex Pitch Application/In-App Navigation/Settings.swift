//
//  Settings.swift
//  Apex Pitch Application
//
//  Created by admin on 23/3/2026.
//

import SwiftUI

struct Settings: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var notificationsEnabled = true
    @AppStorage("darkMode") private var darkMode = false

    var body: some View {
        NavigationStack {
            Form {
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

                // MARK: Preferences that are stored locally on the device.
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))

                    Toggle(isOn: $darkMode) {
                        Label("Dark Mode", systemImage: "moon")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }

                // MARK: About section.
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
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
        }
        .preferredColorScheme(darkMode ? .dark : .light)
    }
}

#Preview {
    Settings(authViewModel: AuthViewModel())
}
