//
//  FilteredAgentList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 21/04/2024.
//

import SwiftUI

struct FilteredAgentList: View {
    @State private var searchText = ""
    
    var body: some View {
            AgentList(agentFilter: searchText)
                .searchable(text: $searchText)
    }
}

#Preview {
    FilteredAgentList()
}
