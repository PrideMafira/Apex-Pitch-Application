//
//  models.swift
//  Apex Pitch Application
//
//  Created by admin on 30/3/2026.
//


import SwiftUI
internal import Combine
import WebKit

// MARK: Shared App Models

//MARK: Startup stages used by the ideas dashboard and the add-idea form.
enum Types: String, CaseIterable, Codable {
    case concepts = "Concept"
    case prototype = "Prototype"
    case funded = "Funded"
}

struct Idea: Identifiable, Equatable {
    var id: Int?
    let startupName: String
    let ideaDescription: String
    let fundingGoal: String
    let fundingRaised: String
    let type: Types
}

// MARK: Mirrors the Supabase row shape used when reading and writing ideas. (TabPage)
struct SupabaseIdeaRecord: Codable, Identifiable {
    var id: Int?
    let name: String
    let description: String?
    let fundingGoal: Double?
    let fundingRaised: Double?
    let stage: String?
}

extension Idea {
    // Converts a Supabase response into the local model used by the SwiftUI list.
    init(record: SupabaseIdeaRecord) {
        self.id = record.id
        self.startupName = record.name
        self.ideaDescription = record.description ?? ""
        self.fundingGoal = record.fundingGoal.flatMap { Self.numberFormatter.string(for: $0) } ?? ""
        self.fundingRaised = record.fundingRaised.flatMap { Self.numberFormatter.string(for: $0) } ?? ""
        self.type = Types(rawValue: record.stage ?? "") ?? .concepts
    }
    
    // Converts the local idea model back into the payload expected by Supabase.
    func asSupabaseRecord() -> SupabaseIdeaRecord {
        SupabaseIdeaRecord(
            id: id,
            name: startupName,
            description: ideaDescription,
            fundingGoal: Double(fundingGoal),
            fundingRaised: Double(fundingRaised),
            stage: type.rawValue
        )
    }
    
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}




//MARK: Feedback entry captured from meetings, reviews, or general discussions.
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


//MARK: Holds the notes shown on the feedback screen and provides simple list actions.
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

//MARK: Reusable UIKit bridge for showing web content inside SwiftUI screens.
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

//MARK:  Display user profile from Supabase to In-app settings
struct UserProfile: Codable {
    let id: UUID
    var full_name: String?
    var email: String?
}
