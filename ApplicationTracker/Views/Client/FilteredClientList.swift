//
//  FilteredClientList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 21/04/2024.
//

import SwiftUI

struct FilteredClientList: View {
    @State private var searchText = ""
    
    var body: some View {
            ClientList(clientFilter: searchText)
                .searchable(text: $searchText)            
    }
}

#Preview {
    FilteredClientList()
}
