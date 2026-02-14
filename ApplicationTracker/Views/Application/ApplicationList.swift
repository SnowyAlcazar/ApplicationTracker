//
//  ApplicationList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 15/05/2024.
//

import SwiftUI
import SwiftData

struct ApplicationList: View {
    @Environment(\.modelContext) var modelContext
    @State private var searchText = ""
    @State private var newApplication: Application?
    @Query var statuses: [Status]
    @Query var clients: [Client]
    @Query var agents: [Agent]
    @Query var agencies: [Agency]
    @Query var applications: [Application]
    @State private var sortOrder = KeyPathComparator(\Application.dateApplied)
    @State private var showClosedApplications = false
    var status = Status()
    
    @State private var hasInitializedStatuses = false
    
    ///For amending the Query and filtering/sorting the applicationFilter results
    ///_applications = Query(filter: predicate, sort: [SortDescriptor(\Application.status?.name, order: .reverse), SortDescriptor(\Application.dateApplied, order: .reverse)])

    
    init(applicationFilter: String = "") {
        print("🟢 ApplicationList init called")
        let predicate = #Predicate<Application> { application in
            applicationFilter.isEmpty
            || application.position.localizedStandardContains(applicationFilter)
            || application.positionType.localizedStandardContains(applicationFilter)
            || application.employmentType.localizedStandardContains(applicationFilter)
            || application.remunerationType.localizedStandardContains(applicationFilter)
            || application.notes.localizedStandardContains(applicationFilter)
            || application.update.localizedStandardContains(applicationFilter)
            || application.requiredSkills.localizedStandardContains(applicationFilter)
            || application.appStatus.localizedStandardContains(applicationFilter)
        }
        _applications = Query(filter: predicate, sort: [SortDescriptor(\Application.status?.name, order: .forward), SortDescriptor(\Application.dateApplied, order: .reverse)])
    }

    // UPDATE ApplicationList.swift
    // Replace the body with this version that includes empty state:

    var body: some View {
        VStack {
            if applications.isEmpty {
                // Empty State
                ContentUnavailableView(
                    "No Applications Yet",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text("Track your job search by adding your first application")
                )
            } else {
                // Existing List
                List {
                    ForEach(applications) { application in
                        if application.appStatus != "Closed" {
                            NavigationLink {
                                ApplicationDetailView(application: application, isNew: false)
                                    .navigationTitle("Application")
                            } label: {
                                ApplicationListRowView(application: application)
                            }
                        }
                    }
                    .onDelete(perform: deleteApplications)
                    .listRowSeparator(.visible)
                }
            }
        }
        .navigationTitle("Applications")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: addApplication) {
                    Label("Add Application", systemImage: "plus")
                }
            }
        }
        .sheet(item: $newApplication) { application in
            NavigationStack {
                ApplicationDetailView(application: application, isNew: true)
            }
            .interactiveDismissDisabled()
        }
        .onAppear {
            print("🔵 ApplicationList appeared")
            print("🔵 Current statuses count: \(statuses.count)")
            initializeDefaultStatuses()
        }
    }
    
    private func deleteApplications(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(applications[index])
            }
        }
    }
    
    private func addApplication() {
        withAnimation {
            let newItem = Application(
                position: "",
                positionType: "",
                remunerationType: "",
                employmentType: "",
                iR35: "",
                positionCommitment: "",
                workstyle: "",
                officeDays: "",
                appStatus: "Open")
            modelContext.insert(newItem)
            newApplication = newItem
        }
    }
    
    private func initializeDefaultStatuses() {
        // Only initialize once
        guard !hasInitializedStatuses else { 
            print("🔵 Already initialized statuses flag")
            return 
        }
        hasInitializedStatuses = true
        
        print("🔵 Initializing statuses...")
        
        // Define required statuses
        let defaultStatuses = [
            "Open",
            "Interview",
            "On hold",
            "Offer",
            "Accepted",
            "Closed"
        ]
        
        // Get names of existing statuses
        let existingNames = Set(statuses.map { $0.name })
        print("   Found \(statuses.count) existing: \(existingNames)")
        
        // Create any missing statuses
        var created = 0
        for statusName in defaultStatuses {
            if !existingNames.contains(statusName) {
                let status = Status(name: statusName)
                modelContext.insert(status)
                print("   ✅ Creating status: '\(statusName)'")
                created += 1
            } else {
                print("   ℹ️ Already exists: '\(statusName)'")
            }
        }
        
        if created > 0 {
            do {
                try modelContext.save()
                print("📋 Created \(created) new status(es)!")
            } catch {
                print("❌ Error saving: \(error)")
            }
        } else {
            print("📋 All 6 statuses already exist")
        }
    }
}

//#Preview {
//    let preview = Preview(Application.self)
//    preview.addExamples(Application.sampleApps)
//    return NavigationStack {
//        ApplicationList()
//            .modelContainer(preview.container)
//    }
//}


