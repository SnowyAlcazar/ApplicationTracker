//
//  StatusDetail.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 16/05/2024.
//

import SwiftUI

struct StatusDetail: View {
    enum FocusedField {
        case name
    }
    @Bindable var status: Status
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    init(status: Status, isNew: Bool = false) {
        self.status = status
        self.isNew = isNew
    }
     @State private var name = ""
     @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        Form {
            if isNew {
                TextField("Status", text: $status.name)
                    .focused($focusedField, equals: .name)
                    .autocorrectionDisabled()
            } else {
                TextField("Status", text: $status.name)
                    .autocorrectionDisabled()
            }

        }
        .onAppear {
            focusedField = .name
        }
        .navigationTitle(isNew ? "New Status" : "Status")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        modelContext.delete(status)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
let preview = Preview(Status.self)
    return NavigationStack {
        StatusDetail(status: Status.sampleStatuses[0])
            .modelContainer(preview.container)
    }
}

