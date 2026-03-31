//
//  models.swift
//  Apex Pitch Application
//
//  Created by admin on 30/3/2026.
//


import SwiftUI
internal import Combine
import WebKit


//MARK: TAB PAGE FOR IDEAS
enum Types: String, CaseIterable {
    case concepts = "Concept"
    case prototype = "Prototype"
    case funded = "Funded"
}

struct Idea {
    let startupName: String
    let ideaDescription: String
    let fundingGoal: String
    let fundingRaised: String
    let type: Types
}

//MARK: FOR NOTES PAGE
struct FeedbackNote: Identifiable, Codable {
    var id = UUID()
    var title: String
    var category: Category
    // Person, meeting, or place the feedback came from.
    var source: String
    var date: Date
    var feedback: String
    var actionItems: String
    
    // Categories available when organizing feedback notes.
    enum Category: String, CaseIterable, Codable {
        case idea = "Concept"
        case meeting = "Prototype"
        case general = "Funded"
    }
}


// MARK: VIEWING THE NOTES ADDED FROM NOTES PAGE
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

//MARK: ZOOM MEETINGS PAGE TO TAKE THE USER TO THE WEBPAGE FOR ZOOM
struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
