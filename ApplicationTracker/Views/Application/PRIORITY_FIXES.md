# Priority Fixes - Start Here Tomorrow

## 1. Missing Chart Components (CRITICAL)

### Files to Create:

#### `AppStatusStackedBarChart.swift`
```swift
//  AppStatusStackedBarChart.swift
//  ApplicationTracker
/*
import SwiftUI
import SwiftData
import Charts

struct AppStatusStackedBarChart: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Application.appStatus, order: .forward) var applications: [Application]
    @Query(sort: \Status.name, order: .reverse) var statuses: [Status]
    
    @State private var dataPoints: [StatusData] = []
    
    var body: some View {
        VStack {
            Chart {
                ForEach(dataPoints, id: \.id) { dataPoint in
                    BarMark(
                        x: .value("Count", dataPoint.val),
                        y: .value("Status", dataPoint.type)
                    )
                    .foregroundStyle(by: .value("Status", dataPoint.type))
                }
            }
            .frame(height: 300)
            .chartBackground { proxy in
                Text("Applications by Status")
                    .font(.headline)
            }
        }
        .onAppear(perform: loadData)
        .padding()
    }
    
    func loadData() {
        dataPoints = []
        for status in statuses {
            let count = applications.filter { $0.appStatus == status.name }.count
            if count > 0 {
                dataPoints.append(StatusData(type: status.name, val: count))
            }
        }
    }
}

#Preview {
    AppStatusStackedBarChart()
}
```

#### `AppStatusBarChart.swift`
```swift
//  AppStatusBarChart.swift
//  ApplicationTracker

import SwiftUI
import SwiftData
import Charts

struct AppStatusBarChart: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Application.appStatus, order: .forward) var applications: [Application]
    @Query(sort: \Status.name, order: .reverse) var statuses: [Status]
    
    @State private var dataPoints: [StatusData] = []
    
    var body: some View {
        VStack {
            Chart {
                ForEach(dataPoints, id: \.id) { dataPoint in
                    BarMark(
                        x: .value("Status", dataPoint.type),
                        y: .value("Count", dataPoint.val)
                    )
                    .foregroundStyle(by: .value("Status", dataPoint.type))
                    .annotation(position: .top) {
                        Text("\(dataPoint.val)")
                            .font(.caption)
                    }
                }
            }
            .frame(height: 300)
            .chartBackground { proxy in
                Text("Application Status Overview")
                    .font(.headline)
            }
        }
        .onAppear(perform: loadData)
        .padding()
    }
    
    func loadData() {
        dataPoints = []
        for status in statuses {
            let count = applications.filter { $0.appStatus == status.name }.count
            if count > 0 {
                dataPoints.append(StatusData(type: status.name, val: count))
            }
        }
    }
}

#Preview {
    AppStatusBarChart()
}
```

## 2. Create Sample Data (CRITICAL)

### Add to `Application.swift` (at the end of the file):
```swift
// MARK: - Sample Data
extension Application {
    static let sampleApps: [Application] = [
        Application(
            position: "Senior iOS Developer",
            businessSector: "Technology",
            positionType: "Software Engineer",
            remunerationType: "Annual",
            remunerationAmount: 85000,
            employmentType: "Permanent",
            iR35: "N/A",
            positionCommitment: "Full-time",
            workstyle: "Hybrid",
            officeDays: "3",
            whereAdvertised: "LinkedIn",
            dateApplied: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            requiredSkills: "Swift, SwiftUI, UIKit, Core Data",
            notes: "Great company culture, exciting product",
            appStatus: "Interview"
        ),
        Application(
            position: "Mobile App Developer",
            businessSector: "Finance",
            positionType: "Developer",
            remunerationType: "Daily",
            remunerationAmount: 450,
            employmentType: "Contract",
            iR35: "Outside",
            positionCommitment: "Full-time",
            workstyle: "Remote",
            officeDays: "0",
            whereAdvertised: "JobServe",
            dateApplied: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
            requiredSkills: "Swift, iOS SDK, REST APIs",
            notes: "6 month initial contract with extension possibility",
            appStatus: "Open"
        ),
        Application(
            position: "Lead Developer",
            businessSector: "Healthcare",
            positionType: "Team Lead",
            remunerationType: "Annual",
            remunerationAmount: 95000,
            employmentType: "Permanent",
            iR35: "N/A",
            positionCommitment: "Full-time",
            workstyle: "Office",
            officeDays: "5",
            whereAdvertised: "Company Website",
            dateApplied: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            requiredSkills: "iOS, Team Leadership, Agile, SwiftUI",
            notes: "Leading a team of 4 developers on health tech app",
            appStatus: "Offer"
        )
    ]
}
```

## 3. Create Preview Helper (CRITICAL)  DONE



## 4. Fix All Preview Blocks

### Priority Order:
1. **ApplicationDetailView.swift** (your current file)
2. **ApplicationList.swift**
3. **FilteredApplicationList.swift**
4. **ChartsView.swift**
5. **ApplicationsByStatus.swift**

### Fixed Preview for ApplicationDetailView.swift:
```swift
#Preview {
    let preview = Preview(Application.self)
    preview.addExamples(Application.sampleApps)
    return NavigationStack {
        ApplicationDetailView(application: Application.sampleApps[0])
            .modelContainer(preview.container)
    }
}
```

## Tomorrow's Action Plan:

1. **Create the missing chart files** (30 minutes)
   - AppStatusStackedBarChart.swift
   - AppStatusBarChart.swift

2. **Add sample data to Application.swift** (15 minutes)
   - Extend Application with sampleApps

3. **Create Preview.swift helper** (10 minutes)
   - New file for preview container management

4. **Fix preview in ApplicationDetailView.swift** (5 minutes)
   - Uncomment and update the preview block

5. **Test the charts work** (15 minutes)
   - Run the app and verify charts display
   - Check that preview works

**Total estimated time: 75 minutes**

After these fixes, the app will be much more stable for development and you'll have working previews for faster iteration.

## Next Session Goals:
- Complete the remaining preview fixes in other files
- Add sample data for other models (Agent, Agency, Client, Status)
- Test all navigation flows work correctly
- Begin empty state implementations

This will give us a solid foundation to build the rest of the MVP features on!
*/
