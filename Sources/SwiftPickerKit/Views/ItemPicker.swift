//
//  ItemPicker.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

/// A picker that selects one value from a finite ordered or unordered collection.
///
/// Use `ItemPicker` for nominal values (e.g. map styles) and discrete stepped values
/// (e.g. font sizes, playback speeds). For continuous numeric ranges, use ``ContinuousPicker``.
///
/// ```swift
/// @State private var selectedSize = 16
/// let sizes = [8, 10, 12, 14, 16, 18, 20, 24]
///
/// ItemPicker(selection: $selectedSize, values: sizes) { size in
///     Text("\(size)")
/// }
/// .pickerDisplayStyle(.scrollWheel)
/// .pickerOrientation(.horizontal)
/// ```
public struct ItemPicker<Value: Hashable, Label: View>: View {
    @Environment(\.pickerDisplayStyle) private var displayStyle
    @Environment(\.pickerOrientation) private var orientation

    @Binding private var selection: Value

    private let values: [Value]
    private let label: (Value) -> Label

    /// Creates an item picker.
    /// - Parameter selection: A binding to the currently selected value.
    /// - Parameter values: The ordered collection of values to pick from.
    /// - Parameter label: A view builder that produces a label for each value.
    public init(
        selection: Binding<Value>,
        values: [Value],
        @ViewBuilder label: @escaping (Value) -> Label
    ) {
        self._selection = selection
        self.values = values
        self.label = label
    }

    public var body: some View {
        switch self.displayStyle {
        case .scrollWheel:
            ScrollWheelRenderer(selection: self.$selection, values: self.values, label: self.label)
        case .tickMarkRuler:
            TickMarkRulerRenderer(selection: self.$selection, values: self.values)
        }
    }
}

#Preview("Scroll Wheel") {
    @Previewable @State var selected = 50
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
}

#Preview("Tick Mark Ruler") {
    @Previewable @State var selected = 50
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
}
