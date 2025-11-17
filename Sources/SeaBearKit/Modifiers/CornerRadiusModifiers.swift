//
//  CornerRadiusModifiers.swift
//  SeaBearKit
//
//  Proportional corner radius system for device-independent UI consistency.
//

import SwiftUI

/// Predefined corner radius styles as percentage values.
///
/// These presets provide semantic corner radius values that work proportionally
/// across different UI element sizes and device screen sizes.
public struct CornerRadiusStyle {
    /// No corner radius - perfect squares
    public static let square: Double = 0.0

    /// Slight rounding - subtle corners
    public static let slight: Double = 15.0

    /// Moderate rounding - balanced appearance
    public static let moderate: Double = 40.0

    /// Round corners - prominent curvature
    public static let round: Double = 65.0

    /// Maximum rounding - perfect circles when applied to square elements
    public static let circle: Double = 100.0
}

extension View {
    /// Applies a proportional corner radius based on percentage and element size.
    ///
    /// This modifier calculates corner radius as a percentage of the element's size,
    /// ensuring consistent visual appearance across different screen sizes and element dimensions.
    /// At 0%, elements are perfect squares. At 100%, square elements become perfect circles.
    ///
    /// ## How It Works
    ///
    /// The corner radius is calculated as:
    /// ```
    /// radius = (size / 2) * (percent / 100)
    /// ```
    ///
    /// For a 100pt square element:
    /// - 0% = 0pt radius (square)
    /// - 50% = 25pt radius (rounded square)
    /// - 100% = 50pt radius (circle)
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Using percentage values
    /// RoundedRectangle(cornerRadius: 0)
    ///     .fill(.blue)
    ///     .frame(width: 100, height: 100)
    ///     .adaptiveCornerRadius(40, size: CGSize(width: 100, height: 100))
    ///
    /// // Using predefined styles
    /// RoundedRectangle(cornerRadius: 0)
    ///     .fill(.red)
    ///     .frame(width: 50, height: 50)
    ///     .adaptiveCornerRadius(CornerRadiusStyle.round, size: CGSize(width: 50, height: 50))
    /// ```
    ///
    /// ## With Padding
    ///
    /// When elements have padding that reduces their visual size:
    ///
    /// ```swift
    /// let totalSize: CGFloat = 100  // Frame size
    /// let padding: CGFloat = 8      // Internal padding
    /// let visualSize = totalSize - padding
    ///
    /// RoundedRectangle(cornerRadius: 0)
    ///     .adaptiveCornerRadius(50, size: CGSize(width: visualSize, height: visualSize))
    ///     .padding(padding / 2)
    ///     .frame(width: totalSize, height: totalSize)
    /// ```
    ///
    /// - Parameters:
    ///   - percent: Corner radius as percentage of element size (0-100)
    ///   - size: The size of the element (uses smaller dimension for calculation)
    /// - Returns: A view with the calculated corner radius applied
    ///
    public func adaptiveCornerRadius(_ percent: Double, size: CGSize) -> some View {
        let radius = Self.calculateCornerRadius(percent: percent, size: size)
        return self.clipShape(RoundedRectangle(cornerRadius: radius))
    }

    /// Calculates proportional corner radius based on percentage and size.
    ///
    /// This is a helper function that can be used independently when you need the
    /// calculated radius value without applying it as a modifier.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let size = CGSize(width: 100, height: 100)
    /// let radius = View.calculateCornerRadius(percent: 50, size: size)
    /// // radius = 25.0
    ///
    /// RoundedRectangle(cornerRadius: radius)
    ///     .fill(.blue)
    ///     .frame(width: size.width, height: size.height)
    /// ```
    ///
    /// - Parameters:
    ///   - percent: Corner radius as percentage (0-100)
    ///   - size: The size to calculate from
    /// - Returns: The calculated corner radius in points
    ///
    public static func calculateCornerRadius(percent: Double, size: CGSize) -> CGFloat {
        // Use the smaller dimension to ensure circles on non-square elements
        let baseSize = min(size.width, size.height)
        return (baseSize / 2.0) * (percent / 100.0)
    }

    /// Calculates proportional corner radius with padding adjustment.
    ///
    /// When elements have padding that reduces their visual size, use this variant
    /// to account for the padding in the calculation.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let totalSize: CGFloat = 100
    /// let padding: CGFloat = 8
    /// let radius = View.calculateCornerRadius(
    ///     percent: 50,
    ///     size: CGSize(width: totalSize, height: totalSize),
    ///     padding: padding
    /// )
    ///
    /// RoundedRectangle(cornerRadius: radius)
    ///     .fill(.blue)
    ///     .frame(width: totalSize, height: totalSize)
    /// ```
    ///
    /// - Parameters:
    ///   - percent: Corner radius as percentage (0-100)
    ///   - size: The total size including padding
    ///   - padding: The total padding to subtract (applied to all sides)
    /// - Returns: The calculated corner radius in points
    ///
    public static func calculateCornerRadius(
        percent: Double,
        size: CGSize,
        padding: CGFloat
    ) -> CGFloat {
        let adjustedSize = CGSize(
            width: size.width - padding,
            height: size.height - padding
        )
        return calculateCornerRadius(percent: percent, size: adjustedSize)
    }
}

// MARK: - Preview

#Preview("Corner Radius Styles") {
    VStack(spacing: 20) {
        Text("Corner Radius Styles")
            .font(.title)
            .bold()
            .padding(.bottom, 10)

        HStack(spacing: 15) {
            CornerRadiusPreviewItem(percent: CornerRadiusStyle.square, label: "Square")
            CornerRadiusPreviewItem(percent: CornerRadiusStyle.slight, label: "Slight")
            CornerRadiusPreviewItem(percent: CornerRadiusStyle.moderate, label: "Moderate")
        }

        HStack(spacing: 15) {
            CornerRadiusPreviewItem(percent: CornerRadiusStyle.round, label: "Round")
            CornerRadiusPreviewItem(percent: CornerRadiusStyle.circle, label: "Circle")
        }

        Text("Values scale proportionally with element size")
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.top, 10)
    }
    .padding()
}

private struct CornerRadiusPreviewItem: View {
    let percent: Double
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 0)
                .fill(.blue)
                .frame(width: 60, height: 60)
                .adaptiveCornerRadius(percent, size: CGSize(width: 60, height: 60))

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text("\(Int(percent))%")
                .font(.caption2)
                .fontWeight(.medium)
                .monospacedDigit()
        }
    }
}
