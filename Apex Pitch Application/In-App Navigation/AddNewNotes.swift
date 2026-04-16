////
////  AddNewNotes.swift
////  Apex Pitch Application
////
////  Created by admin on 30/3/2026.
////
import SwiftUI

struct AddFeedbackNoteView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var category: NoteCategory = .idea
    @State private var source = ""
    @State private var feedback = ""
    @State private var actionItems = ""
    
    //MARK: Called when the user saves a completed note.
    var onSave: (FeedbackNote) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Title", text: $title)
                        .autocorrectionDisabled()
                    
                    Picker("Category", selection: $category) {
                        ForEach(NoteCategory.allCases, id: \.self) { item in
                            Text(item.displayName).tag(item)
                        }
                    }
                    
                    TextField("Source / Person", text: $source)
                }
                
                //MARK: Main text area for the feedback the user received.
                Section("Feedback") {
                    TextField("What feedback did you receive?", text: $feedback, axis: .vertical)
                        .lineLimit(4...8)
                }
                
                // MARK: next actions after feedback
                Section("Action Items") {
                    TextField("What should be improved or done next?", text: $actionItems, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Feedback Note")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newNote = FeedbackNote(
                            id: nil,
                            title: title,
                            category: category,
                            source: source,
                            feedback: feedback,
                            actionItems: actionItems
                        )
                        onSave(newNote)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || feedback.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddFeedbackNoteView { _ in }
}
