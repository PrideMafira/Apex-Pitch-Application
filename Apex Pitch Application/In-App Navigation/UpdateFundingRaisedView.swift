

import SwiftUI
import Supabase

struct UpdateFundingRaisedView: View {
 @Environment(\.dismiss) private var dismiss
 @Binding var idea: Idea
 @State private var amountReceived: String = ""
 @State private var isSaving = false
 @State private var errorMessage: String?
 
 var body: some View {
     NavigationStack {
         Form {
             // Displays current static data from the Idea object
             Section("Current") {
                 LabeledContent("Goal") {
                     Text("$\(idea.fundingGoal)")
                 }
                 
                 LabeledContent("Raised") {
                     Text("$\(idea.fundingRaised)")
                 }
             }
             
             //MARK: Section for user input and real-time calculation previews
             Section("Add Funding") {
                 TextField("Amount received (e.g. 250)", text: $amountReceived)
                     .keyboardType(.decimalPad)
                 
                 // Show a preview only if the input is valid
                 if let preview = previewRaised {
                     LabeledContent("New Raised") {
                         Text("$\(Idea.formattedAmount(preview))")
                     }
                     
                     let progress = progress(forRaised: preview)
                     LabeledContent("Progress") {
                         Text("\(Int(progress * 100))%")
                             .foregroundStyle(.blue)
                     }
                 }
             }
             
             // Submission Button
             Section {
                 Button {
                     Task { await save() }
                 } label: {
                     if isSaving {
                         // Show spinner during network request
                         ProgressView()
                     } else {
                         Text("Update Amount Raised")
                     }
                 }
                 // Prevent submission if input is invalid or currently saving
                 .disabled(!canSave || isSaving)
             }
         }
         .navigationTitle("Update Funding")
         .navigationBarTitleDisplayMode(.inline)
         .toolbar {
             ToolbarItem(placement: .topBarLeading) {
                 Button("Cancel") { dismiss() }
             }
         }
         // Error handling alert
         .alert("Unable to Update", isPresented: errorMessagePresented) {
             Button("OK", role: .cancel) { errorMessage = nil }
         } message: {
             Text(errorMessage ?? "Please try again.")
         }
     }
 }
 
 // MARK: - Computed Properties
 
 //Calculates what the total raised would be based on current input
 private var previewRaised: Double? {
     guard let amount = parsedAmountReceived else { return nil }
     return max(idea.fundingRaisedValue + amount, 0)
 }
 
 //Converts the String input into a valid Double
 private var parsedAmountReceived: Double? {
     let trimmed = amountReceived.trimmingCharacters(in: .whitespacesAndNewlines)
     guard !trimmed.isEmpty, let value = Double(trimmed), value > 0 else { return nil }
     return value
 }
 
 //Validation logic to enable the save button
 private var canSave: Bool {
     idea.id != nil && parsedAmountReceived != nil
 }
 
 // Custom binding to bridge the optional errorMessage to a Boolean alert state
 private var errorMessagePresented: Binding<Bool> {
     Binding(
         get: { errorMessage != nil },
         set: { isPresented in
             if !isPresented { errorMessage = nil }
         }
     )
 }
 
 // MARK: - Helper Methods
 private func progress(forRaised raised: Double) -> Double {
     let goal = idea.fundingGoalValue
     guard goal > 0 else { return 0 }
     return min(max(raised / goal, 0), 1)
 }
 

 @MainActor
 private func save() async {
     // Validation Check
     guard let ideaId = idea.id else {
         errorMessage = "This idea hasn't been synced yet. Pull to refresh and try again."
         return
     }
     
     guard let amount = parsedAmountReceived else {
         errorMessage = "Enter a valid amount greater than 0."
         return
     }
     
     // Ensures spinner stops even if request fails
     isSaving = true
     defer { isSaving = false }
     
     let newRaised = idea.fundingRaisedValue + amount
     // Determine if this update pushes the idea into the "Funded" status
     let shouldMarkFunded = idea.fundingGoalValue > 0 && newRaised >= idea.fundingGoalValue
     
     do {
         //MARK: Update the funding amount in Supabase
         try await supabase
             .from("Ideas Table")
             .update(["fundingRaised": newRaised])
             .eq("id", value: ideaId)
             .execute()
         
         //MARK: If goal reached, update the status stage in the database
         if shouldMarkFunded && idea.type != .funded {
             try await supabase
                 .from("Ideas Table")
                 .update(["stage": Types.funded.rawValue])
                 .eq("id", value: ideaId)
                 .execute()
         }
         
         // MARK: Update the local @Binding object so the UI refreshes instantly
         idea.fundingRaised = Idea.formattedAmount(newRaised)
         if shouldMarkFunded {
             idea.type = .funded
         }
         
         // Close the view on success
         dismiss()
         
     } catch {
         errorMessage = error.localizedDescription
     }
 }
}

// MARK: - Preview
#Preview {
 UpdateFundingRaisedView(
     idea: .constant(
         Idea(
             id: 1,
             startupName: "Apex",
             ideaDescription: "Pitch app",
             fundingGoal: "0",
             fundingRaised: "0",
             type: .concepts
         )
     )
 )
}
