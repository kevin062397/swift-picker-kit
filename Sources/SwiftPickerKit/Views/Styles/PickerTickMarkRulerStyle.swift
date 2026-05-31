//
//  PickerTickMarkRulerStyle.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

/// The configuration passed to a ``PickerTickMarkRulerStyle`` when rendering.
public struct PickerTickMarkRulerStyleConfiguration {
    /// The scrollable tick-mark scale as a rendered view.
    /// Offset and gesture handling are managed by the renderer;
    /// this view contains only the visual tick marks.
    public let scale: AnyView

    /// The fixed center indicator rendered as an overlay on top of the scale.
    public let indicator: AnyView

    /// The currently selected value as a tick index (0-based).
    public let currentValue: Double

    /// The full range of valid tick indices, from `0` to `tickCount - 1`.
    public let range: ClosedRange<Double>
}

/// A type that defines the visual appearance of a ruler picker.
///
/// Conform to this protocol to provide fully custom rendering for the tick-mark scale
/// and center indicator. The renderer handles gestures, snap logic, and haptics —
/// the style is responsible only for visual presentation.
///
/// Apply a custom style with `.pickerTickMarkRulerStyle(_:)`.
public protocol PickerTickMarkRulerStyle {
    associatedtype Body: View
    /// Creates the view representing the ruler, composed from the given scale and indicator.
    @ViewBuilder func makeBody(configuration: PickerTickMarkRulerStyleConfiguration) -> Body
}
