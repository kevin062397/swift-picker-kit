//
//  ViewExtensions.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

extension View {
    /// Sets the visual display style for a picker.
    /// - Parameter displayStyle: The style to use — `.scrollWheel` or `.tickMarkRuler`.
    public func pickerDisplayStyle(_ displayStyle: PickerDisplayStyle) -> some View {
        self.environment(\.pickerDisplayStyle, displayStyle)
    }

    /// Sets the scroll orientation of a picker.
    /// - Parameter orientation: `.horizontal` or `.vertical`.
    public func pickerOrientation(_ orientation: PickerOrientation) -> some View {
        self.environment(\.pickerOrientation, orientation)
    }

    /// Controls haptic feedback on value changes.
    /// - Parameter hapticsMode: `.enabled` produces a selection haptic on each value change.
    ///   `.disabled` (default) produces no haptics.
    public func pickerHapticsMode(_ hapticsMode: PickerHapticsMode) -> some View {
        self.environment(\.pickerHapticsMode, hapticsMode)
    }

    /// Applies a custom rendering style to a tick-mark ruler picker.
    ///
    /// The style receives the tick scale and center indicator as `AnyView` values and
    /// is responsible for composing them into a final view.
    /// - Parameter style: A value conforming to ``PickerTickMarkRulerStyle``.
    public func pickerTickMarkRulerStyle<S: PickerTickMarkRulerStyle>(_ style: S) -> some View {
        self.environment(\.pickerTickMarkRulerStyle, AnyPickerTickMarkRulerStyle(style))
    }

    /// Applies a custom rendering style to a scroll wheel picker.
    ///
    /// The style receives each item's label and distance-from-center value and
    /// is responsible for visual emphasis.
    /// - Parameter style: A value conforming to ``PickerScrollWheelStyle``.
    public func pickerScrollWheelStyle<S: PickerScrollWheelStyle>(_ style: S) -> some View {
        self.environment(\.pickerScrollWheelStyle, AnyPickerScrollWheelStyle(style))
    }

    /// Registers a callback that fires when the user starts or finishes dragging.
    ///
    /// The callback receives `true` when a drag begins and `false` when it ends.
    /// This mirrors the behaviour of SwiftUI's native `Slider` `onEditingChanged`.
    ///
    /// - Parameter action: Called with `true` on drag start, `false` on drag end.
    public func pickerOnEditingChanged(_ action: @escaping (Bool) -> Void) -> some View {
        self.environment(\.pickerOnEditingChanged, PickerEditingChangedAction(action: action))
    }

    /// Controls the alignment of tick marks within the ruler's cross-axis.
    ///
    /// - Parameter alignment: `.leading`, `.center` (default), or `.trailing`.
    ///   See ``PickerRulerTickAlignment`` for descriptions of each case.
    public func pickerRulerTickAlignment(_ alignment: PickerRulerTickAlignment) -> some View {
        self.environment(\.pickerRulerTickAlignment, alignment)
    }

    /// Adds text labels at every major tick mark on a ruler picker.
    ///
    /// Labels are rendered outside the tick area and do not affect the ruler's layout frame.
    ///
    /// - Parameter placement: Where labels appear relative to the tick marks. Default is `.after`
    ///   (below ticks in horizontal orientation, trailing in vertical).
    /// - Parameter label: A view builder receiving the tick index. Map the index to a display value
    ///   as needed (e.g. `Text("\(values[index])")`).
    public func pickerRulerLabels<Label: View>(placement: PickerRulerLabelPlacement = .after, @ViewBuilder label: @escaping (Int) -> Label) -> some View {
        self.environment(\.pickerRulerLabelPlacement, placement).environment(\.pickerRulerLabelContent, PickerRulerLabelContent(makeLabel: { AnyView(label($0)) }))
    }

    /// Sets the minimum opacity applied to tick marks and labels at the edges of the view.
    ///
    /// - Parameter opacity: A value in `0...1`. `0.0` (default) means fully transparent at the edge.
    ///   `1.0` effectively disables the fade-out effect.
    public func pickerRulerFadeMinOpacity(_ opacity: Double) -> some View {
        self.environment(\.pickerRulerFadeMinOpacity, opacity)
    }

    /// Sets the no-fade plateau zone around the center of a ruler picker.
    ///
    /// Items within this zone always render at full opacity regardless of `pickerRulerFadeStrength`.
    ///
    /// - Parameter plateau: A fraction of the half-view size. `0.0` (fade starts immediately from
    ///   center), `0.5` (default — central 50% of the half-view is fully opaque), `1.0` (entire
    ///   view is fully opaque, disabling the fade).
    public func pickerRulerFadePlateau(_ plateau: CGFloat) -> some View {
        self.environment(\.pickerRulerFadePlateau, plateau)
    }

    /// Sets how aggressively tick marks and labels fade toward the edges of a ruler picker.
    ///
    /// - Parameter strength: `0.0` disables fading. `1.0` (default) fades to
    ///   `pickerRulerFadeMinOpacity` at the view edge. Values above `1.0` cause items to
    ///   reach minimum opacity before the edge.
    public func pickerRulerFadeStrength(_ strength: CGFloat) -> some View {
        self.environment(\.pickerRulerFadeStrength, strength)
    }

    /// Sets the length of each item cell along the scroll axis in a scroll wheel picker.
    ///
    /// This controls how wide (horizontal) or tall (vertical) each item is, and therefore
    /// how many items are visible at once. Default is `60`.
    /// - Parameter length: The item cell length in points.
    public func pickerScrollWheelItemLength(_ length: CGFloat) -> some View {
        self.environment(\.pickerScrollWheelItemLength, length)
    }
}
