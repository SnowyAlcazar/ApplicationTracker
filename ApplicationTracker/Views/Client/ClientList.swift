//
//  ClientList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 12/04/2024.
//

import SwiftUI
import SwiftData

struct ClientList: View {
    @Environment(\.modelContext) var modelContext
    @State private var searchText = ""
    @State private var newClient: Client?
    
    @Query(sort: [SortDescriptor(\Client.name)]) var clients: [Client]
    
    init(clientFilter: String = "") {
        let predicate = #Predicate<Client> { client in
            clientFilter.isEmpty
            || client.name.localizedStandardContains(clientFilter)
        }
        _clients = Query(filter: predicate, sort: \Client.name)
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                if clients.isEmpty {
                    // Empty State
                    ContentUnavailableView(
                        "No Clients Yet",
                        systemImage: "building.2",
                        description: Text("Add companies you're applying to or interviewing with")
                    )
                } else {
                    // Client List
                    List {
                        ForEach(clients) { client in
                            NavigationLink {
                                ClientDetailView(client: client, isNew: false)
                            } label: {
                                ClientListRow(client: client)
                            }
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteClients)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Clients")
            .searchable(text: $searchText)
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
    
    private func deleteClients(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(clients[index])
            }
        }
    }
    
    private func addClient() {
        withAnimation {
            let newItem = Client(name: "", businessSegment: "", hiringManager: "", hiringManagerPosition: "")
            modelContext.insert(newItem)
            newClient = newItem
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Client.self, configurations: config)
    
    return NavigationStack {
        ClientList()
            .modelContainer(container)
    }
}
