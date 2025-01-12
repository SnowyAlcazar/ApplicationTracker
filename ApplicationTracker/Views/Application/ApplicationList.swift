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
    
    ///For amending the Query and filtering/sorting the applicationFilter results
    ///_applications = Query(filter: predicate, sort: [SortDescriptor(\Application.status?.name, order: .reverse), SortDescriptor(\Application.dateApplied, order: .reverse)])

    
    init(applicationFilter: String = "") {
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

    var body: some View {
        VStack {
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
}

//#Preview {
//    let preview = Preview(Application.self)
//    preview.addExamples(Application.sampleApps)
//    return NavigationStack {
//        ApplicationList()
//            .modelContainer(preview.container)
//    }
//}


