//
//  ClientList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 12/04/2024.
//

import SwiftUI
import SwiftData

struct ClientList: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedClient: String = ""
    
    @Query(sort: \Client.name) private var clients: [Client]
    
    init(clientFilter: String = "") {
        let predicate = #Predicate<Client> { client in
            clientFilter.isEmpty
            || client.name.localizedStandardContains(clientFilter)
        }
        _clients = Query(filter: predicate, sort: \Client.name)
    }
    
    @State private var newClient: Client?
    
    var body: some View {
        NavigationSplitView {
            Group {
                if !clients.isEmpty {
                    List {
                        ForEach(clients) { client in
                            NavigationLink {
                                ClientDetailView(client: client)
                                    .navigationTitle("Agency")
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Label("", systemImage: "building.2.fill")
                                            .labelsHidden()
                                            .padding(.trailing, 5)
                                        Text(client.name)
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteClients)
                        .listRowSeparator(.visible)
                        .padding([.top, .bottom])
                    }
                    .font(.caption)

                } else {
                    ContentUnavailableView {
                        Label("No clients", systemImage: "person.and.person")
                    }
                }
            }
            .navigationTitle("Clients")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addClient) {
                        Label("Add Client", systemImage: "plus")
                    }
                }
            }
            .sheet(item: $newClient) { client in
                NavigationStack {
                    ClientDetailView(client: client, isNew: true)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select a client")
                .navigationTitle("Client")
        }
    }
    
    private func addClient() {
        withAnimation {
            let newItem = Client(name: "")
            modelContext.insert(newItem)
            newClient = newItem
        }
    }
    private func deleteClients(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(clients[index])
            }
        }
    }
}

#Preview {
    let preview = Preview(Client.self)
    preview.addExamples(Client.sampleClients)
    return NavigationStack {
        ClientList()
            .modelContainer(preview.container)
    }
}
