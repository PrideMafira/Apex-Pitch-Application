//
//  NotesPage.swift
//  Apex Pitch Application
//
//  Created by admin on 30/3/2026.
//
import SwiftUI
internal import Combine

// MARK: - Model
struct FeedbackNote: Identifiable, Codable {
    var id = UUID()
    var title: String
    var category: Category
    var source: String
    var date: Date
    var feedback: String
    var actionItems: String
    
    enum Category: String, CaseIterable, Codable {
        case idea = "Concept"
        case meeting = "Prototype"
        case general = "Funded"
    }
}

// MARK: - ViewModel
class FeedbackStore: ObservableObject {
    @Published var notes: [FeedbackNote] = []
    
    func addNote(_ note: FeedbackNote) {
        notes.insert(note, at: 0)
    }
    
    func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

struct FeedbackNotesView: View {
    @StateObject private var store = FeedbackStore()
    @State private var showingAddNote = false
    
    var body: some View {
        NavigationStack {
            List {
                if store.notes.isEmpty {
                    ContentUnavailableView(
                        "No Feedback Notes Yet",
                        systemImage: "note.text",
                        description: Text("Tap the + button to save idea or meeting feedback.")
                    )
                } else {
                    ForEach(store.notes) { note in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(note.title)
                                .font(.headline)
                            
                            Text(note.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if !note.source.isEmpty {
                                Label(note.source, systemImage: "person.fill")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(note.feedback)
                                .font(.body)
                                .lineLimit(3)
                            
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
                            
                            Text(note.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                    }
                    .onDelete(perform: store.deleteNotes)
                }
            }
            .navigationTitle("Feedback Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
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
