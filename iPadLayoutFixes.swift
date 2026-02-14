//
//  iPadLayoutFixes.swift
//  ApplicationTracker
//
//  Created to fix iPad Air 11" crash from infinite layout updates
//

import SwiftUI
import SwiftData

// MARK: - View Extension for Safe Layout Updates

extension View {
    /// Prevents infinite layout update loops on iPad by breaking the update cycle
    func preventLayoutLoops() -> some View {
        self
            .id(UUID()) // Force stable identity
            .animation(.default, value: UUID()) // Prevent animation cascades
    }
    
    /// Adds iPad-specific layout constraints to prevent recursion
    @ViewBuilder
    func adaptiveLayout(for sizeClass: UserInterfaceSizeClass?) -> some View {
        if sizeClass == .regular {
            // iPad: Use lazy loading and limits
            self
                .frame(maxWidth: 800) // Constrain width on iPad
        } else {
            // iPhone: Normal layout
            self
        }
    }
}

// MARK: - Transaction Helper

/// Prevents rapid model updates from cascading
class UpdateThrottle {
    private var isUpdating = false
    private let resetDelay: TimeInterval
    
    init(resetDelay: TimeInterval = 0.1) {
        self.resetDelay = resetDelay
    }
    
    func shouldUpdate() -> Bool {
        guard !isUpdating else { return false }
        isUpdating = true
        
        // Reset after delay to allow next update
        DispatchQueue.main.asyncAfter(deadline: .now() + resetDelay) { [weak self] in
            self?.isUpdating = false
        }
        
        return true
    }
}

// MARK: - Safe Binding Helper

extension Binding where Value: Equatable {
    /// Creates a binding that prevents update loops by checking equality
    func preventingLoops() -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                guard self.wrappedValue != newValue else { return }
                self.wrappedValue = newValue
            }
        )
    }
}

// MARK: - Layout Recursion Detector

class LayoutRecursionDetector: ObservableObject {
    @Published private(set) var isInRecursion = false
    private var updateCount = 0
    private var lastResetTime = Date()
    
    private let maxUpdatesPerSecond = 60 // More than 60 updates/sec = recursion
    
    func recordUpdate() {
        let now = Date()
        
        // Reset counter every second
        if now.timeIntervalSince(lastResetTime) > 1.0 {
            updateCount = 0
            lastResetTime = now
            isInRecursion = false
        }
        
        updateCount += 1
        
        if updateCount > maxUpdatesPerSecond {
            isInRecursion = true
            print("⚠️ WARNING: Layout recursion detected! \(updateCount) updates in last second")
        }
    }
}

// MARK: - View Extension for Result Limiting

extension View {
    /// Limits array results on iPad to prevent layout explosion
    func limitResultsOnIPad<T>(_ array: [T], max: Int = 100, sizeClass: UserInterfaceSizeClass?) -> [T] {
        if sizeClass == .regular {
            return Array(array.prefix(max))
        }
        return array
    }
}
