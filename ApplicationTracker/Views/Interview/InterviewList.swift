//
//  InterviewList.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 18/04/2024.
//

import SwiftUI
import SwiftData

struct InterviewList: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedInterview: String = ""
    
    @Query(sort: \Interview.interviewDate) private var interviews: [Interview]
    
    @State private var newInterview: Interview?
    
    var body: some View {
        NavigationSplitView {
            Group {
                if !interviews.isEmpty {
                    List {
                        ForEach(interviews) { interview in
                            NavigationLink {
                                InterviewDetailView(interview: interview)
                                    .navigationTitle("Interviews")
                            } label: {
                                VStack {
                                    Text(interview.name)
                                    Text(interview.interviewDate, style: .date)
                                }
                            }
                        }
                        .onDelete(perform: deleteInterviews)
                    }
                } else {
                    ContentUnavailableView {
                        Label("No interviews", systemImage: "person.and.person")
                    }
                }
            }
            .navigationTitle("Interviews")
        } detail: {
            Text("Select an interview")
                .navigationTitle("Interview")
        }
    }
    
//    private func addInterview() {
//        withAnimation {
//            let newItem = Interview(interviewDate: Date.now, application: Application)
//            modelContext.insert(newItem)
//            newInterview = newItem
//        }
//    }
    private func deleteInterviews(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(interviews[index])
            }
        }
    }
}

#Preview {
    let preview = Preview(Interview.self)
    preview.addExamples(Interview.sampleInterviews)
    return NavigationStack {
        InterviewList()
            .modelContainer(preview.container)
    }
}
