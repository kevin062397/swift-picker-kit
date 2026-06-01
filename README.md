# SwiftPickerKit

A SwiftUI component library providing precise, customizable picker controls for iOS 17+. SwiftPickerKit fills the gap between SwiftUI's built-in `Slider` and `Picker` for applications that need high-precision input, scroll-wheel interaction patterns, or tick-mark ruler controls.

## Features

- **Two picker views** — `ItemPicker` for discrete and nominal values; `ContinuousPicker` for numeric ranges
- **Two visual styles** — `ScrollWheel` (labeled cells) and `TickMarkRuler` (tick-mark scale)
- **Two orientations** — horizontal and vertical
- **Tap and drag** — tap any visible item to select it, or drag to scroll with spring snap
- **Real-time callbacks** — `pickerOnEditingChanged` fires when a drag starts and ends
- **Haptic feedback** — optional selection haptic on every value change
- **Full style customization** — conform to `PickerScrollWheelStyle` or `PickerTickMarkRulerStyle` for custom rendering
- **Ruler labels** — configurable text labels at major tick marks
- **Fade-out effect** — configurable opacity fade toward edges for both styles
- **Transparent backgrounds** — no imposed chrome; integrators own the background

## Requirements

- **Deployment target**: iOS 17.0+ (the minimum iOS version that can run the library)
- **Build requirement**: iOS 18 SDK — Xcode 16 or later (required to compile `@Previewable @State` in preview macros)
- macOS 14.0+ (best-effort)
- Swift 6

## Installation

### Swift Package Manager

Add SwiftPickerKit to your project via **File → Add Package Dependencies** in Xcode, or add it directly to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/kevin062397/swift-picker-kit.git", from: "1.0.0")
]
```

Then add `SwiftPickerKit` as a dependency of your target.

## Quick Start

### ItemPicker — discrete and nominal values

Use `ItemPicker` when selecting from a finite collection of values: integers, strings, enums, or any `Hashable` type.

```swift
import SwiftPickerKit

@State var selected = 50
let values = Array(0...100)

VStack {
    Text("\(selected)")
        .font(.body.monospacedDigit())
    ItemPicker(selection: $selected, values: values) { value in
        Text("\(value)")
    }
    .pickerDisplayStyle(.scrollWheel)
    .pickerOrientation(.horizontal)
    .frame(height: 30)
}
```

Switch to a tick-mark ruler style by changing the display style modifier:

```swift
import SwiftPickerKit

@State var selected = 50
let values = Array(0...100)

VStack {
    Text("\(selected)")
        .font(.body.monospacedDigit())
    ItemPicker(selection: $selected, values: values) { value in
        Text("\(value)")
    }
    .pickerDisplayStyle(.tickMarkRuler)
    .pickerOrientation(.horizontal)
    .frame(height: 30)
}
```

### ContinuousPicker — numeric ranges

Use `ContinuousPicker` for `Double` values within a range. Provide a `step` for snapping, or omit it for free continuous drag.

```swift
import SwiftPickerKit

// Stepped — snaps to each 0.1 increment
@State var value = 0.5

VStack {
    Text(String(format: "%.3f", value))
        .font(.body.monospacedDigit())
    ContinuousPicker(value: $value, in: 0...1, step: 0.1)
        .pickerOrientation(.horizontal)
        .frame(height: 30)
}
```

```swift
import SwiftPickerKit

// Step-less — moves freely, no snapping
@State var value = 0.5

