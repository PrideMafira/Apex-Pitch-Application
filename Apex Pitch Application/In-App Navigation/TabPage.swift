////
////  TabPage.swift
////  Apex Pitch Application
////
////  Created by Pride Mafira  on 13/2/2026.
////

import SwiftUI
import Supabase

struct TabPage: View {
    @State private var selectedTab: Types = .concepts
    @State private var ideas: [Idea] = []
    @State private var isLoading = false
    
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
                
                //MARK: Shows a loading state, an empty state, or the current filtered ideas.
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
                            ForEach(filteredIdeaIndices, id: \.self) { index in
                                //MARK: Each card is rendered by a helper view to keep this screen readable.
                                IdeaRow(idea: $ideas[index])
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
                
                //MARK: Opens the form used to create a new idea record.
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
            //MARK: Fetch data when the page appears
            .task {
                await fetchIdeas()
            }
            // Pull-to-refresh support
            .refreshable {
                await fetchIdeas()
            }
        }
    }
    
    //MARK: Fetches the latest ideas from Supabase every time the screen appears or refreshes.
    func fetchIdeas() async {
        isLoading = true
        do {
            let fetched: [SupabaseIdeaRecord] = try await supabase
                .from("Ideas Table") 
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
        // Keeps the tab bar logic simple by deriving the visible list from the full dataset.
        ideas.filter { $0.type == selectedTab }
    }
    
    private var filteredIdeaIndices: [Int] {
        ideas.indices.filter { ideas[$0].type == selectedTab }
    }
}

//MARK: Visual representation of a single idea in the list.
struct IdeaRow: View {
    @Binding var idea: Idea
    @State private var showingUpdateRaised = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(idea.startupName)
                    .font(.headline)
                Spacer()
                Button {
                    showingUpdateRaised = true
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .padding(6)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
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
                
                let goal = idea.fundingGoalValue
                let raised = idea.fundingRaisedValue
                let progress = goal > 0 ? min(max(raised / goal, 0), 1) : 0
                
                VStack(alignment: .trailing) {
                    Text("\(Int(progress * 100))%").font(.caption).foregroundColor(.blue)
                    ProgressView(value: progress).frame(width: 80)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 2))
        .sheet(isPresented: $showingUpdateRaised) {
            UpdateFundingRaisedView(idea: $idea)
        }
    }
}

#Preview {
    TabPage()
}
