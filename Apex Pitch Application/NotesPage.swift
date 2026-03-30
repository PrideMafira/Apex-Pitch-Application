//
//  NotesPage.swift
//  Apex Pitch Application
//
//  Created by admin on 30/3/2026.
//
import SwiftUI
internal import Combine

// MARK: - Model
// Represents one saved feedback entry displayed in the notes list.
// It keeps both the feedback itself and any follow-up actions tied to it.
struct FeedbackNote: Identifiable, Codable {
    // Unique value used by SwiftUI to identify each note row.
    var id = UUID()
    // Short title that summarizes the note.
    var title: String
    // High-level type used to classify the note.
    var category: Category
    // Person, meeting, or place the feedback came from.
    var source: String
    // Date the feedback was captured.
    var date: Date
    // Main body of the saved feedback.
    var feedback: String
    // Optional next steps based on the feedback.
    var actionItems: String
    
    // Categories available when organizing feedback notes.
    enum Category: String, CaseIterable, Codable {
        case idea = "Concept"
        case meeting = "Prototype"
        case general = "Funded"
    }
}

// MARK: - ViewModel
// Holds the notes shown on this screen and provides simple list actions.
class FeedbackStore: ObservableObject {
    // Published so the UI refreshes automatically when notes are added or removed.
    @Published var notes: [FeedbackNote] = []
    
    // Places new notes at the top so the newest feedback appears first.
    func addNote(_ note: FeedbackNote) {
        notes.insert(note, at: 0)
    }
    
    // Removes notes using the indexes provided by swipe-to-delete.
    func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

// Main page for viewing feedback notes and opening the add-note form.
struct FeedbackNotesView: View {
    // Owns the in-memory note store for this page.
    @StateObject private var store = FeedbackStore()
    // Controls whether the add-note sheet is visible.
    @State private var showingAddNote = false
    
    var body: some View {
        NavigationStack {
            List {
                // Empty state shown before the user has saved any notes.
                if store.notes.isEmpty {
                    ContentUnavailableView(
                        "No Feedback Notes Yet",
                        systemImage: "note.text",
                        description: Text("Tap the + button to save idea or meeting feedback.")
                    )
                } else {
                    // Builds one row for every saved feedback note.
                    ForEach(store.notes) { note in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(note.title)
                                .font(.headline)
                            
                            //readable category label.
                            Text(note.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            // Only show the source when one has been provided.
                            if !note.source.isEmpty {
                                Label(note.source, systemImage: "person.fill")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Short preview of the feedback content.
                            Text(note.feedback)
                                .font(.body)
                                .lineLimit(3)
                            
                            // Follow-up actions are shown only when they exist.
                            if !note.actionItems.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Action Items")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                    
                                    Text(note.actionItems)
                                        .font(.caption)
                                }
                            }
                            
                            // Timestamp showing when the note was recorded.
                            Text(note.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                    }
                    // Enables swipe-to-delete for notes in the list.
                    .onDelete(perform: store.deleteNotes)
                }
            }
            .navigationTitle("Feedback Notes")
            .toolbar {
                // Button that opens the sheet for creating a new note.
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // Presents the add-note screen and saves the result into the store.
            .sheet(isPresented: $showingAddNote) {
                AddFeedbackNoteView { newNote in
                    store.addNote(newNote)
                }
            }
        }
    }
}


#Preview {
    FeedbackNotesView()
}
