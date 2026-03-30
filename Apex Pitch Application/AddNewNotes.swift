//
//  AddNewNotes.swift
//  Apex Pitch Application
//
//  Created by admin on 30/3/2026.
//
import SwiftUI

struct AddFeedbackNoteView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Form field for the note title.
    @State private var title = ""
    // Currently selected feedback category.
    @State private var category: FeedbackNote.Category = .idea
    // Source of the feedback, such as a person or meeting.
    @State private var source = ""
    @State private var date = Date()
    @State private var feedback = ""
    @State private var actionItems = ""
    
    // Called when the user saves a completed note.
    var onSave: (FeedbackNote) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Info") {
                    TextField("Title", text: $title)
                    
                    // Lets the user classify the note using the available categories.
                    Picker("Category", selection: $category) {
                        ForEach(FeedbackNote.Category.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    
                    TextField("Source / Person", text: $source)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                // Main text area for the feedback the user received.
                Section("Feedback") {
                    TextField("What feedback did you receive?", text: $feedback, axis: .vertical)
                        .lineLimit(4...8)
                }
                
                //                MARK: next actions after feedback
                Section("Action Items") {
                    TextField("What should be improved or done next?", text: $actionItems, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Feedback Note")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                // Builds a FeedbackNote from the form values, sends it back, then closes the sheet.
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newNote = FeedbackNote(
                            title: title,
                            category: category,
                            source: source,
                            date: date,
                            feedback: feedback,
                            actionItems: actionItems
                        )
                        onSave(newNote)
                        dismiss()
                    }
                    // Prevents saving until the required fields have content.
                    .disabled(title.isEmpty || feedback.isEmpty)
                }
            }
        }
    }
}


#Preview {
    AddFeedbackNoteView { _ in }
}
