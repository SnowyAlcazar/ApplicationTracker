//
//  AgentDetailView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 02/04/2024.
//

import SwiftUI
import SwiftData

struct AgentDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var agent: Agent
    let isNew: Bool
    
    @Query(sort: [SortDescriptor(\Agency.name)]) var agencies: [Agency]
    
    @State private var showNewAgencySheet = false
    
    enum FocusedField {
        case name
    }
    
    @FocusState private var focusedField: FocusedField?
    
    init(agent: Agent, isNew: Bool = false) {
        self.agent = agent
        self.isNew = isNew
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Agent Information Section
                SectionCard(title: "Agent Information", icon: "person.circle") {
                    VStack(spacing: 16) {
                        // Name
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Name", systemImage: "person.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            if isNew {
                                TextField("Agent name", text: $agent.name)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .name)
                            } else {
                                TextField("Agent name", text: $agent.name)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                        
                        // Favorite Toggle
                        Toggle(isOn: $agent.isFavorite) {
                            Label("Favorite", systemImage: agent.isFavorite ? "star.fill" : "star")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                        }
                        .tint(.yellow)
                    }
                }
                
                // MARK: - Contact Details Section
                SectionCard(title: "Contact Details", icon: "phone") {
                    VStack(spacing: 16) {
                        // Mobile Phone
                        HStack {
                            Label("Mobile", systemImage: "phone.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            TextField("Mobile number", text: $agent.mobilePhone)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.phonePad)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: 200)
                            
                            if !agent.mobilePhone.isEmpty {
                                Button(action: {
                                    if let url = URL(string: "tel://\(agent.mobilePhone.replacingOccurrences(of: " ", with: ""))") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Image(systemName: "phone.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                }
                            }
                        }
                        
                        // Office Phone
                        HStack {
                            Label("Office", systemImage: "building.2")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            TextField("Office number", text: $agent.officePhone)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.phonePad)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: 200)
                            
                            if !agent.officePhone.isEmpty {
                                Button(action: {
                                    if let url = URL(string: "tel://\(agent.officePhone.replacingOccurrences(of: " ", with: ""))") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Image(systemName: "phone.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                }
                            }
                        }
                        
                        // Email
                        HStack {
                            Label("Email", systemImage: "envelope.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            TextField("Email address", text: $agent.email)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: 250)
                            
                            if !agent.email.isEmpty {
                                Button(action: {
                                    if let url = URL(string: "mailto:\(agent.email)") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Image(systemName: "envelope.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.title2)
                                }
                            }
                        }
                    }
                }
                
                // MARK: - Agency Section
                if !agencies.isEmpty || isNew {
                    SectionCard(title: "Agency", icon: "building.2") {
                        HStack {
                            Label("Associated Agency", systemImage: "building.2")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            Menu {
                                // None option
                                Button("None") {
                                    agent.agency = nil
                                }
                                
                                if !agencies.isEmpty {
                                    Divider()
                                    
                                    // Existing agencies
                                    ForEach(agencies) { agency in
                                        Button(agency.name) {
                                            agent.agency = agency
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                // Add new agency option
                                Button(action: { showNewAgencySheet = true }) {
                                    Label("Add New Agency...", systemImage: "plus.circle")
                                }
                            } label: {
                                HStack {
                                    Text(agent.agency?.name ?? "Select...")
                                        .foregroundColor(agent.agency == nil ? .secondary : .primary)
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                // MARK: - Notes Section
                SectionCard(title: "Notes", icon: "note.text") {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Agent Notes", systemImage: "note")
                            .font(.subheadline)
                            .foregroundColor(.blue.opacity(0.8))
                        
                        TextField("Notes about this agent...", text: $agent.notes, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .frame(minHeight: 80)
                    }
                }
                
                // MARK: - Applications Section
                if let applications = agent.representedBy, !applications.isEmpty {
                    SectionCard(title: "Applications", icon: "briefcase") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("\(applications.count) application\(applications.count == 1 ? "" : "s")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            ForEach(applications) { application in
                                NavigationLink {
                                    ApplicationDetailView(application: application)
                                } label: {
                                    ApplicationMiniRow(application: application)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle(isNew ? "New Agent" : agent.name)
        .navigationBarTitleDisplayMode(.inline)
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
        .onAppear {
            if isNew {
                focusedField = .name
            }
        }
        .sheet(isPresented: $showNewAgencySheet) {
            NavigationStack {
                NewAgencySheet(agent: agent)
            }
        }
    }
}

// MARK: - Mini Application Row

struct ApplicationMiniRow: View {
    let application: Application
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(application.position)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                if let client = application.client {
                    Text(client.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            StatusBadge(status: application.appStatus, size: .small)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(8)
    }
}

// MARK: - New Agency Sheet

struct NewAgencySheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let agent: Agent
    
    @State private var agencyName: String = ""
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Agency Name", systemImage: "building.2")
                        .font(.subheadline)
                        .foregroundColor(.blue.opacity(0.8))
                    
                    TextField("e.g., ECMS Consultancy", text: $agencyName)
                        .textFieldStyle(.roundedBorder)
                }
            } header: {
                Text("New Agency")
            }
        }
        .navigationTitle("Add Agency")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    addAgency()
                }
                .disabled(agencyName.isEmpty)
            }
        }
    }
    
    private func addAgency() {
        let newAgency = Agency(name: agencyName)
        modelContext.insert(newAgency)
        agent.agency = newAgency
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Agent.self, Agency.self, Application.self,
        configurations: config
    )
    
    let agency = Agency(name: "ECMS Consultancy")
    let agent = Agent(
        name: "Adele Bywater",
        officePhone: "020 8565 0009",
        mobilePhone: "020 7092 3204",
        email: "adele.bywater@ecm.com",
        isFavorite: true,
        notes: "Very helpful and responsive agent"
    )
    agent.agency = agency
    
    container.mainContext.insert(agency)
    container.mainContext.insert(agent)
    
    return NavigationStack {
        AgentDetailView(agent: agent)
            .modelContainer(container)
    }
}

/*
import SwiftUI
import SwiftData

struct AgentDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var agent: Agent
    let isNew: Bool
    
    @Query(sort: [SortDescriptor(\Agency.name)]) var agencies: [Agency]
    
    enum FocusedField {
        case name
    }
    
    @FocusState private var focusedField: FocusedField?
    
    init(agent: Agent, isNew: Bool = false) {
        self.agent = agent
        self.isNew = isNew
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Agent Information Section
                SectionCard(title: "Agent Information", icon: "person.circle") {
                    VStack(spacing: 16) {
                        // Name
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Name", systemImage: "person.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            if isNew {
                                TextField("Agent name", text: $agent.name)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .name)
                            } else {
                                TextField("Agent name", text: $agent.name)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                        
                        // Favorite Toggle
                        Toggle(isOn: $agent.isFavorite) {
                            Label("Favorite", systemImage: agent.isFavorite ? "star.fill" : "star")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                        }
                        .tint(.yellow)
                    }
                }
                
                // MARK: - Contact Details Section
                SectionCard(title: "Contact Details", icon: "phone") {
                    VStack(spacing: 16) {
                        // Mobile Phone
                        HStack {
                            Label("Mobile", systemImage: "phone.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            TextField("Mobile number", text: $agent.mobilePhone)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.phonePad)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: 200)
                            
                            if !agent.mobilePhone.isEmpty {
                                Button(action: {
                                    if let url = URL(string: "tel://\(agent.mobilePhone.replacingOccurrences(of: " ", with: ""))") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Image(systemName: "phone.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                }
                            }
                        }
                        
                        // Office Phone
                        HStack {
                            Label("Office", systemImage: "building.2")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            TextField("Office number", text: $agent.officePhone)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.phonePad)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: 200)
                            
                            if !agent.officePhone.isEmpty {
                                Button(action: {
                                    if let url = URL(string: "tel://\(agent.officePhone.replacingOccurrences(of: " ", with: ""))") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Image(systemName: "phone.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                }
                            }
                        }
                        
                        // Email
                        HStack {
                            Label("Email", systemImage: "envelope.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            TextField("Email address", text: $agent.email)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: 250)
                            
                            if !agent.email.isEmpty {
                                Button(action: {
                                    if let url = URL(string: "mailto:\(agent.email)") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Image(systemName: "envelope.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.title2)
                                }
                            }
                        }
                    }
                }
                
                // MARK: - Agency Section
                if !agencies.isEmpty {
                    SectionCard(title: "Agency", icon: "building.2") {
                        HStack {
                            Label("Associated Agency", systemImage: "building.2")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            Picker("Agency", selection: $agent.agency) {
                                Text("None")
                                    .tag(nil as Agency?)
                                ForEach(agencies) { agency in
                                    Text(agency.name)
                                        .tag(agency as Agency?)
                                }
                            }
                            .labelsHidden()
                        }
                    }
                }
                
                // MARK: - Notes Section
                SectionCard(title: "Notes", icon: "note.text") {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Agent Notes", systemImage: "note")
                            .font(.subheadline)
                            .foregroundColor(.blue.opacity(0.8))
                        
                        TextField("Notes about this agent...", text: $agent.notes, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .frame(minHeight: 80)
                    }
                }
                
                // MARK: - Applications Section
                if let applications = agent.representedBy, !applications.isEmpty {
                    SectionCard(title: "Applications", icon: "briefcase") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("\(applications.count) application\(applications.count == 1 ? "" : "s")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            ForEach(applications) { application in
                                NavigationLink {
                                    ApplicationDetailView(application: application)
                                } label: {
                                    ApplicationMiniRow(application: application)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle(isNew ? "New Agent" : agent.name)
        .navigationBarTitleDisplayMode(.inline)
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
        .onAppear {
            if isNew {
                focusedField = .name
            }
        }
    }
}

// MARK: - Mini Application Row

struct ApplicationMiniRow: View {
    let application: Application
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(application.position)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                if let client = application.client {
                    Text(client.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            StatusBadge(status: application.appStatus, size: .small)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(8)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Agent.self, Agency.self, Application.self,
        configurations: config
    )
    
    let agency = Agency(name: "ECMS Consultancy")
    let agent = Agent(
        name: "Adele Bywater",
        officePhone: "020 8565 0009",
        mobilePhone: "020 7092 3204",
        email: "adele.bywater@ecm.com",
        isFavorite: true,
        notes: "Very helpful and responsive agent"
    )
    agent.agency = agency
    
    container.mainContext.insert(agency)
    container.mainContext.insert(agent)
    
    return NavigationStack {
        AgentDetailView(agent: agent)
            .modelContainer(container)
    }
}

*/
