//
//  ApplicationListRowView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/11/2025.
//

//
//  ApplicationListRowView.swift
//  ApplicationTracker
//
//  REDESIGNED VERSION - Drop-in replacement for existing view
//  Created by Mark Brown on 29/03/2024.
//  Redesigned for App Store readiness
//

import SwiftUI
import SwiftData

struct ApplicationListRowView: View {
    @Environment(\.modelContext) var modelContext
    var application: Application
    
    // MARK: - Computed Properties
    
    private var statusColor: Color {
        switch application.appStatus {
        case "Open": return .green
        case "Interview": return .orange
        case "On hold": return .red
        case "Offer": return .pink
        case "Accepted": return .purple
        case "Closed": return .gray
        default: return .blue
        }
    }
    
    private var statusIcon: String {
        switch application.appStatus {
        case "Open": return "envelope.open.fill"
        case "Interview": return "person.2.fill"
        case "On hold": return "pause.circle.fill"
        case "Offer": return "checkmark.circle.fill"
        case "Accepted": return "star.fill"
        case "Closed": return "xmark.circle.fill"
        default: return "circle.fill"
        }
    }
    
    private var companyName: String {
        application.client?.name ?? application.agency?.name ?? "No company"
    }
    
    private var agentName: String {
        application.agent?.name ?? "No agent"
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: application.dateApplied)
    }
    
    private func calculateElapsedDays() -> Int {
        let calendar = Calendar.current
        let diffs = calendar.dateComponents([.day], from: application.dateApplied.startOfDay, to: .now.endOfDay)
        return diffs.day ?? 0
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: Job title
            HStack(alignment: .top, spacing: 8) {
                Text(application.position.isEmpty ? "Untitled Position" : application.position)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Show closed badge if closed
                if application.appStatus == "Closed" {
                    Text("CLOSED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray)
                        .cornerRadius(4)
                }
            }
            
            // Company name
            if !companyName.isEmpty && companyName != "No company" {
                Text(companyName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            // Details row with icons
            HStack(spacing: 12) {
                // Date applied
                Label(formattedDate, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Agent name (if exists)
                if agentName != "No agent" {
                    Label(agentName, systemImage: "person")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            // Bottom row: Status badge and elapsed days
            HStack(alignment: .center) {
                // Status badge
                HStack(spacing: 6) {
                    Image(systemName: statusIcon)
                        .font(.caption2)
                    Text(application.appStatus)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(statusColor.opacity(0.15))
                .foregroundColor(statusColor)
                .cornerRadius(12)
                
                Spacer()
                
                // Elapsed days (only show for open/interview)
                if application.appStatus == "Open" || application.appStatus == "Interview" {
                    let days = calculateElapsedDays()
                    Text("\(days)d ago")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .background(
            application.appStatus == "Closed"
            ? Color(.systemGray6).opacity(0.5)
            : Color(.systemGray6)
        )
        .cornerRadius(12)
        .opacity(application.appStatus == "Closed" ? 0.6 : 1.0)
    }
}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Application.self, Agent.self, Agency.self, Client.self, Status.self,
        configurations: config
    )
    
    // Create sample data
    let agent = Agent(name: "Adele Bywater")
    let client = Client(name: "ECMS Consultancy")
    let agency = Agency(name: "ECMS Agency")
    
    let app1 = Application(
        position: "Contract PM - ECMS",
        businessSector: "Insurance",
        positionType: "PM",
        employmentType: "Contract",
        dateApplied: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
        appStatus: "Interview"
    )
    app1.agent = agent
    app1.client = client
    
    let app2 = Application(
        position: "Project Manager",
        employmentType: "Permanent",
        dateApplied: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
        appStatus: "Open"
    )
    app2.agency = agency
    
    let app3 = Application(
        position: "Senior PM",
        employmentType: "Contract",
        dateApplied: Calendar.current.date(byAdding: .day, value: -100, to: Date())!,
        appStatus: "Closed"
    )
    
    container.mainContext.insert(agent)
    container.mainContext.insert(client)
    container.mainContext.insert(agency)
    container.mainContext.insert(app1)
    container.mainContext.insert(app2)
    container.mainContext.insert(app3)
    
    return List {
        ApplicationListRowView(application: app1)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .listRowBackground(Color.clear)
        
        ApplicationListRowView(application: app2)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .listRowBackground(Color.clear)
        
        ApplicationListRowView(application: app3)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(Color.black)
    .modelContainer(container)
}

