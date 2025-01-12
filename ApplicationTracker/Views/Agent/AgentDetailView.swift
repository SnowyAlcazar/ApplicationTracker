//
//  AgentDetailView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 02/04/2024.
//

import SwiftUI
import SwiftData

struct AgentDetailView: View {
    enum FocusedField {
        case name
    }
    @Bindable var agent: Agent
    let isNew: Bool
    @State private var isEditingAgencyList = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var sortOrder = KeyPathComparator(\Application.dateApplied)
    @State private var isFavorite = false
    @State private var newAgency: Agency?
    @Query(sort: [SortDescriptor(\Agency.name)]) private var agencies: [Agency]

    init(agent: Agent, isNew: Bool = false) {
        self.agent = agent
        self.isNew = isNew
    }
    @State private var name = ""
    @FocusState private var focusedField: FocusedField?

    var body: some View {
        Form {
            Section("Information") {
                if isNew {
                    TextField("Agent name", text: $agent.name)
                        .focused($focusedField, equals: .name)
                        .autocorrectionDisabled()
                } else {
                    TextField("Name", text: $agent.name)
                        .autocorrectionDisabled()
                }
                
                TextField("Office phone", text: $agent.officePhone)
                    .textContentType(.telephoneNumber)
                
                TextField("Mobile phone", text: $agent.mobilePhone)
                    .textContentType(.telephoneNumber)
                
                TextField("Email", text: $agent.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                
                Toggle("Favorite?", isOn: $agent.isFavorite)
            }
            Section("Agent Notes") {
                TextField("What did \(agent.name) do well...", text: $agent.notes, axis: .vertical)
            }
            Section("Agency") {
                if !agencies.isEmpty {
                    Picker("Agency", selection: $agent.agency) {
                        Text("None")
                            .tag(nil as Agency?)
                        ForEach(agencies) { agency in
                            Text(agency.name)
                                .tag(agency as Agency?)
                        }
                    }
                }
                
                HStack {
                    Text("Add a new agency")
                    Spacer()
                    Button("Add") {
                        addAgency()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .background(.tint.opacity(0.75))
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(5)
                }
                /// Toggle display of closed applications in list
                if !agencies.isEmpty {
                    Toggle("Edit agency list?", isOn: $isEditingAgencyList.animation())
                    
                    if isEditingAgencyList {
                        List {
                            ForEach(agencies) { agency in
                                NavigationLink {
                                    AgencyDetailView(agency: agency)
                                        .navigationTitle("Agency")
                                } label: {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Label("", systemImage: "building.columns.fill")
                                                .labelsHidden()
                                                .padding(.trailing, 5)
                                            Text(agency.name)
                                        }
                                    }
                                }
                            }
                            .onDelete(perform: deleteAgencies)
                        }
                        .font(.caption)
                    }
                }
            }

            Section("Applications represented by \(agent.name)") {
                let sortedApplications = agent.representedBy?.sorted(using: sortOrder) ?? []
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
                        .font(.caption)
                    }
                }
            }
        }
        .onAppear {
            focusedField = .name
        }
        .navigationTitle(isNew ? "New Agent" : "Agent")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        modelContext.delete(agent)
                        dismiss()
                    }
                }
            }
        }
        .sheet(item: $newAgency) { agency in
            NavigationStack {
                AgencyDetailView(agency: agency, isNew: true)
            }
            .interactiveDismissDisabled()
        }
    }
    private func addAgency() {
        withAnimation {
            let newItem = Agency(name: "")
            modelContext.insert(newItem)
            newAgency = newItem
        }
    }
    
    private func deleteAgencies(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(agencies[index])
            }
        }
    }
}

//#Preview {
//    let preview = Preview(Agent.self)
//    return NavigationStack {
//        AgentDetailView(agent: Agent.sampleAgents[2])
//            .modelContainer(preview.container)
//    }
//}
