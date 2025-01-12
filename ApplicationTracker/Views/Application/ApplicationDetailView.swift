//
//  ApplicationDetailView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
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

    init(application: Application, isNew: Bool = false) {
        self.application = application
        self.isNew = isNew
    }

    @State private var locationType = ""
    @State private var dateApplied: Date = Date.now
    @State private var update: String = ""
    @State private var updatedAt: Date = Date.now
    @State private var agentName: String = ""
    @State private var agentPhone: String = ""
    @State private var agentEmail: String = ""
    @State private var clientHiringManager: String = ""
    @State private var interviewDate: Date = Date()
    @State private var interviewResult: String = ""
    @State private var positionTypes: String = ""
    @State private var businessSector: String = ""
    
    @Query(sort: [SortDescriptor(\Agency.name)]) var agencies: [Agency]
    @Query(sort: [SortDescriptor(\Agent.name)]) var agents: [Agent]
    @Query(sort: [SortDescriptor(\Client.name)]) var clients: [Client]
    @Query(sort: [SortDescriptor(\Status.name)]) var statuses: [Status]

    /// Setting focus state for fields

    enum FocusedField {
         case position
    }

    @State private var position = ""
    @FocusState private var focusedField: FocusedField?
    @State private var newStatus: Status?
    @State private var isEditingStatusList = false

    
    var body: some View {
        Form {
            Section("About the job you applied for") {
                VStack(alignment: .leading) {
                    Text("POSITION TITLE")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    if isNew {
                        TextField("Add a job title", text: $application.position, axis: .vertical)
                            .focused($focusedField, equals: .position)
                            .padding(.bottom)
                    } else {
                        TextField("Add a job title", text: $application.position)
                            .padding(.bottom)
                    }
                    
                    Text("BUSINESS SECTOR")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    TextField("Which business sector: Finance, Travel etc", text: $application.businessSector)
                        .padding(.bottom)

                    Text("ROLE TYPE")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    TextField("Sales agent, Project Manager, Accountant, PA etc", text: $application.positionType)
                        .padding(.bottom)

                    Text("EMPLOYMENT BASIS")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    TextField("Permanent, contract, temporary etc", text: $application.employmentType)
                        .padding(.bottom)

                    HStack {
                        Text("SELECT THE DATE YOU APPLIED FOR THIS JOB")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Spacer()
                        DatePicker("Date applied", selection: $application.dateApplied, displayedComponents: .date)
                            .labelsHidden()
                    }
                }
            }
            Section("Pay and conditions") {
                VStack(alignment: .leading) {
                    Text("PAY UNITS")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    TextField("Hourly, Daily, Annual etc", text: $application.remunerationType)
                        .padding(.bottom)
                    Text("PAY PER UNIT")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    TextField("Enter the pay rate", value: $application.remunerationAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .padding(.bottom)
                    Text("IR35 OR OTHER TAX REGS")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    TextField("Inside / Outside... any other tax based considerations", text: $application.iR35)
                        .padding(.bottom)
                    Text("HOW MANY DAYS A WEEK IN OFFICE")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                    TextField("Approximately how many days in the office?", text: $application.officeDays)
                        .padding(.bottom)
                    Text("TIME COMMITMENT")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                    TextField("Full-time, Part-time, Job share etc", text: $application.positionCommitment)
                        .padding(.bottom)
                    Text("WORKSTYLE")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                    TextField("Remote, Hybrid, Office etc", text: $application.workstyle)
                        .padding(.bottom)
                }
            }
            Section("Origin, skills and experience") {
                VStack(alignment: .leading) {
                    Text("WHERE DID YOU SEE THIS JOB ADVERTISED?")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    TextField("JobServe, Hays, etc", text: $application.whereAdvertised, axis: .vertical)
                        .labelsHidden()
                        .padding(.bottom)

                    Text("SKILLS AND EXPERIENCE")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding(.top)
                    TextField("Add the core required skills and experience", text: $application.requiredSkills, axis: .vertical)
                        .labelsHidden()
                        .padding(.bottom)
                }
            }
            Section("Contacts") {
                VStack(alignment: .leading) {
                    if !agencies.isEmpty {
                        HStack {
                            Text("SELECT AN AGENCY")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Spacer()
                            Picker("Pick an agency if known", selection: $application.agency) {
                                Text("None")
                                    .tag(nil as Agency?)
                                ForEach(agencies) { agency in
                                    Text(agency.name)
                                        .tag(agency as Agency?)
                                        .font(.caption)
                                }
                            }
                            .labelsHidden()
                        }
                    }
                    if !agents.isEmpty {
                        HStack {
                            Text("SELECT AN AGENT")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Spacer()
                            Picker("Pick an agent if known", selection: $application.agent) {
                                Text("None")
                                    .tag(nil as Agent?)
                                ForEach(agents) { agent in
                                    Text(agent.name)
                                        .tag(agent as Agent?)
                                }
                            }
                            .labelsHidden()
                        }
                    }
                    if !clients.isEmpty {
                        HStack {
                            Text("SELECT A CLIENT")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Spacer()
                            Picker("Pick a client if known", selection: $application.client) {
                                Text("None")
                                    .tag(nil as Client?)
                                ForEach(clients) { client in
                                    Text(client.name)
                                        .tag(client as Client?)
                                }
                            }
                            .labelsHidden()
                        }
                    }
                }
            }
            Section("Interviews") {
                HStack {
                    Text("ADD AN INTERVIEW")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                    Button("Add New") {
                        addInterview()
                    }
                    .background(.tint)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(5)
                    .disabled(application.status?.name == "Closed")
                }
                
                List {
                    if !application.sortedInterviews.isEmpty {
                        ForEach(application.sortedInterviews) { assocInterview in
                            NavigationLink {
                                InterviewDetailView(interview: assocInterview, isNew: false)
                                    .navigationTitle("Interview Detail")
                            } label: {
                                //InterviewListRow(interview: assocInterview)
                                HStack {
                                    Text(assocInterview.name)
                                    Spacer()
                                    Text(assocInterview.interviewDate, style: .date)
                                    Text("")
                                    Text(assocInterview.startTime, style: .time)
                                    Text(":")
                                    Text(assocInterview.endTime, style: .time)
                                }
                            }
                        }
                    }
                }
            }
            Section("Updates and notes") {
                    Text("WHAT'S NEW?")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    TextField("Type your update here...", text: $application.update, axis: .vertical)
                    Text("NOTES")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    TextField("Add notes here...", text: $application.notes, axis: .vertical)
            }
            Section("Application Status") {
                VStack {
                    HStack {
                        Text("APPLICATION STATUS")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Spacer()
                        Picker("Select a status", selection: $application.status) {
                            Text("None")
                                .tag(nil as Status?)
                            ForEach(statuses) { status in
                                Text(status.name)
                                    .tag(status as Status?)
                            }
                        }
                        .labelsHidden()
                        Spacer()
                        
                        Button("Add New") {
                            addSatus()
                        }
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .background(.tint.opacity(0.75))
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(5)
                    }
                }
            }
        }
        .onAppear {
            focusedField = .position
        }
        .onChange(of: application.status?.name) { oldValue, newValue in
            switch application.status?.name {
            case "Closed": return application.appStatus = "Closed"
            case "Interview": return application.appStatus = "Interview"
            case "On hold": return application.appStatus = "On hold"
            case "None": return application.appStatus = "None"
            case "Offer": return application.appStatus = "Offer"
            case "Accepted": return application.appStatus = "Accepted"
            default: return application.appStatus = "Open"
            }
        }
        .onChange(of: application) { oldValue, newValue in
            application.update(keyPath: \.updatedAt, to: Date.now)
        }
        .navigationTitle(isNew ? "New Application" : "Application")
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
    }
    
    private func addInterview() {
        withAnimation {
            let newItem = Interview(name: "", interviewDate: Date(), startTime: Date(), endTime: Date(), location: "", interviewer: "", result: "", notes: "", application: application)
            application.interviews?.append(newItem)
            newInterview = newItem
        }
    }
    
    private func addSatus() {
        withAnimation {
            let newItem = Status(name: "")
            modelContext.insert(newItem)
            newStatus = newItem
        }
    }
}

#Preview {
    let preview = Preview(Application.self)
    return NavigationStack {
        ApplicationDetailView(application: Application.sampleApps[2])
            .modelContainer(preview.container)
    }
}

