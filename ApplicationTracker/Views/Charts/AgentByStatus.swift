//
//  AgentByStatus.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 30/05/2024.
//

import SwiftUI
import SwiftData
import Charts

struct AgentByStatus: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Application.appStatus, order: .forward) var applications: [Application]
    @Query(sort: \Status.name, order: .reverse) var statuses: [Status]
    @Query(sort: \Agent.name, order: .forward) var agents: [Agent]
    
    @State private var dataPoints: [StatusData] = []
    
    var body: some View {
        VStack {
            Chart {
                ForEach(dataPoints, id: \.id) { dataPoint in
                    /// Barchart
                    BarMark(
                        x: .value("Counts", dataPoint.val),
                        y: .value("Types", dataPoint.type)
                    )
                    .foregroundStyle(by: .value("Type", dataPoint.type))
                    .cornerRadius(5.0)
                    .annotation(position: .overlay) {
                        Text("\(dataPoint.val)")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                }
            }
            .frame(height: 500)
        }
        .onAppear(perform: loadData)
        .onDisappear(perform: clearOutData)
        .padding()
    }

    func loadData() {
        populateDataPoints(type: "", val: 0)
    }
    func clearOutData() {
        dataPoints = []
    }
       
    func populateDataPoints(type: String, val: Int) {
        for status in statuses {
            var count = 0
            if status.name != "Closed" {
                for app in applications {
                    if app.appStatus == status.name {
                        count += 1
                    }
                }
                if count > 0 {
                    dataPoints.append(StatusData (type: status.name, val: count))
                }
            }
        }
    }
    
    //    private func calculateElapsedDays() -> Int {
    //        let calendar = Calendar.current
    //        let diffs = calendar.dateComponents([.day], from: application.dateApplied.startOfDay, to: .now.endOfDay)
    //        return diffs.day!
    //    }
}
