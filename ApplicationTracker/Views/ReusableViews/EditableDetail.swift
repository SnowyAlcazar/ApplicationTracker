//
//  EditableDetail.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/02/2025.
//

import SwiftUI

struct EditableDetail: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.footnote)
                .bold()
            TextField("", text: $text)
        }
        .padding(.top, 8.0)
    }
}

#Preview("Editable Row") {
    @Previewable @State var name: String = Agent.default.name
    List {
        EditableDetail(title: "Name", text: $name)
    }
}
