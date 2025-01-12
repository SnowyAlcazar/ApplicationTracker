//
//  AgentList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 12/04/2024.
//

import SwiftUI
import SwiftData

struct AgentList: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
//    @State private var selectedAgent: String = ""
    @Query(sort: [SortDescriptor(\Agent.name)]) private var agents: [Agent]
    
    init(agentFilter: String = "") {
        let predicate = #Predicate<Agent> { agent in
            agentFilter.isEmpty
            || agent.name.localizedStandardContains(agentFilter)
        }
        _agents = Query(filter: predicate, sort: \Agent.name)
    }

    @State private var newAgent: Agent?
    
    var body: some View {
        NavigationSplitView {
            Group {
                if !agents.isEmpty {
                    List {
                        ForEach(agents) { agent in
                            NavigationLink {
                                AgentDetailView(agent: agent)
                                    .navigationTitle("Agent")
                            } label: {
                                AgentRow(agent: agent)
                            }
                            .padding([.top,.bottom])
                        }
                        .onDelete(perform: deleteAgents)
                        .listRowSeparator(.visible)
                    }

                } else {
                    ContentUnavailableView {
                        Label("No agents", systemImage: "person.and.person")
                    }
                }
            }
            .navigationTitle("Agents")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addAgent) {
                        Label("Add Agent", systemImage: "plus")
                    }
                }
            }
            .sheet(item: $newAgent) { agent in
                NavigationStack {
                    AgentDetailView(agent: agent, isNew: true)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select an agent")
                .navigationTitle("Agent")
        }
    }
    
    private func addAgent() {
        withAnimation {
            let newItem = Agent(name: "")
            modelContext.insert(newItem)
            newAgent = newItem
        }
    }
    private func deleteAgents(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(agents[index])
            }
        }
    }
}

//#Preview {
//    let preview = Preview(Agent.self)
//    preview.addExamples(Agent.sampleAgents)
//    return NavigationStack {
//        AgentList()
//            .modelContainer(preview.container)
//    }
//}
