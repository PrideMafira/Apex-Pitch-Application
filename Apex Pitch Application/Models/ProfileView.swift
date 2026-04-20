//
//  ProfileView.swift
//  Apex Pitch Application
//
//  Created by admin on 13/4/2026.
//

import SwiftUI
import Supabase


struct ProfileView: View {
    @State private var profile: UserProfile?
    @State private var isEditing = false
    @State private var isLoading = false
    
    @State private var editedUsername = ""
    
    var body: some View {
        Form {
            if isLoading {
                ProgressView("Loading profile...")
            } else {
                Section(header: Text("User Information")) {
                    if isEditing {
                        // Editable Name
                        TextField("Full Name", text: $editedUsername)
                    
                        LabeledContent("Email", value: profile?.email ?? "Not set")
                            .foregroundStyle(.secondary)
                    } else {
                        LabeledContent("Username", value: profile?.full_name ?? "Not set")
                        LabeledContent("Email", value: profile?.email ?? "Not set")
                    }
                }
                
                Section {
                    Button(isEditing ? "Save Changes" : "Edit Profile") {
                        if isEditing {
                            Task { await updateProfile() }
                        }
                        isEditing.toggle()
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await fetchProfile()
        }
    }
    
    // MARK: Fetch Data
    func fetchProfile() async {
        isLoading = true
        do {
            let currentUser = try await supabase.auth.session.user
            
            let fetchedProfile: UserProfile = try await supabase
                .from("profiles")
                .select()
                .eq("id", value: currentUser.id)
                .single()
                .execute()
                .value
            
            self.profile = fetchedProfile
            self.editedUsername = fetchedProfile.full_name ?? ""
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    // MARK: Update Name Only
    func updateProfile() async {
        guard let userId = profile?.id else { return }
        
        do {
            // Only update the full name field in Supabase
            try await supabase
                .from("profiles")
                .update(["full_name": editedUsername])
                .eq("id", value: userId)
                .execute()
            
            // Sync local state
            self.profile?.full_name = editedUsername
        } catch {
            print("Update failed: \(error)")
        }
    }
}


#Preview {
    ProfileView()
}
