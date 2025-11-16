//
//  AgentRow.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 21/05/2024.
//

import SwiftUI
import SwiftData

struct AgentRow: View {
    let agent: Agent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: Name and favorite
            HStack(alignment: .top) {
                // Initials circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 45, height: 45)
                    .overlay(
                        Text(agentInitials)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(agent.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if let agency = agent.agency {
                        Text(agency.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if agent.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.title3)
                }
            }
            
            // Contact info row
            HStack(spacing: 16) {
                if !agent.mobilePhone.isEmpty {
                    Label(agent.mobilePhone, systemImage: "phone.fill")
                        .font(.caption)
                        .foregroundColor(.blue.opacity(0.7))
                }
                
                if !agent.email.isEmpty {
                    Label(truncatedEmail, systemImage: "envelope.fill")
                        .font(.caption)
                        .foregroundColor(.blue.opacity(0.7))
                        .lineLimit(1)
                }
            }
            
            // Application count if any
            if let applications = agent.representedBy, !applications.isEmpty {
                HStack {
                    Image(systemName: "briefcase.fill")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("\(applications.count) application\(applications.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var agentInitials: String {
        let components = agent.name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.prefix(2)
        return String(initials).uppercased()
    }
    
    private var truncatedEmail: String {
        if agent.email.count > 25 {
            return String(agent.email.prefix(22)) + "..."
        }
        return agent.email
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Agent.self, Agency.self, configurations: config)
    
    let agency = Agency(name: "ECMS Consultancy")
    let agent1 = Agent(
        name: "Adele Bywater",
        officePhone: "020 8565 0009",
        mobilePhone: "020 7092 3204",
        email: "adele.bywater@ecmconsultancy.com",
        isFavorite: true
    )
    agent1.agency = agency
    
    let agent2 = Agent(
        name: "John Smith",
        mobilePhone: "07700 900123",
        email: "john@agency.com"
    )
    
    container.mainContext.insert(agency)
    container.mainContext.insert(agent1)
    container.mainContext.insert(agent2)
    
    return VStack(spacing: 12) {
        AgentRow(agent: agent1)
        AgentRow(agent: agent2)
    }
    .padding()
    .background(Color.black)
    .modelContainer(container)
}

// MARK: - Color Extension (if not already in project)


//#Preview {
//    AgentRow()
//}
