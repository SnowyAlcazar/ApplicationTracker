//
//  SectionedQueryView.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 12/05/2024.
//

import SwiftUI
import SwiftData

struct SectionedQueryView<Content: View, Model: PersistentModel, Key: Hashable>: View {
    @Query private var query: [Model]
    private var content: ([QueryViewDataSection<Key, Model>]) -> Content
    private var keyExtractor: ((Model) -> Key)

    init(for type: Model.Type,
         sectionedBy keyExtractor: @escaping ((Model) -> Key),
         sort: [SortDescriptor<Model>] = [],
         @ViewBuilder content: @escaping ([QueryViewDataSection<Key, Model>]) -> Content,
         filter: (() -> (Predicate<Model>))? = nil) {
        _query = Query(filter: filter?(), sort: sort)
        self.content = content
        self.keyExtractor = keyExtractor
    }
    
    var body: some View {
        let data = Dictionary(grouping: query, by: keyExtractor)
        let result = keys.reduce([QueryViewDataSection]()) { partialResult, key in
            partialResult + [.init(key: key, models: data[key] ?? [])]
        }
        content(result)
    }
                                  
    private var keys: [Key] {
        var seen: Set<Key> = []
        var result: [Key] = []
        
        for model in query {
            let key = keyExtractor(model)
            if !seen.contains(key) {
                seen.insert(key)
                result.append(key)
            }
        }
        return result
    }
}

struct QueryViewDataSection<Key: Hashable, Model: PersistentModel>: Identifiable {
    let key: Key
    let models: [Model]
    let id = UUID()
}


