//
//  ContentView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 12/04/2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        TabView {
            ChartsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
            FilteredApplicationList()
                .tabItem {
                    Label("Applications", systemImage: "person.crop.rectangle.stack.fill")
                }
            FilteredAgentList()
                .tabItem {
                    Label("Agents", systemImage: "phone.bubble")
                }

            FilteredClientList()
                .tabItem {
                    Label("Clients", systemImage: "building.2.fill")
                }
        }
    }
}

//#Preview {
//    ContentView()
//}
