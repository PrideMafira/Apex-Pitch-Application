//
//  AddNewNotes.swift
//  Apex Pitch Application
//
//  Created by admin on 30/3/2026.
//
import SwiftUI
//import Combine

struct AddFeedbackNoteView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var category: FeedbackNote.Category = .idea
    @State private var source = ""
    @State private var date = Date()
    @State private var feedback = ""
    @State private var actionItems = ""
    
    var onSave: (FeedbackNote) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Info") {
                    TextField("Title", text: $title)
                    
                    Picker("Category", selection: $category) {
                        ForEach(FeedbackNote.Category.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    
                    TextField("Source / Person", text: $source)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section("Feedback") {
                    TextField("What feedback did you receive?", text: $feedback, axis: .vertical)
                        .lineLimit(4...8)
                }
                
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
                    .disabled(title.isEmpty || feedback.isEmpty)
                }
            }
        }
    }
}


#Preview {
    AddFeedbackNoteView { _ in }
}
