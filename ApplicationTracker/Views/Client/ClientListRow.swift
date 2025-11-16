//
//  ClientListRow.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 15/11/2025.
//

import SwiftUI
import SwiftData

struct ClientListRow: View {
    let client: Client
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: Company info
            HStack(alignment: .top, spacing: 12) {
                // Company icon
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "building.2.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(client.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if !client.businessSegment.isEmpty {
                        Text(client.businessSegment)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            // Hiring manager info (if available)
            if !client.hiringManager.isEmpty || !client.hiringManagerPosition.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "person.badge.key.fill")
                        .font(.caption)
                        .foregroundColor(.blue.opacity(0.7))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        if !client.hiringManager.isEmpty {
                            Text(client.hiringManager)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        if !client.hiringManagerPosition.isEmpty {
                            Text(client.hiringManagerPosition)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // Application count if any
            if let applications = client.associatedApplications, !applications.isEmpty {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("\(applications.count) application\(applications.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Show status breakdown
                    let activeCount = applications.filter { $0.appStatus != "Closed" }.count
                    if activeCount > 0 {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 6, height: 6)
                            Text("\(activeCount) active")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Client.self, Application.self, configurations: config)
    
    let client1 = Client(
        name: "ECMS Consultancy",
        businessSegment: "Insurance",
        hiringManager: "Sarah Johnson",
        hiringManagerPosition: "Head of IT"
    )
    
    let client2 = Client(
        name: "Tech Corp",
        businessSegment: "Technology"
    )
    
    let app1 = Application(position: "PM Role", appStatus: "Interview")
    app1.client = client1
    
    container.mainContext.insert(client1)
    container.mainContext.insert(client2)
    container.mainContext.insert(app1)
    
    return VStack(spacing: 12) {
        ClientListRow(client: client1)
        ClientListRow(client: client2)
    }
    .padding()
    .background(Color.black)
    .modelContainer(container)
}

