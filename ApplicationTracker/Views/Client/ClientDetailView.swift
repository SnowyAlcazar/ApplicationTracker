//
//  ClientView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 02/04/2024.
//

import SwiftUI

struct ClientDetailView: View {
    enum FocusedField {
        case name
    }
    @Bindable var client: Client
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var sortOrder = KeyPathComparator(\Application.dateApplied)

    init(client: Client, isNew: Bool = false) {
        self.client = client
        self.isNew = isNew
    }
    @State private var name = ""
    @FocusState private var focusedField: FocusedField?
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        Form {
            if isNew {
                TextField("Client name", text: $client.name)
                    .focused($focusedField, equals: .name)
                    .autocorrectionDisabled()
            } else {
                TextField("Client name", text: $client.name)
                    .autocorrectionDisabled()
            }
            
            Section("Positions applied for at \(client.name)") {
                let sortedApplications = client.associatedApplications?.sorted(using: sortOrder) ?? []
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
        .navigationTitle(isNew ? "New Client" : "Client")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        modelContext.delete(client)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
let preview = Preview(Client.self)
    return NavigationStack {
        ClientDetailView(client: Client.sampleClients[1])
            .modelContainer(preview.container)
    }
}
