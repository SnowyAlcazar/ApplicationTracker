//
//  StatusList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 16/05/2024.
//

import SwiftUI
import SwiftData

struct StatusList: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var status: Status
    @State private var selectedStatus: String = ""
    @Query(sort: [SortDescriptor(\Status.name)]) private var statuses: [Status]
        
    @State private var newStatus: Status?
    let isNew: Bool

    var body: some View {
        NavigationSplitView {
            Group {
                if !statuses.isEmpty {
                    List {
                        ForEach(statuses) { status in
                            NavigationLink {
                                StatusDetail(status: status)
                                    .navigationTitle("Status")
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(status.name)
                                }
                            }
                        }
                        .onDelete(perform: deleteStatuses)
                    }
                    .font(.caption)
                } else {
                    ContentUnavailableView {
                        Label("No statuses", systemImage: "xmark.circle")
                    }
                }
            }
            .navigationTitle("Statuses")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }

                if isNew {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            modelContext.delete(status)
                            dismiss()
                        }
                    }
                }
            }
            .sheet(item: $newStatus) { status in
                NavigationStack {
                    StatusDetail(status: status, isNew: true)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select a status")
                .navigationTitle("Status")
        }
    }
    
    private func deleteStatuses(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(statuses[index])
            }
        }
    }
}

#Preview {
    let isNew = false
    let preview = Preview(Status.self)
    preview.addExamples(Status.sampleStatuses)
    return NavigationStack {
        StatusList(status: Status(name: "Open"), isNew: false)
            .modelContainer(preview.container)
    }
}

