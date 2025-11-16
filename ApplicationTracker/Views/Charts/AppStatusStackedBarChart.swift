//
//  AppStatusStackedBarChart.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 25/05/2024.
//

import SwiftUI
import SwiftData
import Charts

struct AppStatusStackedBarChart: View {
    @Query(sort: \Application.dateApplied, order: .reverse) var applications: [Application]
    
    @State private var dataPoints: [StatusData] = []
    private let totalApplications: Int
    
    init() {
        // We can't directly access @Query in init, so we'll calculate in onAppear
        self.totalApplications = 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text("Active Applications")
                    .font(.headline)
                Text("\(applications.filter { $0.appStatus != "Closed" }.count) active")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Stacked Bar Chart
            if dataPoints.filter({ $0.type != "Closed" }).isEmpty {
                ContentUnavailableView(
                    "No Active Applications",
                    systemImage: "chart.bar.xaxis",
                    description: Text("Add some applications to see the breakdown")
                )
                .frame(height: 200)
            } else {
                Chart(dataPoints.filter { $0.type != "Closed" }) { dataPoint in
                    BarMark(
                        x: .value("Count", dataPoint.val),
                        y: .value("Status", "Applications")
                    )
                    .foregroundStyle(dataPoint.color)
                }
                .frame(height: 80)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                    }
                }
                .chartYAxis(.hidden)
                .chartLegend(position: .bottom, spacing: 8)
                
                // Status breakdown
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(dataPoints.filter { $0.type != "Closed" }) { dataPoint in
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
        
        // Convert to StatusData array
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
    let app6 = Application(position: "Job 6", appStatus: "Interview")
    let app7 = Application(position: "Job 7", appStatus: "Offer")
    let app8 = Application(position: "Job 8", appStatus: "Closed")
    
    container.mainContext.insert(app1)
    container.mainContext.insert(app2)
    container.mainContext.insert(app3)
    container.mainContext.insert(app4)
    container.mainContext.insert(app5)
    container.mainContext.insert(app6)
    container.mainContext.insert(app7)
    container.mainContext.insert(app8)
    
    return AppStatusStackedBarChart()
        .modelContainer(container)
        .padding()
        .background(Color.black)
}
