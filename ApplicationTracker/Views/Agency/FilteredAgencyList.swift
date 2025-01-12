//
//  FilteredAgencyList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 21/04/2024.
//

import SwiftUI

struct FilteredAgencyList: View {
    @State private var searchText = ""
    
    var body: some View {
            AgencyList(agencyFilter: searchText)
                .searchable(text: $searchText)            
        }
}

//#Preview {
//    FilteredAgencyList()
//}
