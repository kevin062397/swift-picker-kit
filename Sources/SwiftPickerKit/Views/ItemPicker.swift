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

#Preview("ScrollWheel") {
    @Previewable @State var selected = 16
    ItemPicker(selection: $selected, values: [12, 14, 16, 18, 20]) { size in
        Text("\(size)")
    }
    .pickerDisplayStyle(.scrollWheel)
    .pickerOrientation(.horizontal)
    .padding()
}

#Preview("TickMarkRuler") {
    @Previewable @State var selected = 16
    ItemPicker(selection: $selected, values: [12, 14, 16, 18, 20]) { size in
        Text("\(size)")
    }
    .pickerDisplayStyle(.tickMarkRuler)
    .pickerOrientation(.horizontal)
    .padding()
}
