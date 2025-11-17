//
//  ConditionalModifiers.swift
//  SeaBearKit
//
//  Conditional view modifier utilities for cleaner SwiftUI code.
//

import SwiftUI

extension View {
    /// Conditionally applies a modifier based on a boolean condition.
    ///
    /// This modifier allows you to apply transformations based on conditions without
    /// duplicating view code, resulting in cleaner and more maintainable SwiftUI views.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// Text("Hello")
    ///     .if(isHighlighted) { view in
    ///         view.foregroundStyle(.red)
    ///     }
    ///     .if(colorScheme == .dark) { view in
    ///         view.background(.black)
    ///     }
    /// ```
    ///
    /// ## Common Patterns
    ///
    /// **Conditional styling based on state:**
    /// ```swift
    /// Button("Submit")
    ///     .if(isEnabled) { view in
    ///         view.buttonStyle(.borderedProminent)
    ///     }
    /// ```
    ///
    /// **Color scheme adaptations:**
    /// ```swift
    /// Image(systemName: "star")
    ///     .if(colorScheme == .dark) { view in
    ///         view.shadow(color: .white.opacity(0.5), radius: 10)
    ///     }
    /// ```
    ///
    /// **Platform-specific modifications:**
    /// ```swift
    /// #if os(iOS)
    /// content.if(UIDevice.current.userInterfaceIdiom == .pad) { view in
    ///     view.padding(.horizontal, 100)
    /// }
    /// #endif
    /// ```
    ///
    /// - Parameters:
    ///   - condition: A boolean value determining whether to apply the transform
    ///   - transform: A closure that transforms the view when condition is true
    /// - Returns: Either the transformed view or the original view
    ///
    @ViewBuilder
    public func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Conditionally applies one of two different modifiers based on a boolean condition.
    ///
    /// This variant allows you to provide both a "then" and "else" transformation,
    /// useful when you need to apply different styles in both cases.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// Text("Status")
    ///     .if(isActive,
    ///         then: { $0.foregroundStyle(.green) },
    ///         else: { $0.foregroundStyle(.gray) }
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - condition: A boolean value determining which transform to apply
    ///   - then: A closure that transforms the view when condition is true
    ///   - else: A closure that transforms the view when condition is false
    /// - Returns: The transformed view
    ///
    @ViewBuilder
    public func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        then trueTransform: (Self) -> TrueContent,
        else falseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            trueTransform(self)
        } else {
            falseTransform(self)
        }
    }
}