VStack {
    Text(String(format: "%.3f", value))
        .font(.body.monospacedDigit())
    ContinuousPicker(value: $value, in: 0...1)
        .pickerOrientation(.horizontal)
        .frame(height: 30)
}
```

## Modifiers

All modifiers are applied as SwiftUI view modifiers using environment propagation — they can be applied to a single picker or to a container to configure multiple pickers at once.

### Display style

```swift
.pickerDisplayStyle(.scrollWheel)    // labeled cells (default)
.pickerDisplayStyle(.tickMarkRuler)  // tick-mark ruler
```

### Orientation

```swift
.pickerOrientation(.horizontal)  // default
.pickerOrientation(.vertical)
```

### Haptics

```swift
.pickerHapticsMode(.disabled)  // default — no haptics
.pickerHapticsMode(.enabled)   // selection haptic on each value change
```

### Editing callbacks

Mirrors SwiftUI `Slider`'s `onEditingChanged` — fires `true` when drag starts, `false` when it ends.

```swift
.pickerOnEditingChanged { isEditing in
    if !isEditing {
        saveValue()  // fire only when the user finishes dragging
    }
}
```

### Scroll wheel item length

Controls how wide (horizontal) or tall (vertical) each item cell is in the scroll wheel, which determines how many items are visible at once. Default is `60`.

```swift
.pickerScrollWheelItemLength(40)  // narrower items, more visible at once
.pickerScrollWheelItemLength(80)  // wider items, fewer visible at once
```

### Custom styles

```swift
.pickerScrollWheelStyle(MyWheelStyle())
.pickerTickMarkRulerStyle(MyRulerStyle())
```

### Ruler tick alignment

Controls which edge tick marks grow from within the ruler's cross-axis.

```swift
.pickerRulerTickAlignment(.center)    // default — ticks centered
.pickerRulerTickAlignment(.leading)   // ticks from top (horizontal) / leading (vertical)
.pickerRulerTickAlignment(.trailing)  // ticks from bottom (horizontal) / trailing (vertical)
```

### Ruler labels

Renders text labels at every major tick. The label closure receives the tick index.

```swift
let values = Array(0...100)

TickMarkRulerRenderer(selection: $selected, values: values)
    .pickerRulerLabels(placement: .after) { index in
        Text("\(values[index])")
            .font(.caption2)
    }
```

`placement` options:

- `.none` — no labels (default)
- `.after` — below ticks (horizontal) / trailing (vertical)
- `.before` — above ticks (horizontal) / leading (vertical)

### Fade-out effect

All pickers fade items toward the edges of the visible area. Three modifiers control the effect:

```swift
// How aggressively items fade (0 = off, 1.0 = default, >1 = reaches minimum before edge)
.pickerRulerFadeStrength(1.0)

// Central zone where opacity is always 1.0 (fraction of half-view, 0.5 = default)
.pickerRulerFadePlateau(0.5)

// Minimum opacity at the edge (0.0 = fully transparent, default)
.pickerRulerFadeMinOpacity(0.0)
```

## Custom Styles

### Custom scroll wheel style

Conform to `PickerScrollWheelStyle` and implement `makeBody(configuration:)`. Each call receives a configuration containing a single item with its label, selection state, and fractional distance from center.

```swift
struct AccentWheelStyle: PickerScrollWheelStyle {
    func makeBody(configuration: PickerScrollWheelStyleConfiguration) -> some View {
        ForEach(configuration.items.indices, id: \.self) { i in
            let item = configuration.items[i]
            item.label
                .foregroundStyle(item.isSelected ? Color.accentColor : Color.primary)
        }
    }
}

ItemPicker(selection: $selected, values: values) { value in
    Text("\(value)")
}
.pickerScrollWheelStyle(AccentWheelStyle())
```

### Custom ruler style

Conform to `PickerTickMarkRulerStyle` and implement `makeBody(configuration:)`. The configuration provides the tick scale and center indicator as composable views.

```swift
struct DarkRulerStyle: PickerTickMarkRulerStyle {
    func makeBody(configuration: PickerTickMarkRulerStyleConfiguration) -> some View {
        ZStack {
            configuration.scale
                .opacity(0.4)
            configuration.indicator
                .tint(.yellow)
        }
    }
}

ContinuousPicker(value: $value, in: 0...1, step: 0.05)
    .pickerTickMarkRulerStyle(DarkRulerStyle())
```

## Platforms

| Platform | Minimum version | Status                                                                  |
| -------- | --------------- | ----------------------------------------------------------------------- |
| iOS      | 17.0            | Primary target — fully supported                                        |
| macOS    | 14.0            | Best-effort — drag interaction works; trackpad scroll not yet supported |
| tvOS     | 17.0            | Build target; interaction not validated                                 |
| visionOS | 1.0             | Build target; interaction not validated                                 |

## Testing in a Demo App

SwiftPickerKit is a Swift Package with no host app. To test interactively in an iOS Simulator:

1. Create a new iOS app project in Xcode
2. Add SwiftPickerKit as a local package dependency (**File → Add Package Dependencies → Add Local…**)
3. Import and use `ItemPicker` or `ContinuousPicker` in your `ContentView`
4. Run on any iPhone simulator

## License

SwiftPickerKit is available under the MIT License.
