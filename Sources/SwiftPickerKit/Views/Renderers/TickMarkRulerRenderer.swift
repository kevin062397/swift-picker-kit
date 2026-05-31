//
//  TickMarkRulerRenderer.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/29/26.
//

import SwiftUI

struct TickMarkRulerRenderer<Value: Hashable>: View {
    @Environment(\.pickerHapticsMode) private var hapticsMode
    @Environment(\.pickerOnEditingChanged) private var onEditingChanged
    @Environment(\.pickerOrientation) private var orientation
    @Environment(\.pickerRulerFadeMinOpacity) private var fadeMinOpacity
    @Environment(\.pickerRulerFadePlateau) private var fadePlateau
    @Environment(\.pickerRulerFadeStrength) private var fadeStrength
    @Environment(\.pickerRulerLabelContent) private var labelContent
    @Environment(\.pickerRulerLabelPlacement) private var labelPlacement
    @Environment(\.pickerTickMarkRulerStyle) private var customStyle

    @GestureState private var dragTranslation: CGFloat = 0

    @State private var baseIndex: Int
    @State private var isDragging = false

    @Binding var selection: Value

    let values: [Value]
    /// Distance between tick centers in points.
    var tickSpacing: CGFloat = 10
    var majorTickEvery: Int = 10

    init(selection: Binding<Value>, values: [Value], tickSpacing: CGFloat = 10, majorTickEvery: Int = 10) {
        self._selection = selection
        self.values = values
        self.tickSpacing = tickSpacing
        self.majorTickEvery = majorTickEvery
        self._baseIndex = State(initialValue: values.firstIndex(of: selection.wrappedValue) ?? 0)
    }

    private var selectedIndex: Int {
        return self.values.firstIndex(of: self.selection) ?? 0
    }

    private var tickCount: Int {
        return self.values.count
    }

