//
//  ApplicationsByStatus.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 21/05/2024.
//

import SwiftUI
import SwiftData
import Charts

struct ApplicationsByStatus: View {
    @Query(sort: \Application.dateApplied, order: .reverse) var applications: [Application]
    
    @State private var dataPoints: [StatusData] = []
    
    // Calculate total active applications
    private var activeCount: Int {
        applications.filter { $0.appStatus != "Closed" }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text("Active Applications")
                    .font(.headline)
                Text("\(activeCount) active • \(applications.count) total")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Chart
            if dataPoints.isEmpty {
                ContentUnavailableView(
                    "No Active Applications",
                    systemImage: "chart.pie",
                    description: Text("Add some applications to see the breakdown")
                )
                .frame(height: 300)
            } else {
                Chart(dataPoints) { dataPoint in
                    SectorMark(
                        angle: .value("Count", dataPoint.val),
                        innerRadius: .ratio(0.618),  // Golden ratio for aesthetics
                        angularInset: 2
                    )
                    .foregroundStyle(dataPoint.color)
                    .cornerRadius(4)
                    .annotation(position: .overlay) {
                        if dataPoint.val > 0 {
                            Text("\(dataPoint.val)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2)
                        }
                    }
                }
                .frame(height: 300)
                .chartBackground { _ in
                    VStack(spacing: 4) {
                        Text("\(activeCount)")
                            .font(.system(size: 48, weight: .bold))
                        Text("Active")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Legend with counts
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(dataPoints) { dataPoint in
                        HStack {
                            Circle()
                                .fill(dataPoint.color)
                                .frame(width: 12, height: 12)
                            
                            Text(dataPoint.type)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text("\(dataPoint.val)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("(\(percentage(for: dataPoint))%)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6).opacity(0.5))
                .cornerRadius(8)
                .padding(.horizontal)
            }
        }
        .padding()
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onAppear(perform: loadData)
        .onChange(of: applications.count) { _, _ in
            loadData()
        }
    }
    
    private func loadData() {
        // Count applications by status (excluding closed)
        var statusCounts: [String: Int] = [:]
        
        for app in applications where app.appStatus != "Closed" {
            let status = app.appStatus
            statusCounts[status, default: 0] += 1
        }
        
        // Convert to StatusData array and sort by count
        dataPoints = statusCounts.map { StatusData(type: $0.key, val: $0.value) }
            .sorted { $0.val > $1.val }
    }
    
    private func percentage(for dataPoint: StatusData) -> Int {
        guard activeCount > 0 else { return 0 }
        return Int(round(Double(dataPoint.val) / Double(activeCount) * 100))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Application.self, configurations: config)
    
    // Create sample data with various statuses
    let app1 = Application(position: "Job 1", appStatus: "Open")
    let app2 = Application(position: "Job 2", appStatus: "Open")
    let app3 = Application(position: "Job 3", appStatus: "Interview")
    let app4 = Application(position: "Job 4", appStatus: "Interview")
    let app5 = Application(position: "Job 5", appStatus: "Interview")
    let app6 = Application(position: "Job 6", appStatus: "Interview")
    let app7 = Application(position: "Job 7", appStatus: "Offer")
    let app8 = Application(position: "Job 8", appStatus: "On hold")
    let app9 = Application(position: "Job 9", appStatus: "Closed")
    
    container.mainContext.insert(app1)
    container.mainContext.insert(app2)
    container.mainContext.insert(app3)
    container.mainContext.insert(app4)
    container.mainContext.insert(app5)
    container.mainContext.insert(app6)
    container.mainContext.insert(app7)
    container.mainContext.insert(app8)
    container.mainContext.insert(app9)
    
    return ApplicationsByStatus()
        .modelContainer(container)
        .padding()
        .background(Color.black)
}
