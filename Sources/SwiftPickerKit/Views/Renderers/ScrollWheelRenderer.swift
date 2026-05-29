//
//  ScrollWheelRenderer.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/29/26.
//

import SwiftUI

struct ScrollWheelRenderer<Value: Hashable, Label: View>: View {
    @Environment(\.pickerOrientation) private var orientation
    @Environment(\.pickerScrollWheelStyle) private var customStyle

    @Binding var selection: Value

    @GestureState private var dragTranslation: CGFloat = 0

    let values: [Value]
    var itemLength: CGFloat = 60
    let label: (Value) -> Label

    private var selectedIndex: Int {
        return self.values.firstIndex(of: self.selection) ?? 0
    }

    var body: some View {
        GeometryReader { proxy in
            let viewSize = self.orientation == .horizontal ? proxy.size.width : proxy.size.height
            let centerOffset = viewSize / 2 - self.itemLength / 2
            let dragOffset = centerOffset - CGFloat(self.selectedIndex) * self.itemLength + self.dragTranslation

            self.itemStack {
                ForEach(self.values.indices, id: \.self) { index in
                    let distance = CGFloat(index - self.selectedIndex) + self.dragTranslation / self.itemLength
                    let itemView = self.label(self.values[index])
                        .frame(
                            width: self.orientation == .horizontal ? self.itemLength : proxy.size.width,
                            height: self.orientation == .vertical ? self.itemLength : proxy.size.height
                        )
                    let configItem = PickerScrollWheelStyleConfiguration.Item(
                        label: AnyView(itemView),
                        isSelected: index == self.selectedIndex,
                        distanceFromCenter: distance
                    )
                    if let customStyle {
                        customStyle.makeBody(configuration: PickerScrollWheelStyleConfiguration(items: [configItem]))
                    } else {
                        DefaultScrollWheelStyle().makeBody(
                            configuration: PickerScrollWheelStyleConfiguration(items: [configItem])
                        )
                    }
                }
            }
            .offset(
                x: self.orientation == .horizontal ? dragOffset : 0,
                y: self.orientation == .vertical ? dragOffset : 0
            )
            .animation(.interactiveSpring(), value: self.selectedIndex)
            .animation(.interactiveSpring(), value: self.dragTranslation)
            .gesture(
                DragGesture()
                    .updating(self.$dragTranslation) { value, state, _ in
                        state =
                            self.orientation == .horizontal
                            ? value.translation.width
                            : value.translation.height
                    }
                    .onEnded { value in
                        let translation =
                            self.orientation == .horizontal
                            ? value.translation.width
                            : value.translation.height
                        let offset = translation / self.itemLength
                        let newIndex = (CGFloat(self.selectedIndex) - offset).rounded()
                        let clamped = Int(min(max(newIndex, 0), CGFloat(self.values.count - 1)))
                        self.selection = self.values[clamped]
                    }
            )
        }
        .clipped()
    }

    @ViewBuilder
    private func itemStack<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        if self.orientation == .horizontal {
            HStack(spacing: 0, content: content)
        } else {
            VStack(spacing: 0, content: content)
        }
    }
}

// MARK: - Previews

#Preview("Horizontal") {
    @Previewable @State var selected = 16
    ScrollWheelRenderer(selection: $selected, values: [12, 14, 16, 18, 20], itemLength: 60) { size in
        Text("\(size)")
    }
    .pickerOrientation(.horizontal)
    .padding()
}

#Preview("Vertical") {
    @Previewable @State var selected = 16
    ScrollWheelRenderer(selection: $selected, values: [12, 14, 16, 18, 20], itemLength: 60) { size in
        Text("\(size)")
    }
    .pickerOrientation(.vertical)
    .padding()
}
