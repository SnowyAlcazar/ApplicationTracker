//
//  StatusBadge.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/11/2025.
//

import SwiftUI

struct StatusBadge: View {
    let status: String
    let size: BadgeSize
    
    enum BadgeSize {
        case small
        case medium
        case large
        
        var font: Font {
            switch self {
            case .small: return .caption2
            case .medium: return .caption
            case .large: return .subheadline
            }
        }
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .medium: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            case .large: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            }
        }
        
        var iconSize: Font {
            switch self {
            case .small: return .caption2
            case .medium: return .caption
            case .large: return .body
            }
        }
    }
    
    init(status: String, size: BadgeSize = .medium) {
        self.status = status
        self.size = size
    }
    
    // MARK: - Status Configuration
    
    private var statusColor: Color {
        switch status.lowercased() {
        case "open":
            return .blue
        case "interview", "interviewing":
            return .green
        case "closed", "rejected":
            return .orange
        case "offer", "offered":
            return .purple
        case "withdrawn":
            return .red
        case "on hold":
            return .yellow
        default:
            return .gray
        }
    }
    
    private var statusIcon: String {
        switch status.lowercased() {
        case "open":
            return "envelope.open.fill"
        case "interview", "interviewing":
            return "person.2.fill"
        case "closed", "rejected":
            return "xmark.circle.fill"
        case "offer", "offered":
            return "checkmark.circle.fill"
        case "withdrawn":
            return "arrow.uturn.backward.circle.fill"
        case "on hold":
            return "pause.circle.fill"
        default:
            return "circle.fill"
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: statusIcon)
                .font(size.iconSize)
            Text(status)
                .font(size.font)
                .fontWeight(.medium)
        }
        .padding(size.padding)
        .background(statusColor.opacity(0.15))
        .foregroundColor(statusColor)
        .cornerRadius(12)
    }
}

// MARK: - Previews

#Preview {
    VStack(spacing: 16) {
        Text("Small Size")
            .font(.caption)
            .foregroundColor(.secondary)
        HStack(spacing: 8) {
            StatusBadge(status: "Open", size: .small)
            StatusBadge(status: "Interview", size: .small)
            StatusBadge(status: "Closed", size: .small)
        }
        
        Divider()
        
        Text("Medium Size (Default)")
            .font(.caption)
            .foregroundColor(.secondary)
        HStack(spacing: 8) {
            StatusBadge(status: "Open")
            StatusBadge(status: "Interview")
            StatusBadge(status: "Offer")
        }
        
        Divider()
        
        Text("Large Size")
            .font(.caption)
            .foregroundColor(.secondary)
        VStack(spacing: 8) {
            StatusBadge(status: "Open", size: .large)
            StatusBadge(status: "Interview", size: .large)
            StatusBadge(status: "Rejected", size: .large)
            StatusBadge(status: "Withdrawn", size: .large)
        }
    }
    .padding()
    .background(Color.black)
}
