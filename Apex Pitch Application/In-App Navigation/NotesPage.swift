//
//  NotesPage.swift
//  Apex Pitch Application
//
//  Created by admin on 30/3/2026.
//
import SwiftUI
internal import Combine

struct FeedbackNotesView: View {
    @StateObject private var store = FeedbackStore()
    // Controls whether the add-note sheet is visible.
    @State private var showingAddNote = false
    
    var body: some View {
        NavigationStack {
            List {
                //MARK: Empty state shown before the user has saved any notes.
                if store.notes.isEmpty {
                    ContentUnavailableView(
                        "No Feedback Notes Yet",
                        systemImage: "note.text",
                        description: Text("Tap the + button to save idea or meeting feedback.")
                    )
                } else {
                    //MARK: Builds one row for every saved feedback note.
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
                            
                            //MARK: Follow-up actions are shown only when they exist.
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
                            
                            //MARK: Timestamp showing when the note was recorded.
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
                //MARK: Presents the sheet where the user can draft and save a new note.
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // Captures the created note and inserts it into the local store.
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
