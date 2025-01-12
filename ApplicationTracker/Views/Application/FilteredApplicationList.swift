//
//  FilteredApplicationList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/05/2024.
//

import SwiftUI
import SwiftData

struct FilteredApplicationList: View {
    @Environment(\.modelContext) var modelContext
    @State private var searchText = ""
    @State private var showingClosed = false
    @State private var newApplication: Application?
    
    
    var body: some View {
        NavigationSplitView {
            ApplicationList(applicationFilter: searchText)
                .searchable(text: $searchText)
        } detail: {
            Text("Select an application")
                .navigationTitle("Application")
        }
        .navigationTitle("Job Applications")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
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
                officeDays: "")
            modelContext.insert(newItem)
            newApplication = newItem
        }
    }
}
//
//#Preview {
//    FilteredApplicationList()
//}


///QueryView code
///@State private var dateSort: SortDescriptor<Application> = .init(\.dateApplied, order: .forward)

/*
 VStack {
     HStack {
         TextField("Search", text: $searchText)
         Button("Date", systemImage: "arrow.\(dateSort.order == .forward ? "up" : "down")") {
             dateSort.order = dateSort.order == .forward ? .reverse : .forward
         }
     }
     .font(.title3)
     .padding(20)
     SectionedQueryView(for: Application.self, sectionedBy: \.status,
                        sort: [dateSort, .init(\.status)]) { sections in
         ForEach(sections) { section in
             Section {
                 ForEach(section.models, content: ApplicationListRowView.init)
             } header: {
                 Text(section.key)
                     .font(.title2)
             }
         }
     } filter: {
         #Predicate { item in
             if searchText.isEmpty {
                 true
             } else {
                 item.position.contains(searchText)
             }
         }
     }
 }

 */
