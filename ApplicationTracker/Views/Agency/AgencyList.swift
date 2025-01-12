//
//  AgencyList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 02/04/2024.
//

import SwiftUI
import SwiftData

struct AgencyList: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAgency: String = ""
    
    @Query(sort: [SortDescriptor(\Agency.name)]) private var agencies: [Agency]
     
    init(agencyFilter: String = "") {
         let predicate = #Predicate<Agency> { agency in
             agencyFilter.isEmpty
             || agency.name.localizedStandardContains(agencyFilter)
         }
         _agencies = Query(filter: predicate, sort: \Agency.name)
     }
        
    @State private var newAgency: Agency?
    
    var body: some View {
        NavigationSplitView {
            Group {
                if !agencies.isEmpty {
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
                        .listRowSeparator(.visible)
                    }
                    .font(.caption)
                } else {
                    ContentUnavailableView {
                        Label("No agencies", systemImage: "person.and.person")
                    }
                }
            }
            .navigationTitle("Agencies")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addAgency) {
                        Label("Add Agency", systemImage: "plus")
                    }
                }
            }
            .sheet(item: $newAgency) { agency in
                NavigationStack {
                    AgencyDetailView(agency: agency, isNew: true)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select an agency")
                .navigationTitle("Agency")
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
//    let preview = Preview(Agency.self)
//    preview.addExamples(Agency.sampleAgencies)
//    return NavigationStack {
//        AgencyList()
//            .modelContainer(preview.container)
//    }
//}
