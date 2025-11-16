//
//  EditAgentView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/02/2025.
//

import SwiftUI

struct EditAgentView: View {
    @State private var viewModel = ViewModel(draft: .default)
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack {
            List {
                EditableDetail(title: "Name", text: $viewModel.draft.name)
                EditableDetail(title: "Phone", text: $viewModel.draft.officePhone)
                EditableDetail(title: "Mobile", text: $viewModel.draft.mobilePhone)
                EditableDetail(title: "Email", text: $viewModel.draft.email)
            }
            .navigationTitle("Edit Agent")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Save") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EditAgentView()
}

