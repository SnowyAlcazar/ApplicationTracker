//
//  AppStatusStackedBarChart.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 25/05/2024.
//

import SwiftUI
import SwiftData
import Charts

//class Data: Identifiable {
//    let type: String
//    let val: Int
//    
//    var id: String { type }
//
//    init(type: String = "", val: Int = 0) {
//        self.type = type
//        self.val = val
//    }
//}

struct AppStatusStackedBarChart: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Application.appStatus, order: .forward) var applications: [Application]
    @Query(sort: \Status.name, order: .reverse) var statuses: [Status]
    
    @State private var dataPoints: [StatusData] = []
    @State private var uniqueStatusList: [String] = []
    
    var body: some View {
        VStack {
            Chart {
                ForEach(dataPoints, id: \.id) { dataPoint in

                    /// Barchart
//                    BarMark(
//                        x: .value("Counts", dataPoint.val),
//                        y: .value("Types", dataPoint.type)
//                    )
                    ///Statcked barchart
                    BarMark(
                        x: .value("Counts", dataPoint.val)
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
            .frame(height: 100)
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
            var statusCount = 0
//            if status.name == "Open" || status.name == "On hold" || status == "Interview" || status == "Offer" || status == "Accepted" {
//            if status.name != "Closed" {
                for app in applications {
                    if app.appStatus == status.name {
                        statusCount += 1
                    }
                }
                if statusCount > 0 {
                    dataPoints.append(StatusData (type: status.name, val: statusCount))
                }
//            }
        }
    }
    
    //    private func calculateElapsedDays() -> Int {
    //        let calendar = Calendar.current
    //        let diffs = calendar.dateComponents([.day], from: application.dateApplied.startOfDay, to: .now.endOfDay)
    //        return diffs.day!
    //    }
}

//#Preview {
//    AppAnalysis()
//}
