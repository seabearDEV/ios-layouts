# SeaBearKit

[![Swift Version](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2017+%20|%20macOS%2014+-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager)

A collection of SwiftUI layout patterns and UI components for iOS development.

## Core Feature: Persistent Background Navigation

The **PersistentBackgroundNavigation** component maintains consistent backgrounds across NavigationStack transitions.

This pattern was developed through extensive iteration to address SwiftUI's navigation background consistency issues.

## Features

### Navigation & Backgrounds
- **Automatic Navigation**: Background persistence without manual modifiers
- **Persistent Background System**: NavigationStack wrapper that maintains backgrounds during transitions
- **Flexible API**: Choose automatic convenience wrappers or manual control
- **Gradient Backgrounds**: Configurable gradients with vignette effects (iOS 18+ Liquid Glass compatible)
- **Custom Backgrounds**: Use any SwiftUI view as a persistent background (images, videos, animations)
- **Color Palettes**: Extensible palette system with nine built-in themes

### View Modifiers (New in 1.3.0)
- **Conditional Modifiers**: Clean `.if()` syntax for conditional view transformations
- **Glass Shadows**: Unified `.glassShadow()` system for Liquid Glass UI with press states
- **Adaptive Corner Radius**: Proportional corner radius that scales across device sizes

### General
- **Performance Optimized**: Static gradients with minimal battery impact
- **Appearance Adaptive**: Automatic light/dark mode support
- **Material Integration**: Compatible with iOS 18+ material system
- **Pure SwiftUI**: No external dependencies

## Quick Start

### 1. Wrap your app in PersistentBackgroundNavigation

```swift
import SwiftUI
import SeaBearKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            PersistentBackgroundNavigation(palette: .sunset) {
                ContentView()
            }
        }
    }
}
```

### 2. Use navigation in your views

**Automatic (Recommended)** - No manual configuration required:
```swift
PersistentNavigationLink("View Details") {
    DetailView()  // Background persists automatically!
}
```

**Manual (Advanced)** - For precise control:
```swift
NavigationLink("View Details") {
    DetailView()
        .clearNavigationBackground()
}
```

Both approaches work - choose what fits your style.

## Requirements

- iOS 17.0+ (iOS 18+ recommended for optimal experience)
- Swift 6.0+
- Xcode 15.0+

**Note**: While iOS 17 is supported, iOS 18+ provides the optimal experience using `.containerBackground(for: .navigation)`. iOS 17 uses a fallback approach that works well in most cases.

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/seabearDEV/SeaBearKit.git", from: "1.0.0")
]
```

Or in Xcode: File → Add Package Dependencies → Enter repository URL

## Navigation Approaches

SeaBearKit provides flexibility to match your coding style:

### Automatic (Recommended for most cases)

Use `PersistentNavigationLink` for automatic navigation:

```swift
PersistentNavigationLink("Details") {
    DetailView()
}

// Custom label
PersistentNavigationLink {
    DetailView()
} label: {
    HStack {
        Image(systemName: "star")
        Text("Featured")
    }
}
```

Value-based navigation:
```swift
NavigationStack {
    List(items) { item in
        Button(item.name) {
            selectedItem = item
        }
    }
}
.persistentNavigationDestination(for: Item.self) { item in
    ItemDetailView(item: item)
}
```

### Manual (Advanced control)

Use standard `NavigationLink` with `.clearNavigationBackground()`:

```swift
NavigationLink("Settings") {
    SettingsView()
        .clearNavigationBackground()
        .customModifier()  // Add your own modifiers
}
```

### When to use each:

- **Automatic**: Large apps, team projects, when you want it to "just work"
- **Manual**: Edge cases, when you need additional modifiers, precise control

Both approaches coexist - use what makes sense for each screen.

## Color Palettes

The library includes nine built-in palettes and supports custom palette creation:

```swift
// Built-in palettes
.sunset         // Warm tones: coral, orange, yellow
.ocean          // Cool blues and teals
.forest         // Natural greens and earth tones
.monochrome     // Grayscale
.midnight       // Dark blues and purples (for dark themes)
.cherryBlossom  // Soft pinks and roses
.autumn         // Warm oranges, reds, and browns
.lavender       // Calming purple and blue tones
.mint           // Fresh greens and blues

// Custom palette
ColorPalette(
    name: "Custom",
    colors: [.red, .orange, .yellow, .green, .blue],
    gradientIndices: [0, 2, 4],
    gradientOpacities: [0.4, 0.5, 0.6]
)
```

## Configuration Modes

Two configuration modes are available:

```swift
// Standard (gradient background)
PersistentBackgroundNavigation(palette: .sunset)

