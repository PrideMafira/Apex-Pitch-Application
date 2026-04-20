//
//  models.swift
//  Apex Pitch Application
//
//  Created by admin on 30/3/2026.
//


import SwiftUI
internal import Combine
import WebKit
import Supabase

// MARK: Shared App Models

//MARK: Startup stages used by the ideas dashboard and the add-idea form.
enum Types: String, CaseIterable, Codable {
    case concepts = "Concept"
    case prototype = "Prototype"
    case funded = "Funded"
}

struct Idea: Identifiable, Equatable {
    var id: Int? // Supabase auto-generates this
    let startupName: String
    let ideaDescription: String
    var fundingGoal: String
    var fundingRaised: String
    var type: Types
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

        let inferredStage = Types(rawValue: record.stage ?? "") ?? .concepts
        let goal = record.fundingGoal ?? 0
        let raised = record.fundingRaised ?? 0
        self.type = (goal > 0 && raised >= goal) ? .funded : inferredStage
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

    var fundingGoalValue: Double {
        Double(fundingGoal) ?? 0
    }

    var fundingRaisedValue: Double {
        Double(fundingRaised) ?? 0
    }

    static func formattedAmount(_ value: Double) -> String {
        numberFormatter.string(for: value) ?? String(format: "%.2f", value)
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


//MARK: Enum for Category (DB-friendly and Codable)
enum NoteCategory: String, CaseIterable, Hashable {
    case general
    case meeting
    case idea
    
    var displayName: String {
        switch self {
        case .general:
            "Concept"
        case .meeting:
            "Prototype"
        case .idea:
            "Funded"
        }
    }
}

extension NoteCategory: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = (try? container.decode(String.self))?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        switch value.lowercased() {
        case "general", "concept":
            self = .general
        case "meeting", "prototype", "protoype":
            self = .meeting
        case "idea", "funded":
            self = .idea
        default:
            self = .general
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

//MARK: Feedback entry captured from meetings, reviews, or general discussions.
struct FeedbackNote: Identifiable, Codable {
    var id: UUID?
    var title: String
    var category: NoteCategory
    var source: String
    var feedback: String
    var actionItems: String
    var date: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, title, category, source, feedback, date
        case actionItems = "action_items"
    }
    
    init(
        id: UUID?,
        title: String,
        category: NoteCategory,
        source: String,
        feedback: String,
        actionItems: String,
        date: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.source = source
        self.feedback = feedback
        self.actionItems = actionItems
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(NoteCategory.self, forKey: .category)
        source = try container.decode(String.self, forKey: .source)
        feedback = try container.decode(String.self, forKey: .feedback)
        actionItems = try container.decode(String.self, forKey: .actionItems)
        
        if let decodedDate = try container.decodeIfPresent(Date.self, forKey: .date) {
            date = decodedDate
        } else if let dateString = try container.decodeIfPresent(String.self, forKey: .date) {
            date = Self.parseDate(dateString)
        } else {
            date = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(category, forKey: .category)
        try container.encode(source, forKey: .source)
        try container.encode(feedback, forKey: .feedback)
        try container.encode(actionItems, forKey: .actionItems)
        
        // Let Supabase/Postgres set the timestamp when inserting a new row.
        if let date {
            try container.encode(date, forKey: .date)
        }
    }
    
    private static func parseDate(_ value: String) -> Date? {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: value) {
            return date
        }
        
        let isoNoFraction = ISO8601DateFormatter()
        isoNoFraction.formatOptions = [.withInternetDateTime]
        return isoNoFraction.date(from: value)
    }
}

//MARK: Holds the notes shown on the feedback screen and provides simple list actions.
@MainActor
final class FeedbackStore: ObservableObject {
    @Published var notes: [FeedbackNote] = []
    
    // Fetch notes from the "notes" table
    func fetchNotes() async {
        do {
            let fetchedNotes: [FeedbackNote] = try await supabase.from("notes")
                .select()
                .order("date", ascending: false)
                .execute()
                .value
            
            self.notes = fetchedNotes
            print("✅ Successfully fetched \(notes.count) notes")
        } catch {
            // Fallback: If the table doesn't have a `date` column (or it isn't sortable), retry without ordering.
            do {
                let fetchedNotes: [FeedbackNote] = try await supabase.from("notes")
                    .select()
                    .execute()
                    .value
                self.notes = fetchedNotes
                print("✅ Successfully fetched \(notes.count) notes (no ordering)")
            } catch {
                print("❌ Fetch Error: \(error.localizedDescription)")
                print("Full error details: \(error)")
            }
        }
    }
    
    // Add a note and refresh the list
    func addNote(_ note: FeedbackNote) async {
        do {
            try await supabase.from("notes").insert(note).execute()
            await fetchNotes()
        } catch {
            print("❌ Add Error: \(error)")
        }
    }
    
    func subscribeToNotes() {
        //MARK: Create a channel to listen to the "notes" table
        let channel = supabase.channel("notes-changes")
        
        //MARK: Listen for any change (INSERT, UPDATE, DELETE)
        let _ = channel.onPostgresChange(AnyAction.self, schema: "public", table: "notes") { _ in
            Task {
                // When a change happens, re-fetch the notes automatically
                await self.fetchNotes()
            }
        }
        
        //MARK: Start listening
        Task {
            await channel.subscribe()
        }
    }
    
    
    // Delete a note by its ID
    func deleteNotes(at offsets: IndexSet) {
        let notesToDelete = offsets.map { notes[$0] }
        Task {
            for note in notesToDelete {
                guard let id = note.id else { continue }
                do {
                    try await supabase.from("notes")
                        .delete()
                        .eq("id", value: id)
                        .execute()
                } catch {
                    print("❌ Delete Error: \(error)")
                }
            }
            await fetchNotes()
        }
    }
}


