//
//  ViewModel.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/02/2025.
//

import Foundation

@Observable
class ViewModel {
    var draft: Agent
    
    var canSave: Bool {
        !draft.name.isEmpty
    }
    
    init(draft: Agent) {
        self.draft = draft
    }
}