// Minimal (system background only)
PersistentBackgroundNavigation.minimal(palette: .forest)
```

## Custom Backgrounds

Use any SwiftUI view as a persistent background:

```swift
PersistentBackgroundNavigation {
    // Your custom background
    Image("hero-image")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
} content: {
    ContentView()
}
```

Examples of custom backgrounds:
- **Images**: Hero images, patterns, textures
- **Videos**: Background video playback
- **Animated Gradients**: Time-based color transitions
- **Custom Views**: Any SwiftUI composition

The same persistent architecture applies - your custom background stays consistent across all navigation transitions.

## View Modifiers

SeaBearKit provides essential view modifiers for cleaner, more maintainable SwiftUI code.

### Conditional Modifiers

Apply transformations based on conditions without duplicating view code:

```swift
Text("Hello")
    .if(isHighlighted) { view in
        view.foregroundStyle(.red)
    }
    .if(colorScheme == .dark) { view in
        view.background(.black)
    }

// With both branches
Text("Status")
    .if(isActive,
        then: { $0.foregroundStyle(.green) },
        else: { $0.foregroundStyle(.gray) }
    )
```

### Glass Shadows

Unified shadow system optimized for Liquid Glass design with automatic press state handling:

```swift
// Basic shadow
Button("Action") { }
    .buttonStyle(.borderedProminent)
    .glassShadow()

// With press state
struct GlassButton: View {
    @State private var isPressed = false

    var body: some View {
        Text("Press Me")
            .padding()
            .background(.regularMaterial)
            .glassShadow(isPressed: isPressed, intensity: .regular)
            .scaleEffect(isPressed ? 0.97 : 1.0)
    }
}

// Different intensities
view.glassShadow(intensity: .subtle)     // Subtle elevation
view.glassShadow(intensity: .regular)    // Standard (default)
view.glassShadow(intensity: .prominent)  // High elevation
```

### Adaptive Corner Radius

Proportional corner radius system that scales consistently across device sizes:

```swift
// Using percentage (0% = square, 100% = circle)
RoundedRectangle(cornerRadius: 0)
    .fill(.blue)
    .frame(width: 100, height: 100)
    .adaptiveCornerRadius(40, size: CGSize(width: 100, height: 100))

// Using predefined styles
RoundedRectangle(cornerRadius: 0)
    .adaptiveCornerRadius(CornerRadiusStyle.round, size: size)

// Available styles
CornerRadiusStyle.square    // 0%   - Perfect squares
CornerRadiusStyle.slight    // 15%  - Subtle corners
CornerRadiusStyle.moderate  // 40%  - Balanced
CornerRadiusStyle.round     // 65%  - Prominent curves
CornerRadiusStyle.circle    // 100% - Perfect circles

// Calculate radius independently
let radius = View.calculateCornerRadius(percent: 50, size: size)
```

## Documentation

- **[Usage Guide](USAGE.md)** - Comprehensive examples and best practices
- **[Architecture](ARCHITECTURE.md)** - Technical details and design decisions
- **[Liquid Glass Compliance](LIQUID_GLASS.md)** - iOS 18+ Liquid Glass design system integration
- **[IMPORTANT](IMPORTANT.md)** - Critical requirement for all navigation views
- **[Demo App](Sources/Demo/)** - Full working example showcasing all features

## Problem Statement

Standard SwiftUI NavigationStack implementations create their own backgrounds that can change inconsistently during transitions. This library addresses the issue through a layered approach:

```swift
ZStack {
    PersistentBackground(palette: palette)  // Lives outside navigation lifecycle

    NavigationStack {
        Content()
            .containerBackground(for: .navigation) {
                Color.clear  // Makes navigation transparent
            }
    }
}
```

This approach ensures consistent background rendering throughout navigation transitions.

## Project Origins

This pattern was developed through iterative refinement to resolve background consistency issues in SwiftUI navigation. Key development milestones:

- Resolved background consistency during color palette transitions
- Centralized background rendering and improved gradient visibility
- Removed LinearGradient tint overlays to improve navigation rendering
- Standardized navigation transitions and view backgrounds

## Demo

To view interactive previews:

```bash
git clone https://github.com/seabearDEV/SeaBearKit.git
cd SeaBearKit
open Package.swift
```

Navigate to `PersistentBackgroundNavigation.swift` and open Canvas (⌥⌘↩) for interactive preview.

Complete demo instructions available in **[DEMO.md](DEMO.md)**

## Development

### Running Tests

```bash
# Run all tests
swift test

# Build the package
swift build

# Open in Xcode
open Package.swift
```

### Testing in Your Project

Add the package locally for testing:

```swift
// In your Package.swift
dependencies: [
    .package(path: "/path/to/SeaBearKit")
]
```

Or use Xcode: **File → Add Package Dependencies → Add Local**

## Contributing

Contributions are welcome! Please read **[CONTRIBUTING.md](CONTRIBUTING.md)** for:
- Development setup
- Code standards
- Testing requirements
- Pull request process

All contributions should maintain:
- iOS 17+ compatibility (iOS 18+ for optimal experience)
- Swift 6 strict concurrency compliance
- All tests passing (`swift test`)
- Documentation updates for API changes
- CHANGELOG.md updates

## License

MIT License - see [LICENSE](LICENSE) file for details

## Author

**Kory Hoopes** - [seabearDEV](https://github.com/seabearDEV)

## Acknowledgments

This library was developed to address common challenges encountered in iOS development.