    var body: some View {
        GeometryReader { proxy in
            let viewSize = self.orientation == .horizontal ? proxy.size.width : proxy.size.height
            let centerOffset = viewSize / 2
            let dragOffset = centerOffset - CGFloat(self.baseIndex) * self.tickSpacing + self.dragTranslation
            let crossAxisSize = self.orientation == .horizontal ? proxy.size.height : proxy.size.width

            let opacities = self.tickOpacities(dragOffset: dragOffset, viewSize: viewSize)

            self.tickContent(proxy: proxy, opacities: opacities)
                .offset(
                    x: self.orientation == .horizontal ? dragOffset : 0,
                    y: self.orientation == .vertical ? dragOffset : 0
                )
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
                .clipped()
                .overlay(alignment: .topLeading) {
                    if let labelContent = self.labelContent, self.labelPlacement != .none {
                        RulerLabelStack(
                            crossAxisSize: crossAxisSize,
                            tickCount: self.tickCount,
                            tickSpacing: self.tickSpacing,
                            majorTickEvery: self.majorTickEvery,
                            labelContent: labelContent,
                            opacities: opacities
                        )
                        .offset(
                            x: self.orientation == .horizontal ? dragOffset : 0,
                            y: self.orientation == .vertical ? dragOffset : 0
                        )
                    }
                }
                .animation(.interactiveSpring(), value: self.selectedIndex)
                .animation(.interactiveSpring(), value: self.dragTranslation)
                .gesture(
                    DragGesture()
                        .updating(self.$dragTranslation) { value, state, _ in
                            state =
                                self.orientation == .horizontal
                                ? value.translation.width
                                : value.translation.height
                            let offset = state / self.tickSpacing
                            let newIndex = (CGFloat(self.baseIndex) - offset).rounded()
                            let clamped = Int(newIndex.clamped(0, CGFloat(self.tickCount - 1)))
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
                            let offset = translation / self.tickSpacing
                            let newIndex = (CGFloat(self.baseIndex) - offset).rounded()
                            let clamped = Int(newIndex.clamped(0, CGFloat(self.tickCount - 1)))
                            self.selection = self.values[clamped]
                            self.baseIndex = clamped
                            self.isDragging = false
                            self.onEditingChanged?(false)
                        }
                )
        }
        .overlay {
            GeometryReader { proxy in
                let crossAxisSize = self.orientation == .horizontal ? proxy.size.height : proxy.size.width
                RulerCenterIndicator(crossAxisSize: crossAxisSize, orientation: self.orientation)
            }
        }
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

    private func tickOpacities(dragOffset: CGFloat, viewSize: CGFloat) -> [Double] {
        guard self.fadeStrength > 0 else {
            return Array(repeating: 1, count: self.tickCount)
        }
        let center = viewSize / 2
        let plateau = self.fadePlateau.clamped(0, 1) * center
        let minOpacity = self.fadeMinOpacity.clamped(0, 1)
        return (0..<self.tickCount).map { index in
            let tickCenter = dragOffset + CGFloat(index) * self.tickSpacing
            let distance = abs(tickCenter - center)
            guard distance > plateau else { return 1 }
            let fadeDistance = center - plateau
            guard fadeDistance > 0 else { return 1 }
            let normalizedDistance = (distance - plateau) / fadeDistance
            return max(minOpacity, 1 - Double(normalizedDistance * self.fadeStrength))
        }
    }

    @ViewBuilder
    private func tickContent(proxy: GeometryProxy, opacities: [Double]) -> some View {
        if let customStyle {
            customStyle.makeBody(
                configuration: PickerTickMarkRulerStyleConfiguration(
                    scale: AnyView(self.tickScale(proxy: proxy, opacities: opacities)),
                    indicator: AnyView(RulerCenterIndicator(crossAxisSize: self.orientation == .horizontal ? proxy.size.height : proxy.size.width, orientation: self.orientation)),
                    currentValue: Double(self.selectedIndex),
                    range: 0...Double(self.tickCount - 1)
                )
            )
        } else {
            self.tickScale(proxy: proxy, opacities: opacities)
        }
    }

    @ViewBuilder
    private func tickScale(proxy: GeometryProxy, opacities: [Double]) -> some View {
        if self.orientation == .horizontal {
            HStack(spacing: self.tickSpacing - 1) {
                ForEach(0..<self.tickCount, id: \.self) { index in
                    RulerTickMark(
                        isMajor: index % self.majorTickEvery == 0,
                        crossAxisSize: proxy.size.height,
                        orientation: self.orientation,
                        opacity: opacities.indices.contains(index) ? opacities[index] : 1
                    )
                }
            }
        } else {
            VStack(spacing: self.tickSpacing - 1) {
                ForEach(0..<self.tickCount, id: \.self) { index in
                    RulerTickMark(
                        isMajor: index % self.majorTickEvery == 0,
                        crossAxisSize: proxy.size.width,
                        orientation: self.orientation,
                        opacity: opacities.indices.contains(index) ? opacities[index] : 1
                    )
                }
            }
        }
    }
}

#Preview("Horizontal without Labels") {
    @Previewable @State var selected = 50
    let values = Array(0...100)
    VStack {
        Text("\(selected)")
            .font(.body.monospacedDigit())
        TickMarkRulerRenderer(selection: $selected, values: values, tickSpacing: 10)
            .pickerOrientation(.horizontal)
            .frame(height: 30)
    }
}

#Preview("Horizontal with Labels") {
    @Previewable @State var selected = 50
    let values = Array(0...100)
    VStack {
        Text("\(selected)")
            .font(.body.monospacedDigit())
        TickMarkRulerRenderer(selection: $selected, values: values, tickSpacing: 10)
            .pickerOrientation(.horizontal)
            .pickerRulerLabels(placement: .after) { index in
                Text("\(values[index])")
                    .font(.caption.bold().monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .frame(height: 30)
    }
}

#Preview("Vertical without Labels") {
    @Previewable @State var selected = 50
    let values = Array(0...100)
    HStack {
        Text("\(selected)")
            .font(.body.monospacedDigit())
        TickMarkRulerRenderer(selection: $selected, values: values, tickSpacing: 10)
            .pickerOrientation(.vertical)
            .frame(width: 30)
    }
}

#Preview("Vertical with Labels") {
    @Previewable @State var selected = 50
    let values = Array(0...100)
    HStack {
        Text("\(selected)")
            .font(.body.monospacedDigit())
        TickMarkRulerRenderer(selection: $selected, values: values, tickSpacing: 10)
            .pickerOrientation(.vertical)
            .pickerRulerLabels(placement: .after) { index in
                Text("\(values[index])")
                    .font(.caption.bold().monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .frame(width: 30)
    }
}
