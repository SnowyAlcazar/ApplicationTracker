//
//  AppStatusBarChart.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/05/2024.
//

import SwiftUI
import SwiftData
import Charts

struct StatusData: Identifiable {
    let id = UUID()
    let type: String
    let val: Int
    
    var color: Color {
        switch type {
        case "Open": return .green
        case "Interview": return .orange
        case "On hold": return .red
        case "Offer": return .pink
        case "Accepted": return .purple
        case "Closed": return .gray
        default: return .blue
        }
    }
}

struct AppStatusBarChart: View {
    @Query(sort: \Application.dateApplied, order: .reverse) var applications: [Application]
    
    @State private var dataPoints: [StatusData] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text("Applications by Status")
                    .font(.headline)
                Text("\(applications.count) total applications")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Chart
            if dataPoints.isEmpty {
                ContentUnavailableView(
                    "No Data",
                    systemImage: "chart.bar",
                    description: Text("Add some applications to see the chart")
                )
                .frame(height: 250)
            } else {
                Chart(dataPoints) { dataPoint in
                    BarMark(
                        x: .value("Status", dataPoint.type),
                        y: .value("Count", dataPoint.val)
                    )
                    .foregroundStyle(dataPoint.color)
                    .annotation(position: .top) {
                        Text("\(dataPoint.val)")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
                .frame(height: 250)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                            .font(.caption)
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
            }
            
            // Legend
            if !dataPoints.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(dataPoints) { dataPoint in
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(dataPoint.color)
                                    .frame(width: 8, height: 8)
                                Text(dataPoint.type)
                                    .font(.caption)
                                Text("(\(dataPoint.val))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
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
        // Count applications by status
        var statusCounts: [String: Int] = [:]
        
        for app in applications {
            let status = app.appStatus
            statusCounts[status, default: 0] += 1
        }
        
        // Convert to StatusData array and sort
        dataPoints = statusCounts.map { StatusData(type: $0.key, val: $0.value) }
            .sorted { $0.val > $1.val }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Application.self, configurations: config)
    
    // Create sample data
    let app1 = Application(position: "Job 1", appStatus: "Open")
    let app2 = Application(position: "Job 2", appStatus: "Open")
    let app3 = Application(position: "Job 3", appStatus: "Interview")
    let app4 = Application(position: "Job 4", appStatus: "Interview")
    let app5 = Application(position: "Job 5", appStatus: "Interview")
    let app6 = Application(position: "Job 6", appStatus: "Closed")
    
    container.mainContext.insert(app1)
    container.mainContext.insert(app2)
    container.mainContext.insert(app3)
    container.mainContext.insert(app4)
    container.mainContext.insert(app5)
    container.mainContext.insert(app6)
    
    return AppStatusBarChart()
        .modelContainer(container)
        .padding()
        .background(Color.black)
}

