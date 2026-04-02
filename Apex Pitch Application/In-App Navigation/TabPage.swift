////
////  TabPage.swift
////  Apex Pitch Application
////
////  Created by Pride Mafira  on 13/2/2026.
////

import SwiftUI
import Supabase // 1. Added Import

struct SupabaseIdeaRecord: Codable, Identifiable {
    var id: Int?
    let name: String
    let description: String?
    let fundingGoal: Double?
    let fundingRaised: Double?
    let stage: String?
}

extension Idea {
    init(record: SupabaseIdeaRecord) {
        self.id = record.id
        self.startupName = record.name
        self.ideaDescription = record.description ?? ""
        self.fundingGoal = record.fundingGoal.flatMap { Self.numberFormatter.string(for: $0) } ?? ""
        self.fundingRaised = record.fundingRaised.flatMap { Self.numberFormatter.string(for: $0) } ?? ""
        self.type = Types(rawValue: record.stage ?? "") ?? .concepts
    }

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

struct TabPage: View {
    @State private var selectedTab: Types = .concepts
    @State private var ideas: [Idea] = []
    @State private var isLoading = false // Track loading state
    
    let tabs: [Types] = [.concepts, .prototype, .funded]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: Top Tab Bar
                HStack {
                    ForEach(tabs, id: \.self) { tab in
                        Button {
                            selectedTab = tab
                        } label: {
                            VStack(spacing: 4) {
                                Text(tab.rawValue)
                                    .font(.headline)
                                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                                
                                Rectangle()
                                    .fill(selectedTab == tab ? Color.blue : Color.clear)
                                    .frame(height: 3)
                                    .cornerRadius(1.5)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.top, 8)
                .background(Color(.systemGray6))
                .shadow(radius: 1)
                
                // MARK: Display Content
                if isLoading {
                    ProgressView("Fetching your ideas...")
                        .frame(maxHeight: .infinity)
                } else if filteredIdeas.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "lightbulb")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No ideas yet")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredIdeas) { idea in
                                IdeaRow(idea: idea) // Moved row UI to a helper view below
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
                
                // MARK: Add Idea Button
                NavigationLink {
                    addIdeaPage(ideas: $ideas)
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Create Idea")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }
            .navigationTitle("My Ideas")
            .navigationBarTitleDisplayMode(.inline)
            // 2. Fetch data when the page appears
            .task {
                await fetchIdeas()
            }
            // Pull-to-refresh support
            .refreshable {
                await fetchIdeas()
            }
        }
    }
    
    // MARK: Supabase Fetch Function
    func fetchIdeas() async {
        isLoading = true
        do {
            let fetched: [SupabaseIdeaRecord] = try await supabase
                .from("Ideas Table") // Ensure this matches Supabase exactly
                .select()
                .execute()
                .value
            
            self.ideas = fetched.map(Idea.init(record:))
        } catch {
            print("❌ Error fetching: \(error.localizedDescription)")
        }
        isLoading = false
    }

    private var filteredIdeas: [Idea] {
        ideas.filter { $0.type == selectedTab }
    }
}

// Helper View for the Idea Card
struct IdeaRow: View {
    let idea: Idea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(idea.startupName)
                    .font(.headline)
                Spacer()
                Text(idea.type.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.blue)
            }
            
            Text(idea.ideaDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Goal: $\(idea.fundingGoal)").font(.subheadline)
                    Text("Raised: $\(idea.fundingRaised)").font(.subheadline)
                }
                Spacer()
                
                let goal = Double(idea.fundingGoal) ?? 0
                let raised = Double(idea.fundingRaised) ?? 0
                let progress = goal > 0 ? raised / goal : 0
                
                VStack(alignment: .trailing) {
                    Text("\(Int(progress * 100))%").font(.caption).foregroundColor(.blue)
                    ProgressView(value: progress).frame(width: 80)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 2))
    }
}

#Preview {
    TabPage()
}
