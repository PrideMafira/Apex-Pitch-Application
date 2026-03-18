//
//  addIdeaPage.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

struct addIdeaPage: View {
    @State private var startupName: String = ""
    @State private var description: String = ""
    @State private var selectedStage: Types = .concepts
    @State private var fundingGoal: String = ""
    @State private var fundingRaised: String = ""
    
    @Environment(\.dismiss) var dismiss
    @Binding var ideas: [Idea]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Startup Details")) {
                        TextField("Enter startup name", text: $startupName)
                        
                        // TextEditor
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
                
                // Action buttons
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    
                    // Enable button only when required fields are filled
                    Button("Add Idea") {
                        let newIdea = Idea(
                            startupName: startupName,
                            ideaDescription: description,
                            fundingGoal: fundingGoal,
                            fundingRaised: fundingRaised,
                            type: selectedStage
                        )
                        ideas.append(newIdea)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(!isFormValid)
                }
                .padding()
            }
            .navigationTitle("Add New Idea")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Computed property to validate form
    private var isFormValid: Bool {
        !startupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !fundingGoal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !fundingRaised.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    addIdeaPage(ideas: .constant([]))
}


