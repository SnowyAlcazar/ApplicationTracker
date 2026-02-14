//
//  ApplicationDetailView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 14/11/2025.
//

import SwiftUI
import SwiftData

struct ApplicationDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var application: Application
    let isNew: Bool

    @State private var newInterview: Interview?
    @State private var sortOrder = KeyPathComparator(\Interview.interviewDate)
    
    // Prevent update loops on iPad
    @State private var isUpdatingStatus = false
    
    // Detect iPad for layout adjustments
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    init(application: Application, isNew: Bool = false) {
        self.application = application
        self.isNew = isNew
    }

    @State private var dateApplied: Date = Date.now
    @State private var update: String = ""
    @State private var updatedAt: Date = Date.now
    @State private var newAgent: Agent?
    @State private var newClient: Client?
    
    // State for conditional display
    @State private var isInsideIR35: Bool = false
    
    @Query(sort: [SortDescriptor(\Agency.name)]) var agencies: [Agency]
    @Query(sort: [SortDescriptor(\Agent.name)]) var agents: [Agent]
    @Query(sort: [SortDescriptor(\Client.name)]) var clients: [Client]
    @Query(sort: [SortDescriptor(\Status.name)]) var statuses: [Status]

    enum FocusedField {
         case position
    }

    @FocusState private var focusedField: FocusedField?
    @State private var newStatus: Status?
    
    // Employment Type Options
    enum EmploymentType: String, CaseIterable {
        case permanent = "Permanent / Fixed Term"
        case contract = "Contract"
        
        var displayName: String { rawValue }
    }
    
    // IR35 Options
    enum IR35Status: String, CaseIterable {
        case outside = "Outside IR35"
        case inside = "Inside IR35"
        
        var displayName: String { rawValue }
    }
    
    // Payment Frequency
    enum PaymentFrequency: String, CaseIterable {
        case weekly = "Weekly"
        case monthly = "Monthly"
        
        var displayName: String { rawValue }
    }
    
    var isPermanent: Bool {
        application.employmentType == EmploymentType.permanent.rawValue
    }
    
    var isContract: Bool {
        application.employmentType == EmploymentType.contract.rawValue
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Job Details Section
                SectionCard(title: "Job Details", icon: "briefcase") {
                    VStack(spacing: 16) {
                        DetailInputRow(
                            label: "Position",
                            icon: "briefcase.fill",
                            text: $application.position,
                            placeholder: "e.g., Accounts clerk",
                            focused: $focusedField,
                            field: .position,
                            isNew: isNew
                        )
                        
                        DetailInputRow(
                            label: "Business Sector",
                            icon: "building.2",
                            text: $application.businessSector,
                            placeholder: "e.g., Finance, Technology"
                        )
                        
                        DetailInputRow(
                            label: "Role Type",
                            icon: "person.text.rectangle",
                            text: $application.positionType,
                            placeholder: "e.g., Accounts clerk, Sales"
                        )
                        
                        // Employment Type Picker
                        HStack {
                            Label("Employment Type", systemImage: "calendar")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            Picker("Employment Type", selection: $application.employmentType) {
                                Text("Select...")
                                    .tag("")
                                ForEach(EmploymentType.allCases, id: \.self) { type in
                                    Text(type.displayName)
                                        .tag(type.rawValue)
                                }
                            }
                            .labelsHidden()
                        }
                        
                        // Date Applied
                        HStack {
                            Label("Date Applied", systemImage: "calendar")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            DatePicker("", selection: $application.dateApplied, displayedComponents: .date)
                                .labelsHidden()
                        }
                    }
                }
                
                // MARK: - Pay & Conditions Section (Conditional)
                if !application.employmentType.isEmpty {
                    SectionCard(title: "Pay & Conditions", icon: "banknote") {
                        VStack(spacing: 16) {
                            if isPermanent {
                                // PERMANENT FIELDS
                                HStack {
                                    Label("Annual Salary", systemImage: "dollarsign.circle")
                                        .font(.subheadline)
                                        .foregroundColor(.blue.opacity(0.8))
                                    
                                    Spacer()
                                    
                                    TextField("Amount", value: $application.remunerationAmount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                                        .multilineTextAlignment(.trailing)
                                        .keyboardType(.decimalPad)
                                        .frame(maxWidth: 150)
                                }
                                
                                DetailInputRow(
                                    label: "Bonus",
                                    icon: "gift.fill",
                                    text: $application.remunerationType,
                                    placeholder: "e.g., 20%"
                                )
                                
                            } else if isContract {
                                // CONTRACT FIELDS
                                
                                // IR35 Status Picker
                                HStack {
                                    Label("IR35 Status", systemImage: "doc.text")
                                        .font(.subheadline)
                                        .foregroundColor(.blue.opacity(0.8))
                                    
                                    Spacer()
                                    
                                    Picker("IR35", selection: $application.iR35) {
                                        Text("Select...")
                                            .tag("")
                                        ForEach(IR35Status.allCases, id: \.self) { status in
                                            Text(status.displayName)
                                                .tag(status.rawValue)
                                        }
                                    }
                                    .labelsHidden()
                                    .onChange(of: application.iR35) { oldValue, newValue in
                                        isInsideIR35 = (newValue == IR35Status.inside.rawValue)
                                    }
                                }
                                
                                // Only show these if Inside IR35
                                if application.iR35 == IR35Status.inside.rawValue {
                                    DetailInputRow(
                                        label: "Umbrella Company Name",
                                        icon: "building.2",
                                        text: $application.umbrellaCompanyName,
                                        placeholder: "Umbrella company name"
                                    )
                                    
                                    DetailInputRow(
                                        label: "Contact Name",
                                        icon: "person",
                                        text: $application.umbrellaContactName,
                                        placeholder: "Contact person at umbrella"
                                    )
                                    
                                    DetailInputRow(
                                        label: "Contact Phone",
                                        icon: "phone",
                                        text: $application.umbrellaContactPhone,
                                        placeholder: "Phone number"
                                    )
                                    
                                    DetailInputRow(
                                        label: "Contact Email",
                                        icon: "envelope",
                                        text: $application.umbrellaContactEmail,
                                        placeholder: "Email address"
                                    )
                                    
                                    DetailInputRow(
                                        label: "Take Home Pay",
                                        icon: "banknote",
                                        text: $application.positionCommitment,
                                        placeholder: "Net daily/weekly amount"
                                    )
                                }
                                
                                // Day Rate
                                HStack {
                                    Label("Day Rate", systemImage: "dollarsign.circle")
                                        .font(.subheadline)
                                        .foregroundColor(.blue.opacity(0.8))
                                    
                                    Spacer()
                                    
                                    TextField("Amount", value: $application.remunerationAmount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                                        .multilineTextAlignment(.trailing)
                                        .keyboardType(.decimalPad)
                                        .frame(maxWidth: 150)
                                }
                                
                                // Payment Frequency
                                HStack {
                                    Label("Payment Frequency", systemImage: "calendar.badge.clock")
                                        .font(.subheadline)
                                        .foregroundColor(.blue.opacity(0.8))
                                    
                                    Spacer()
                                    
                                    Picker("Payment Frequency", selection: $application.remunerationType) {
                                        Text("Select...")
                                            .tag("")
                                        ForEach(PaymentFrequency.allCases, id: \.self) { freq in
                                            Text(freq.displayName)
                                                .tag(freq.rawValue)
                                        }
                                    }
                                    .labelsHidden()
                                }
                            }
                            
                            // COMMON FIELDS (both permanent and contract)
                            DetailInputRow(
                                label: "Office Days per Week",
                                icon: "building",
                                text: $application.officeDays,
                                placeholder: "e.g., 3 days per week"
                            )
                            
                            DetailInputRow(
                                label: "Workstyle",
                                icon: "laptopcomputer",
                                text: $application.workstyle,
                                placeholder: "Remote, Hybrid, Office"
                            )
                        }
                    }
                }
                
                // MARK: - Origin & Skills Section
                SectionCard(title: "Origin & Skills", icon: "star") {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Where Advertised", systemImage: "megaphone")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            TextField("e.g., LinkedIn, JobServe, Direct", text: $application.whereAdvertised, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Skills & Experience", systemImage: "sparkles")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            TextField("Required skills and experience...", text: $application.requiredSkills, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 60)
                        }
                    }
                }
                
                // MARK: - Contacts Section
                SectionCard(title: "Contacts", icon: "person.2") {
                    VStack(spacing: 16) {
                        if !agents.isEmpty || isNew {
                            HStack {
                                Label("Agent", systemImage: "person")
                                    .font(.subheadline)
                                    .foregroundColor(.blue.opacity(0.8))
                                
                                Spacer()
                                
                                Menu {
                                    // None option
                                    Button("None") {
                                        application.agent = nil
                                    }
                                    
                                    if !agents.isEmpty {
                                        Divider()
                                        
                                        // Existing agents
                                        ForEach(agents) { agent in
                                            Button(agent.name) {
                                                application.agent = agent
                                            }
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    // Add new agent option
                                    Button(action: { addNewAgent() }) {
                                        Label("Add New Agent...", systemImage: "plus.circle")
                                    }
                                } label: {
                                    HStack {
                                        Text(application.agent?.name ?? "Select...")
                                            .foregroundColor(application.agent == nil ? .secondary : .primary)
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        
                        if !clients.isEmpty || isNew {
                            HStack {
                                Label("Client", systemImage: "briefcase")
                                    .font(.subheadline)
                                    .foregroundColor(.blue.opacity(0.8))
                                
                                Spacer()
                                
                                Menu {
                                    // None option
                                    Button("None") {
                                        application.client = nil
                                    }
                                    
                                    if !clients.isEmpty {
                                        Divider()
                                        
                                        // Existing clients
                                        ForEach(clients) { client in
                                            Button(client.name) {
                                                application.client = client
                                            }
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    // Add new client option
                                    Button(action: { addNewClient() }) {
                                        Label("Add New Client...", systemImage: "plus.circle")
                                    }
                                } label: {
                                    HStack {
                                        Text(application.client?.name ?? "Select...")
                                            .foregroundColor(application.client == nil ? .secondary : .primary)
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // MARK: - Interviews Section
                SectionCard(title: "Interviews", icon: "person.2.wave.2") {
                    VStack(spacing: 12) {
                        // Add button with gradient
                        Button(action: addInterview) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Interview")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(application.status?.name == "Closed")
                        
                        // Interview list - Use let binding to cache the sorted result
                        let sortedInterviews = application.sortedInterviews
                        if !sortedInterviews.isEmpty {
                            ForEach(sortedInterviews) { interview in
                                NavigationLink {
                                    InterviewDetailView(interview: interview, isNew: false)
                                } label: {
                                    InterviewRow(interview: interview)
                                }
                            }
                        } else {
                            Text("No interviews scheduled")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray6).opacity(0.5))
                                .cornerRadius(8)
                        }
                    }
                }
                
                // MARK: - Updates & Notes Section
                SectionCard(title: "Updates & Notes", icon: "note.text") {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Latest Update", systemImage: "bell")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            TextField("What's new?", text: $application.update, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 60)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Notes", systemImage: "note")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            TextField("Additional notes...", text: $application.notes, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .frame(minHeight: 80)
                        }
                    }
                }
                
                // MARK: - Status Section
                SectionCard(title: "Application Status", icon: "flag") {
                    VStack(spacing: 16) {
                        HStack {
                            Label("Status", systemImage: "flag.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue.opacity(0.8))
                            
                            Spacer()
                            
                            Picker("Status", selection: $application.status) {
                                Text("None")
                                    .tag(nil as Status?)
                                ForEach(statuses) { status in
                                    Text(status.name)
                                        .tag(status as Status?)
                                }
                            }
                            .labelsHidden()
                            
                            Button(action: addStatus) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        // Show current status badge
                        if !application.appStatus.isEmpty {
                            HStack {
                                StatusBadge(status: application.appStatus, size: .large)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle(isNew ? "New Application" : "Application")
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
                        modelContext.delete(application)
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if isNew {
                focusedField = .position
            }
            // Set IR35 state on appear
            isInsideIR35 = (application.iR35 == IR35Status.inside.rawValue)
            
            // Sync appStatus with status on appear
            if let statusName = application.status?.name {
                let expectedAppStatus: String
                switch statusName {
                case "Closed": 
                    expectedAppStatus = "Closed"
                case "Interview", "Interviewing": 
                    expectedAppStatus = "Interview"
                case "On hold": 
                    expectedAppStatus = "On hold"
                case "Offer", "Offered": 
                    expectedAppStatus = "Offer"
                case "Accepted", "Acceptance": 
                    expectedAppStatus = "Accepted"
                case "Open":
                    expectedAppStatus = "Open"
                default: 
                    expectedAppStatus = statusName // Use the status name as-is
                }
                
                if application.appStatus != expectedAppStatus {
                    print("📍 onAppear: Syncing appStatus '\(application.appStatus)' → '\(expectedAppStatus)'")
                    application.appStatus = expectedAppStatus
                }
            } else if application.appStatus.isEmpty {
                // No status selected, default to Open
                print("📍 onAppear: No status selected, defaulting to 'Open'")
                application.appStatus = "Open"
            }
        }
        .onChange(of: application.status?.name) { oldValue, newValue in
            // Prevent recursive updates
            guard !isUpdatingStatus else { 
                print("⚠️ Blocked recursive status update")
                return 
            }
            guard oldValue != newValue else { 
                print("⚠️ Status name unchanged: \(newValue ?? "nil")")
                return 
            }
            
            print("✅ Status changing from '\(oldValue ?? "nil")' to '\(newValue ?? "nil")'")
            
            isUpdatingStatus = true
            defer { isUpdatingStatus = false }
            
            let newAppStatus: String
            switch application.status?.name {
            case "Closed": 
                newAppStatus = "Closed"
            case "Interview", "Interviewing": 
                newAppStatus = "Interview"
            case "On hold": 
                newAppStatus = "On hold"
            case "Offer", "Offered": 
                newAppStatus = "Offer"
            case "Accepted", "Acceptance": 
                newAppStatus = "Accepted"
            case "Open":
                newAppStatus = "Open"
            case nil:
                newAppStatus = "Open" // Default when no status selected
            default: 
                newAppStatus = application.status?.name ?? "Open" // Use the status name as-is
            }
            
            print("   Setting appStatus to: '\(newAppStatus)' (was: '\(application.appStatus)')")
            
            // Only update if the status is actually different
            if application.appStatus != newAppStatus {
                application.appStatus = newAppStatus
                print("   ✅ appStatus updated successfully")
            } else {
                print("   ℹ️ appStatus already correct")
            }
        }
        .sheet(item: $newInterview) { interview in
            NavigationStack {
                InterviewDetailView(interview: interview, isNew: true)
            }
            .interactiveDismissDisabled()
        }
        .sheet(item: $newStatus) { status in
            NavigationStack {
                StatusDetail(status: status, isNew: true)
            }
            .interactiveDismissDisabled()
        }
        .sheet(item: $newAgent) { agent in
            NavigationStack {
                AgentDetailView(agent: agent, isNew: true)
            }
            .interactiveDismissDisabled()
        }
        .onChange(of: newAgent) { oldValue, newValue in
            if oldValue != nil && newValue == nil {
                // Sheet was dismissed, check if agent was saved (has a name)
                if let savedAgent = oldValue, !savedAgent.name.isEmpty {
                    application.agent = savedAgent
                } else if let savedAgent = oldValue, savedAgent.name.isEmpty {
                    // User cancelled or left empty, delete it
                    modelContext.delete(savedAgent)
                }
            }
        }

        .sheet(item: $newClient) { client in
            NavigationStack {
                ClientDetailView(client: client, isNew: true)
            }
            .interactiveDismissDisabled()
        }
        .onChange(of: newClient) { oldValue, newValue in
            if oldValue != nil && newValue == nil {
                // Sheet was dismissed, check if client was saved (has a name)
                if let savedClient = oldValue, !savedClient.name.isEmpty {
                    application.client = savedClient
                } else if let savedClient = oldValue, savedClient.name.isEmpty {
                    // User cancelled or left empty, delete it
                    modelContext.delete(savedClient)
                }
            }
        }
    }
    
    private func addInterview() {
        withAnimation {
            let newItem = Interview(name: "", interviewDate: Date(), startTime: Date(), endTime: Date(), location: "", interviewer: "", result: "", notes: "", application: application)
            application.interviews?.append(newItem)
            newInterview = newItem
        }
    }
    
    private func addStatus() {
        withAnimation {
            let newItem = Status(name: "")
            modelContext.insert(newItem)
            newStatus = newItem
        }
    }
    
    private func addNewAgent() {
        withAnimation {
            let agent = Agent(name: "")
            modelContext.insert(agent)
            newAgent = agent
        }
    }

    private func addNewClient() {
        withAnimation {
            let client = Client(name: "")
            modelContext.insert(client)
            newClient = client
        }
    }
}

// MARK: - Helper Components

struct DetailInputRow: View {
    let label: String
    let icon: String
    @Binding var text: String
    let placeholder: String
    var focused: FocusState<ApplicationDetailView.FocusedField?>.Binding? = nil
    var field: ApplicationDetailView.FocusedField? = nil
    var isNew: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(label, systemImage: icon)
                .font(.subheadline)
                .foregroundColor(.blue.opacity(0.8))
            
            if let focused = focused, let field = field, isNew {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
                    .focused(focused, equals: field)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}

struct InterviewRow: View {
    let interview: Interview
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(interview.name.isEmpty ? "Interview" : interview.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    Label(interview.interviewDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                        .foregroundColor(.blue.opacity(0.7))
                    Label(interview.startTime.formatted(date: .omitted, time: .shortened), systemImage: "clock")
                        .foregroundColor(.blue.opacity(0.7))
                }
                .font(.caption)
            }
            
            Spacer()
            
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
        for: Application.self, Agent.self, Agency.self, Client.self, Status.self, Interview.self,
        configurations: config
    )
    
    let agent = Agent(name: "Adele Bywater", mobilePhone: "020 7092 3204")
    let client = Client(name: "ECMS Consultancy")
    let agency = Agency(name: "ECMS Agency")
    let status = Status(name: "Interview")
    
    let application = Application(
        position: "Contract PM - ECMS",
        businessSector: "Insurance",
        positionType: "Project Manager",
        remunerationType: "Weekly",
        remunerationAmount: 650,
        employmentType: "Contract",
        iR35: "Outside IR35",
        positionCommitment: "",
        workstyle: "Hybrid",
        officeDays: "3",
        whereAdvertised: "Direct from Adele",
        dateApplied: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
        requiredSkills: "Insurance, Azure, Cloud migration",
        notes: "Great opportunity",
        appStatus: "Interview"
    )
    application.agent = agent
    application.client = client
    application.agency = agency
    application.status = status
    
    container.mainContext.insert(agent)
    container.mainContext.insert(client)
    container.mainContext.insert(agency)
    container.mainContext.insert(status)
    container.mainContext.insert(application)
    
    return NavigationStack {
        ApplicationDetailView(application: application)
            .modelContainer(container)
    }
}

