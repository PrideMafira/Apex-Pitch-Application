////
////  addIdeaPage.swift
////  Apex Pitch Application
////
////  Created by Pride Mafira  on 13/2/2026.
////

import SwiftUI
import Supabase

struct addIdeaPage: View {
    @State private var startupName: String = ""
    @State private var description: String = ""
    @State private var selectedStage: Types = .concepts
    @State private var fundingGoal: String = ""
    @State private var fundingRaised: String = ""
    
    // Track loading state for the UI
    @State private var isSaving = false
    @State private var saveErrorMessage: String?
    
    @Environment(\.dismiss) var dismiss
    @Binding var ideas: [Idea]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Startup Details")) {
                        TextField("Enter startup name", text: $startupName)
                        
                        ZStack(alignment: .topLeading) {
                            if description.isEmpty {
                                Text("Enter idea description...")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }
                            TextEditor(text: $description)
                                .frame(minHeight: 100)
                        }
                    }
                    
                    Section(header: Text("Funding")) {
                        TextField("Goal (e.g. 10000)", text: $fundingGoal)
                            .keyboardType(.numberPad)
                        
                        TextField("Raised (e.g. 10)", text: $fundingRaised)
                            .keyboardType(.numberPad)
                    }
                    
                    Section(header: Text("Stage")) {
                        Picker("Stage", selection: $selectedStage) {
                            ForEach(Types.allCases, id: \.self) { stage in
                                Text(stage.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                HStack {
                    // Closes the form without mutating local state or sending anything to Supabase.
                    Button("Cancel") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    
                    Button {
                        // Runs the network write on a task so the button can trigger async work.
                        Task {
                            await saveIdeaToSupabase()
                        }
                    } label: {
                        if isSaving {
                            // Replaces the button title while the request is still in flight.
                            ProgressView()
                        } else {
                            Text("Add Idea")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(!isFormValid || isSaving)
                }
                .padding()
            }
            .navigationTitle("Add New Idea")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Unable to Save Idea", isPresented: saveErrorMessageBinding) {
                Button("OK", role: .cancel) {
                    saveErrorMessage = nil
                }
            } message: {
                Text(saveErrorMessage ?? "Please try again.")
            }
        }
    }
    
    // Validates the form, writes the idea to Supabase, then updates the local list on success.
    func saveIdeaToSupabase() async {
        isSaving = true
        
        let newIdea = Idea(
            startupName: startupName,
            ideaDescription: description,
            fundingGoal: fundingGoal,
            fundingRaised: fundingRaised,
            type: selectedStage
        )
        let record = newIdea.asSupabaseRecord()
        
        do {
            _ = try await supabase.auth.session
            
            guard record.fundingGoal != nil, record.fundingRaised != nil else {
                saveErrorMessage = "Funding goal and amount raised must be valid numbers."
                isSaving = false
                return
            }
            
            try await supabase
                .from("Ideas Table")
                .insert(record)
                .execute()
            
            // Mirror the remote insert locally so the user sees the new card immediately.
            ideas.append(newIdea)
            dismiss()
        } catch {
            let message = error.localizedDescription
            
            if message == "Auth session missing." {
                saveErrorMessage = "You need to sign in before saving an idea."
            } else if message.contains("row-level security policy") {
                saveErrorMessage = "Supabase rejected the insert because your table policy does not allow this user to add ideas."
            } else {
                saveErrorMessage = message
            }
        }
        
        isSaving = false
    }
    
    private var isFormValid: Bool {
        // Keeps the save button disabled until the required fields contain non-empty values.
        !startupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !fundingGoal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !fundingRaised.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var saveErrorMessageBinding: Binding<Bool> {
        // Bridges the optional error message into the Boolean binding expected by .alert.
        Binding(
            get: { saveErrorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    saveErrorMessage = nil
                }
            }
        )
    }
}


#Preview {
    addIdeaPage(ideas: .constant([]))
}
