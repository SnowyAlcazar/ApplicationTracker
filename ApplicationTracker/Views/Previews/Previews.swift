//
//  Previews.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/11/2025.
//

import SwiftData
import Foundation

@MainActor
class PreviewContainer {
    let container: ModelContainer
    
    init(_ models: any PersistentModel.Type...) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema(models)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create preview container: \(error)")
        }
    }
    
    func addExamples(_ examples: [any PersistentModel]) {
        Task { @MainActor in
            examples.forEach { example in
                container.mainContext.insert(example)
            }
        }
    }
}
