//
//  ChartsView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 27/05/2024.
//

import SwiftUI

struct ChartsView: View {
    
    enum ChartToDisplay: String, CaseIterable, Identifiable {
        case appByStatus
        case stackBar
        case bar
        
        var id: Self { return self }
        
        var displayName: String {
            switch self {
                case .appByStatus:
                    "By Status"
                case .stackBar:
                    "Status Barchart Stacked"
                case .bar:
                    "Status Barchart"
            }
        }
    }
    
    @State private var selectedChart = ChartToDisplay.appByStatus
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Picker("Select Chart", selection: $selectedChart.animation()) {
                    ForEach(ChartToDisplay.allCases) {
                        Text($0.displayName)
                    }
                }
                .pickerStyle(.segmented)
                
                switch selectedChart {
                case .appByStatus:
                    ApplicationsByStatus()
                case .stackBar:
                    AppStatusStackedBarChart()
                case .bar:
                    AppStatusBarChart()
                }                
            }
        }
        .navigationTitle("Job Application Analysis")
    }
}


//
//#Preview {
//    ChartsView()
//}
