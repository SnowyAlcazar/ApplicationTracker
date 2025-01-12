//
//  InterviewDetailView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 18/04/2024.
//

import SwiftUI

struct InterviewDetailView: View {
    enum FocusedField {
        case name
    }
    @Bindable var interview: Interview
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    init(interview: Interview, isNew: Bool = false) {
        self.interview = interview
        self.isNew = isNew
    }
    @State private var name = ""
    @FocusState private var focusedField: FocusedField?


    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading) {
                    Section {
                        if isNew {
                            Text("Interview")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            TextField("Add an identifier for your interview", text: $interview.name)
                                .focused($focusedField, equals: .name)
                                .autocorrectionDisabled()
                        } else {
                            Text("Interview")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            TextField("Title", text: $interview.name)
                                .autocorrectionDisabled()
                        }

                        Text("Interview date with start and end times")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        HStack {
                            DatePicker("Interview Date", selection: $interview.interviewDate, displayedComponents: .date)
                                .labelsHidden()
                            Text("")
                            DatePicker("Start", selection: $interview.startTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                            Text("to")
                            DatePicker("End", selection: $interview.endTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        .padding(.bottom)
                        
                        Text("Interview location?")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        TextField("Type the location of your interview here...", text: $interview.location)
                            .padding(.bottom)

                        Text("Who are you meeting?")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        TextField("Add the names of your interviewer(s) here...", text: $interview.interviewer)
                            .autocorrectionDisabled()
                            .padding(.bottom)
                    }
                    Section("Follow-up") {
                        Text("Result / Feedback from the interview")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        TextField("Type here...", text: $interview.result, axis: .vertical)
                        
                        Text("Notes")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        TextField("Type here...", text: $interview.notes, axis: .vertical)
                    }
                }
            }
        }
        .onAppear {
            focusedField = .name
        }
        .navigationTitle(isNew ? "New interview" : "Interview")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        modelContext.delete(interview)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
let preview = Preview(Interview.self)
    return NavigationStack {
        InterviewDetailView(interview: Interview.sampleInterviews[1])
            .modelContainer(preview.container)
    }
}
