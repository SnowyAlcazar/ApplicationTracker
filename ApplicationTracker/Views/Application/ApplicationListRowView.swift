//
//  ApplicationListRowView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//

import SwiftUI
import SwiftData

struct ApplicationListRowView: View {
    @Environment(\.modelContext) var modelContext
    var application: Application
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        if application.status?.name == "Closed" {
                            Text("Application CLOSED")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .fontWeight(.bold)
                        }
                        HStack {
                            Text(application.position)
                                .multilineTextAlignment(.leading)
                                .font(.subheadline)
                            Spacer()
                            if application.status?.name == "Open" || application.status?.name == "Interview" {
                                Text("Elapsed Days")
                                ZStack {
                                    Circle().frame(width: 25, height: 25)
                                        .foregroundColor(getElapsedDaysColor()).opacity(0.5)
                                    Text("\(calculateElapsedDays())")
                                        .foregroundStyle(.primary)
                                        .fontWeight(.bold)
                                }
                                .padding(.trailing, -10)
                            }
                        }
                        HStack {
                            Text("Date applied")
                            Spacer()
                            Text(application.dateApplied.formatted(date: .long, time: .omitted))
                        }
                        LabeledContent("Agent", value: (application.agent?.name ?? "No agent selected"))
                        LabeledContent("Agency", value: (application.agency?.name ?? "No agent selected"))
                        LabeledContent("Client", value: (application.client?.name ?? "No client selected"))
                        LabeledContent("Application status", value: (application.appStatus))

                        if application.appStatus == "Open" {
                            ProgressView(value: 0.333)
                                .tint(getStatusColor())
                        } else if application.appStatus == "Interview" {
                            ProgressView(value: 0.666)
                                .tint(getStatusColor())
                        } else if application.appStatus == "On hold" {
                            ProgressView(value: 0.333)
                                .tint(getStatusColor())
                        } else if application.appStatus == "Offer" {
                            ProgressView(value: 0.85)
                                .tint(getStatusColor())
                        } else if application.appStatus == "Accepted" {
                            ProgressView(value: 1.0)
                                .tint(getStatusColor())
                        }
                    }
                }
            }
            .padding([.leading, .trailing])
            .foregroundStyle(application.status?.name == "Closed" ? .secondary : .primary)
            .background(application.status?.name == "Closed" ? .gray.opacity(0.2) : .yellow.opacity(0.08))
        }
        .font(.caption)
    }
    private func calculateElapsedDays() -> Int {
        let calendar = Calendar.current
        let diffs = calendar.dateComponents([.day], from: application.dateApplied.startOfDay, to: .now.endOfDay)
        return diffs.day!
    }
    private func getElapsedDaysColor() -> Color {
        switch calculateElapsedDays() {
        case 1...9: return Color.yellow
        case 10...19: return Color.orange
        case 20...60: return Color.red
        default: return Color.blue
        }
    }
    private func getStatusColor() -> Color {
        switch application.appStatus {
        case "Open": return Color.green
        case "Interview": return Color.orange
        case "On hold": return Color.red
        case "Offer": return Color.pink
        case "Accepted": return Color.purple
        default: return Color.blue
        }
    }
}

