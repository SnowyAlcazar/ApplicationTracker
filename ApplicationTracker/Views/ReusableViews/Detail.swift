//
//  Detail.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/02/2025.
//

import SwiftUI

struct Detail: View {
    let label: String
    let text: String
    let destination: URL
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(label)
                .font(.footnote)
                .bold()
            Link(text, destination: destination)
                .buttonStyle(BorderlessButtonStyle())
        }
    }
}

#Preview("Detail") {
    List {
        Detail(
            label: "Email",
            text: Agent.default.email,
            destination: URL(string: "example.com")!
        )
    }
    .listStyle(.plain)
}
