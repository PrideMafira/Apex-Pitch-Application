//
//  TabPage.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 13/2/2026.
//

import SwiftUI

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

struct TabPage: View {
    @State private var selectedTab: Types = .concepts
    @State private var ideas: [Idea] = []
    
    let tabs: [Types] = [.concepts, .prototype, .funded]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // --- Top Tab Bar ---
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
                
                // --- Display Selected View ---
                if filteredIdeas.isEmpty {
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
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text(idea.startupName)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
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
                                            Text("Goal: $\(idea.fundingGoal)")
                                                .font(.subheadline)
                                            Text("Raised: $\(idea.fundingRaised)")
                                                .font(.subheadline)
                                        }
                                        
                                        Spacer()
                                        
                                        // Progress indicator
                                        let goal = Double(idea.fundingGoal) ?? 0
                                        let raised = Double(idea.fundingRaised) ?? 0
                                        let progress = goal > 0 ? raised / goal : 0
                                        
                                        VStack(alignment: .trailing) {
                                            Text("\(Int(progress * 100))%")
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                            ProgressView(value: progress)
                                                .progressViewStyle(LinearProgressViewStyle())
                                                .frame(width: 80)
                                        }
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                                )
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
                
                // --- Add Idea Button ---
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
        }
    }
    // Computed property for filtered ideas
    private var filteredIdeas: [Idea] {
        ideas.filter { $0.type == selectedTab }
    }
}




// MARK: - Idea needs to conform to Identifiable
extension Idea: Identifiable {
    var id: String { startupName + ideaDescription }
}


#Preview {
    TabPage()
}
