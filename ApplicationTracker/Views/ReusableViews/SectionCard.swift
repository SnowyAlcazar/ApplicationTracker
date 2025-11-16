//
//  SectionCard.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/11/2025.
//

import SwiftUI

struct SectionCard<Content: View>: View {
    let title: String
    let icon: String?
    let content: Content
    
    init(
        title: String,
        icon: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .textCase(.uppercase)
            }
            
            // Section content
            content
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Detail Row Component

struct DetailRow: View {
    let label: String
    let value: String
    let icon: String?
    
    init(label: String, value: String, icon: String? = nil) {
        self.label = label
        self.value = value
        self.icon = icon
    }
    
    var body: some View {
        HStack(alignment: .top) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.blue.opacity(0.8))
                    .frame(width: 20)
            }
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.blue.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}

// MARK: - Previews

#Preview("Section Card") {
    VStack(spacing: 16) {
        SectionCard(title: "Job Details", icon: "briefcase") {
            VStack(spacing: 12) {
                DetailRow(label: "Position", value: "Contract PM")
                DetailRow(label: "Company", value: "ECMS Consultancy")
                DetailRow(label: "Sector", value: "Insurance")
            }
        }
        
        SectionCard(title: "Pay & Conditions", icon: "banknote") {
            VStack(spacing: 12) {
                DetailRow(label: "Rate", value: "£650/day")
                DetailRow(label: "Days", value: "3 days/week")
                DetailRow(label: "IR35", value: "Outside")
            }
        }
    }
    .padding()
    .background(Color.black)
}
