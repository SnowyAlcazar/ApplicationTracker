//
//  AgentRow.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 21/05/2024.
//

import SwiftUI
import SwiftData

struct AgentRow: View {
    @Environment(\.modelContext) private var modelContext
    var agent: Agent

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label("", systemImage: "phone.bubble")
                    .labelsHidden()
                    .padding(.trailing, 5)
                Text(agent.name)
                    .font(.subheadline)
                Spacer()
                if agent.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.clear)
                }
            }

            HStack {
                Label("", systemImage: "building.columns.fill")
                    .labelsHidden()
                    .padding(.trailing, 5)
                Text(agent.agency?.name ?? "")
                    .font(.caption)
            }
        }
        //.background(.yellow.opacity(0.08))
    }
}

//#Preview {
//    AgentRow()
//}
