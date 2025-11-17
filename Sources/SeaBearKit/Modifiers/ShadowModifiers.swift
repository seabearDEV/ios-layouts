//
//  ShadowModifiers.swift
//  SeaBearKit
//
//  Unified shadow system for Liquid Glass UI components.
//

import SwiftUI

/// Shadow intensity presets for consistent depth across UI elements.
///
/// Each intensity level provides coordinated shadow parameters for both
/// resting (unpressed) and pressed states, creating consistent elevation
/// throughout your interface.
public enum ShadowIntensity {
    /// Subtle shadow for elements that should appear slightly elevated
    case subtle

    /// Regular shadow for standard interactive elements (default)
    case regular

    /// Prominent shadow for primary actions and important elements
    case prominent

    /// Shadow parameters for unpressed state: (opacity, radius, yOffset)
    var unpressed: (opacity: Double, radius: CGFloat, y: CGFloat) {
        switch self {
        case .subtle:
            return (0.15, 3, 2)
        case .regular:
            return (0.25, 5, 3)
        case .prominent:
            return (0.35, 8, 5)
        }
    }

    /// Shadow parameters for pressed state: (opacity, radius, yOffset)
    var pressed: (opacity: Double, radius: CGFloat, y: CGFloat) {
        switch self {
        case .subtle:
            return (0.08, 1, 0.5)
        case .regular:
            return (0.1, 2, 1)
        case .prominent:
            return (0.15, 3, 2)
        }
    }
}

extension View {
    /// Applies a consistent shadow optimized for Liquid Glass design.
    ///
    /// This modifier provides a unified shadow system that adapts to press states,
    /// creating consistent elevation and depth across your interface. The shadow
    /// parameters follow iOS design guidelines and complement glass effects.
    ///
    /// ## Usage
    ///
    /// **Basic shadow (unpressed state):**
    /// ```swift
    /// Button("Action") { }
    ///     .buttonStyle(.borderedProminent)
    ///     .glassShadow()
    /// ```
    ///
    /// **Interactive shadow with press state:**
    /// ```swift
    /// struct GlassButton: View {
    ///     @State private var isPressed = false
    ///
    ///     var body: some View {
    ///         Text("Press Me")
    ///             .padding()
    ///             .background(.regularMaterial)
    ///             .glassShadow(isPressed: isPressed, intensity: .regular)
    ///             .scaleEffect(isPressed ? 0.97 : 1.0)
    ///             .onLongPressGesture(minimumDuration: .infinity) { } onPressingChanged: { pressing in
    ///                 isPressed = pressing
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// **Different intensities:**
    /// ```swift
    /// // Subtle shadow for secondary elements
    /// Text("Secondary")
    ///     .glassShadow(intensity: .subtle)
    ///
    /// // Prominent shadow for primary actions
    /// Button("Primary") { }
    ///     .glassShadow(intensity: .prominent)
    /// ```
    ///
    /// ## Press State Integration
    ///
    /// When `isPressed` is true, the shadow automatically reduces in opacity and
    /// radius, creating the visual effect of the element being pushed closer to
    /// the surface. This pairs well with scale effects:
    ///
    /// ```swift
    /// .glassShadow(isPressed: isPressed)
    /// .scaleEffect(isPressed ? 0.97 : 1.0)
    /// .animation(.easeInOut(duration: 0.15), value: isPressed)
    /// ```
    ///
    /// ## Design Notes
    ///
    /// - Shadows use black color for universal compatibility
    /// - Y-offset creates natural light-from-above depth perception
    /// - Parameters are optimized for Liquid Glass materials
    /// - Press state simulates surface proximity
    ///
    /// - Parameters:
    ///   - isPressed: Whether the element is in a pressed state
    ///   - intensity: The shadow intensity level (default: .regular)
    /// - Returns: A view with the appropriate shadow applied
    ///
    public func glassShadow(
        isPressed: Bool = false,
        intensity: ShadowIntensity = .regular
    ) -> some View {
        let params = isPressed ? intensity.pressed : intensity.unpressed
        return self.shadow(
            color: .black.opacity(params.opacity),
            radius: params.radius,
            x: 0,
            y: params.y
        )
    }

    /// Applies a custom glass shadow with explicit parameters.
    ///
    /// Use this variant when you need fine-grained control over shadow appearance
    /// while maintaining the glass shadow signature (black color, y-offset).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// Text("Custom")
    ///     .glassShadow(opacity: 0.3, radius: 6, yOffset: 4)
    /// ```
    ///
    /// - Parameters:
    ///   - opacity: Shadow opacity (0.0 to 1.0)
    ///   - radius: Shadow blur radius
    ///   - yOffset: Vertical offset (positive = down)
    /// - Returns: A view with the custom shadow applied
    ///
    public func glassShadow(
        opacity: Double,
        radius: CGFloat,
        yOffset: CGFloat
    ) -> some View {
        self.shadow(
            color: .black.opacity(opacity),
            radius: radius,
            x: 0,
            y: yOffset
        )
    }
}

// MARK: - Preview

#Preview("Shadow Intensities") {
    VStack(spacing: 30) {
        Text("Shadow Intensities")
            .font(.title)
            .bold()
            .padding(.bottom, 10)

        VStack(spacing: 20) {
            ShadowPreviewItem(intensity: .subtle, label: "Subtle")
            ShadowPreviewItem(intensity: .regular, label: "Regular")
            ShadowPreviewItem(intensity: .prominent, label: "Prominent")
        }

        Text("Shadows adapt to press state automatically")
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.top, 10)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(white: 0.95))
}

#Preview("Press State Demo") {
    InteractiveShadowDemo()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.95))
}

private struct ShadowPreviewItem: View {
    let intensity: ShadowIntensity
    let label: String
    @State private var isPressed = false

    var body: some View {
        HStack(spacing: 15) {
            // Unpressed state
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .frame(width: 100, height: 60)
                    .glassShadow(isPressed: false, intensity: intensity)

                Text("Unpressed")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            // Pressed state
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .frame(width: 100, height: 60)
                    .glassShadow(isPressed: true, intensity: intensity)
                    .scaleEffect(0.97)

                Text("Pressed")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal)
    }
}

private struct InteractiveShadowDemo: View {
    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Interactive Shadow")
                .font(.title)
                .bold()

            Text("Press and hold the button")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .overlay(
                    VStack {
                        Image(systemName: isPressed ? "hand.tap.fill" : "hand.tap")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                        Text(isPressed ? "Pressed" : "Tap Me")
                            .font(.headline)
                    }
                )
                .frame(width: 200, height: 120)
                .glassShadow(isPressed: isPressed, intensity: .regular)
                .scaleEffect(isPressed ? 0.97 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: isPressed)
                .onLongPressGesture(minimumDuration: .infinity) {
                    // Action on release
                } onPressingChanged: { pressing in
                    isPressed = pressing
                }
        }
        .padding()
    }
}
