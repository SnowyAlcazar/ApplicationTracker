//
//  ApplicationListCard.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/11/2025.
//

import SwiftUI
import SwiftData

struct ApplicationListCard: View {
    let application: Application
    
    // MARK: - Computed Properties
    
    private var statusColor: Color {
        // TODO: Adjust these based on your actual status values
        switch application.appStatus.lowercased() {
        case "open":
            return .blue
        case "interview":
            return .green
        case "closed", "rejected":
            return .orange
        case "offer":
            return .purple
        default:
            return .gray
        }
    }
    
    private var statusIcon: String {
        switch application.appStatus.lowercased() {
        case "open":
            return "envelope.open"
        case "interview":
            return "person.2"
        case "closed", "rejected":
            return "xmark.circle"
        case "offer":
            return "checkmark.circle"
        default:
            return "circle"
        }
    }
    
    private var companyName: String {
        application.client?.name ?? "No company"
    }
    
    private var agentName: String {
        application.agent?.name ?? "No agent"
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: application.dateApplied)
    }
    
    private var elapsedDays: Int {
        Calendar.current.dateComponents([.day], from: application.dateApplied, to: Date()).day ?? 0
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: Title and favorite/star (if you add that feature)
            HStack(alignment: .top) {
                Text(application.position)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Company name
            Text(companyName)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Details row with icons
            HStack(spacing: 16) {
                Label(formattedDate, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Label(agentName, systemImage: "person")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            // Status badge and elapsed days
            HStack {
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
                
                // Elapsed days (smaller, de-emphasized)
                Text("\(elapsedDays)d")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Application.self, Agent.self, Agency.self, Client.self, configurations: config)
    
    // Create sample data
    let agent = Agent(name: "Adele Bywater", mobilePhone: "020 7092 3204", email: "adele@ecm.com")
    let client = Client(name: "ECMS Consultancy")
    let application = Application(
        position: "Contract PM - ECMS",
        businessSector: "Insurance",
        positionType: "PM",
        employmentType: "Contract",
        dateApplied: Calendar.current.date(byAdding: .day, value: -266, to: Date())!,
        appStatus: "Interview"
    )
    application.agent = agent
    application.client = client
    
    container.mainContext.insert(agent)
    container.mainContext.insert(client)
    container.mainContext.insert(application)
    
    return VStack(spacing: 12) {
        ApplicationListCard(application: application)
        
        // Show another status
        ApplicationListCard(application: {
            let app = Application(
                position: "Project Manager",
                businessSector: "Finance",
                dateApplied: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                appStatus: "Open"
            )
            app.client = Client(name: "Big Bank Corp")
            app.agent = Agent(name: "John Smith")
            return app
        }())
    }
    .padding()
    .background(Color.black)
    .modelContainer(container)
}
