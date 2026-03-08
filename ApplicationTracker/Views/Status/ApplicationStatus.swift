//
//  ApplicationStatus.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 08/03/2026.
//
//  Replaces the Status @Model class entirely.
//  Storing status as a fixed enum eliminates the CloudKit sync problem
//  where seeded Status records were duplicated on every fresh install.
//
//  Application.appStatus stores the rawValue String directly.
//

import SwiftUI

enum ApplicationStatus: String, CaseIterable, Identifiable {
    case open       = "Open"
    case interview  = "Interview"
    case onHold     = "On hold"
    case offer      = "Offer"
    case accepted   = "Accepted"
    case closed     = "Closed"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .open:      return .green
        case .interview: return .orange
        case .onHold:    return .red
        case .offer:     return .pink
        case .accepted:  return .purple
        case .closed:    return .gray
        }
    }

    var icon: String {
        switch self {
        case .open:      return "envelope.open.fill"
        case .interview: return "person.2.fill"
        case .onHold:    return "pause.circle.fill"
        case .offer:     return "checkmark.circle.fill"
        case .accepted:  return "star.fill"
        case .closed:    return "xmark.circle.fill"
        }
    }

    /// Convenience init from a stored String — falls back to .open for unknown values.
    init(rawString: String) {
        self = ApplicationStatus(rawValue: rawString) ?? .open
    }
}
