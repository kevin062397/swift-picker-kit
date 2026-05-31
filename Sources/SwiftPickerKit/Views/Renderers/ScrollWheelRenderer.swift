//
//  ScrollWheelRenderer.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/29/26.
//

import SwiftUI

struct ScrollWheelRenderer<Value: Hashable, Label: View>: View {
    @Environment(\.pickerHapticsMode) private var hapticsMode
    @Environment(\.pickerOnEditingChanged) private var onEditingChanged
    @Environment(\.pickerOrientation) private var orientation
    @Environment(\.pickerRulerFadeMinOpacity) private var fadeMinOpacity
    @Environment(\.pickerRulerFadePlateau) private var fadePlateau
    @Environment(\.pickerRulerFadeStrength) private var fadeStrength
    @Environment(\.pickerScrollWheelStyle) private var customStyle

    @GestureState private var dragTranslation: CGFloat = 0

    @State private var baseIndex: Int
    @State private var isDragging = false

    @Binding var selection: Value

    let values: [Value]
    var itemLength: CGFloat = 60
    let label: (Value) -> Label

    init(selection: Binding<Value>, values: [Value], itemLength: CGFloat = 60, label: @escaping (Value) -> Label) {
        self._selection = selection
        self.values = values
        self.itemLength = itemLength
        self.label = label
        self._baseIndex = State(initialValue: values.firstIndex(of: selection.wrappedValue) ?? 0)
    }

    private var selectedIndex: Int {
        return self.values.firstIndex(of: self.selection) ?? 0
    }

    private func itemOpacity(index: Int, dragOffset: CGFloat, viewSize: CGFloat) -> Double {
        guard self.fadeStrength > 0 else { return 1 }
        let center = viewSize / 2
        let plateau = self.fadePlateau.clamped(0, 1) * center
        // Item center in screen coordinates
        let itemCenter = dragOffset + CGFloat(index) * self.itemLength + self.itemLength / 2
        let distance = abs(itemCenter - center)
        guard distance > plateau else { return 1 }
        let fadeDistance = center - plateau
        guard fadeDistance > 0 else { return 1 }
        let normalizedDistance = (distance - plateau) / fadeDistance
        return max(self.fadeMinOpacity.clamped(0, 1), 1 - Double(normalizedDistance * self.fadeStrength))
    }

    var body: some View {
        GeometryReader { proxy in
            let viewSize = self.orientation == .horizontal ? proxy.size.width : proxy.size.height
            let centerOffset = viewSize / 2 - self.itemLength / 2
            let dragOffset = centerOffset - CGFloat(self.baseIndex) * self.itemLength + self.dragTranslation

            self.itemStack {
                ForEach(0..<self.values.count, id: \.self) { index in
                    self.itemView(index: index, proxy: proxy, dragOffset: dragOffset, viewSize: viewSize)
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
                        // Update selection in real-time during drag
                        let offset = state / self.itemLength
                        let newIndex = (CGFloat(self.baseIndex) - offset).rounded()
                        let clamped = Int(newIndex.clamped(0, CGFloat(self.values.count - 1)))
                        if self.values[clamped] != self.selection {
                            self.selection = self.values[clamped]
                        }
                    }
                    .onChanged { _ in
                        if !self.isDragging {
                            self.isDragging = true
                            self.onEditingChanged?(true)
                        }
                    }
                    .onEnded { value in
                        let translation =
                            self.orientation == .horizontal
                            ? value.translation.width
                            : value.translation.height
                        let offset = translation / self.itemLength
                        let newIndex = (CGFloat(self.baseIndex) - offset).rounded()
                        let clamped = Int(newIndex.clamped(0, CGFloat(self.values.count - 1)))
                        self.selection = self.values[clamped]
                        self.baseIndex = clamped
                        self.isDragging = false
                        self.onEditingChanged?(false)
                    }
            )
        }
        .clipped()
        .onAppear {
            self.baseIndex = self.selectedIndex
        }
        .onChange(of: self.selection) { _, _ in
            if !self.isDragging {
                self.baseIndex = self.selectedIndex
            }
            #if canImport(UIKit)
                if self.hapticsMode == .enabled {
                    FeedbackGenerator.selectionChanged()
                }
            #endif
        }
    }

    @ViewBuilder
    private func itemView(index: Int, proxy: GeometryProxy, dragOffset: CGFloat, viewSize: CGFloat) -> some View {
        let distance = CGFloat(index - self.baseIndex) + self.dragTranslation / self.itemLength
        let opacity = self.itemOpacity(index: index, dragOffset: dragOffset, viewSize: viewSize)
        let itemContent = self.label(self.values[index])
            .frame(
                width: self.orientation == .horizontal ? self.itemLength : proxy.size.width,
                height: self.orientation == .vertical ? self.itemLength : proxy.size.height
            )
        let config = PickerScrollWheelStyleConfiguration(items: [
            PickerScrollWheelStyleConfiguration.Item(
                label: AnyView(itemContent),
                isSelected: index == self.selectedIndex,
                distanceFromCenter: distance
            )
        ])
        let styled = self.customStyle.map { AnyView($0.makeBody(configuration: config)) } ?? AnyView(DefaultScrollWheelStyle().makeBody(configuration: config))
        styled
            .opacity(opacity)
            .onTapGesture {
                withAnimation(.interactiveSpring()) {
                    self.baseIndex = index
                    self.selection = self.values[index]
                }
            }
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

#Preview("Horizontal") {
    @Previewable @State var selected = 50
    let values = Array(0...100)
    VStack {
        Text("\(selected)")
            .font(.body.monospacedDigit())
        ScrollWheelRenderer(selection: $selected, values: values, itemLength: 60) { value in
            Text("\(value)")
        }
        .pickerOrientation(.horizontal)
        .frame(height: 30)
    }
}

#Preview("Vertical") {
    @Previewable @State var selected = 50
    let values = Array(0...100)
    HStack {
        Text("\(selected)")
            .font(.body.monospacedDigit())
        ScrollWheelRenderer(selection: $selected, values: values, itemLength: 60) { value in
            Text("\(value)")
        }
        .pickerOrientation(.vertical)
        .frame(width: 30)
    }
}
