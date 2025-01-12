//
//  ApplicationsByStatus.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 21/05/2024.
//

import SwiftUI
import SwiftData
import Charts

class StatusData: Identifiable {
    let type: String
    let val: Int
    
    var id: String { type }

    init(type: String = "", val: Int = 0) {
        self.type = type
        self.val = val
    }
}

struct ApplicationsByStatus: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Application.appStatus, order: .forward) var applications: [Application]
    @Query(sort: \Status.name, order: .reverse) var statuses: [Status]
    
    @State private var dataPoints: [StatusData] = []
    @State private var uniqueStatusList: [String] = []
    
    var body: some View {
        VStack {
            Chart {
                ForEach(dataPoints, id: \.id) { dataPoint in
                    ///Pie chart
                    SectorMark(
                        angle: .value("Status", dataPoint.val),
                        innerRadius: .ratio(0.6),
                        angularInset: 1.5
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
            .chartBackground { proxy in
                Text("Active applications")
                    .font(.headline)
                
            }
//            .chartForegroundStyleScale(
//                [
//                    "Open": .yellow,
//                    "On hold": .blue,
//                    "Interview": .pink,
//                    "Closed": .gray,
//                    "Offer": .purple,
//                    "Accepted": .green
//                ]
//            )
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
            if status.name != "Closed" {
                for app in applications {
                    if app.appStatus == status.name {
                        statusCount += 1
                    }
                }
                if statusCount > 0 {
                    dataPoints.append(StatusData (type: status.name, val: statusCount))
                }
            }
        }
    }
}

//#Preview {
//    ApplicationsByStatus()
//}
