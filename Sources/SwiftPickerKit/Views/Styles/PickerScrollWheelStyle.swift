//
//  PickerScrollWheelStyle.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

/// The configuration passed to a ``PickerScrollWheelStyle`` when rendering.
public struct PickerScrollWheelStyleConfiguration {
    /// A single item in the scroll wheel.
    public struct Item {
        /// The rendered content of the item, produced by the `label` closure passed to `ItemPicker`.
        public let label: AnyView

        /// Whether this item is currently the selected value.
        public let isSelected: Bool

        /// Fractional distance from the centered position.
        /// `0` = centered, `±1` = one item-width away from center.
        /// Updates continuously during drag for real-time visual feedback.
        /// Note: the renderer applies fade-out opacity independently via
        /// `.pickerRulerFadeStrength` — custom styles may additionally use
        /// this value to drive their own visual emphasis.
        public let distanceFromCenter: CGFloat
    }

    /// All visible items in the scroll wheel. Each call to `makeBody` receives
    /// exactly one item — the configuration wraps it in an array for protocol flexibility.
    public let items: [Item]
}

/// A type that defines the visual appearance of an ``ItemPicker`` in scroll wheel style.
///
/// Conform to this protocol to provide a custom rendering for scroll wheel items.
/// Use the ``PickerScrollWheelStyleConfiguration/Item/distanceFromCenter`` value
/// to drive custom scale, color, or other emphasis effects.
///
/// Apply a custom style with `.pickerScrollWheelStyle(_:)`.
public protocol PickerScrollWheelStyle {
    associatedtype Body: View

    /// Creates the view representing a single scroll wheel item.
    @ViewBuilder
    func makeBody(configuration: PickerScrollWheelStyleConfiguration) -> Body
}
