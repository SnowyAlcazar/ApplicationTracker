//
//  AgencyDetailView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 12/04/2024.
//

import SwiftUI

struct AgencyDetailView: View {
    enum FocusedField {
        case name
    }
    @Bindable var agency: Agency
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var sortOrder = KeyPathComparator(\Application.dateApplied)

    init(agency: Agency, isNew: Bool = false) {
        self.agency = agency
        self.isNew = isNew
    }
     @State private var name = ""
     @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        Form {
            if isNew {
                TextField("Agency name", text: $agency.name)
                    .focused($focusedField, equals: .name)
                    .autocorrectionDisabled()
            } else {
                TextField("Agency name", text: $agency.name)
                    .autocorrectionDisabled()
            }

            Section("Agents") {
                //let sortedApplications = agency.representedApplications?.sorted(using: sortOrder) ?? []
                List {
                    if !agency.sortedAgents.isEmpty {
                        ForEach(agency.sortedAgents) { agent in
                            NavigationLink {
                                AgentDetailView(agent: agent, isNew: false)
                                    .navigationTitle("Agent Detail")
                            } label: {
                                HStack {
                                    Text(agent.name)
                                }
                            }
                        }
                    }
                }
            }

            Section("Applications represented by \(agency.name)") {
                let sortedApplications = agency.representedApplications?.sorted(using: sortOrder) ?? []
                List {
                    if !sortedApplications.isEmpty {
                        ForEach(sortedApplications) { assocApp in
                            NavigationLink {
                                ApplicationDetailView(application: assocApp, isNew: false)
                                    .navigationTitle("Application Detail")
                            } label: {
                                HStack {
                                    Text(assocApp.position)
                                    Spacer()
                                    Text(assocApp.dateApplied, style: .date)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            focusedField = .name
        }
        .navigationTitle(isNew ? "New Agency" : "Agency")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        modelContext.delete(agency)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
let preview = Preview(Agency.self)
    return NavigationStack {
        AgencyDetailView(agency: Agency.sampleAgencies[1])
            .modelContainer(preview.container)
    }
}
