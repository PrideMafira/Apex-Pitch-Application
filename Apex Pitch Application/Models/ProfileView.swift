//
//  ProfileView.swift
//  Apex Pitch Application
//
//  Created by admin on 13/4/2026.
//

import SwiftUI
import Foundation
import SwiftData

struct ProfileView: View {
    @AppStorage("username") var username: String = ""
    @AppStorage("email") var email: String = ""
    @State private var isEditing = false
    
    var body: some View {
        Form {
            Section(header: Text("User Information")) {
                if isEditing {
                    TextField("Username", text: $username)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                } else {
                    LabeledContent("Username", value: username)
                    LabeledContent("Email", value: email)
                }
            }
            
            Section {
                Button(isEditing ? "Save Changes" : "Edit Profile") {
                    isEditing.toggle()
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    ProfileView()
}
