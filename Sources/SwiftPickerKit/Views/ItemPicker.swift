//
//  ItemPicker.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

public struct ItemPicker<Value: Hashable, Label: View>: View {
    @Environment(\.pickerDisplayStyle) private var displayStyle
    @Environment(\.pickerOrientation) private var orientation

    @Binding private var selection: Value

    private let values: [Value]
    private let label: (Value) -> Label

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
    }
}
