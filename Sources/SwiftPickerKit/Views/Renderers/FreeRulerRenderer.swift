//
//  FreeRulerRenderer.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/29/26.
//

import SwiftUI

/// A ruler renderer for step-less continuous ranges.
/// Drag moves the ruler freely with no snapping — value updates proportionally to position.
struct FreeRulerRenderer: View {
    @Environment(\.pickerHapticsMode) private var hapticsMode
    @Environment(\.pickerOnEditingChanged) private var onEditingChanged
    @Environment(\.pickerOrientation) private var orientation
    @Environment(\.pickerRulerFadeMinOpacity) private var fadeMinOpacity
    @Environment(\.pickerRulerFadePlateau) private var fadePlateau
    @Environment(\.pickerRulerFadeStrength) private var fadeStrength
    @Environment(\.pickerRulerLabelContent) private var labelContent
    @Environment(\.pickerRulerLabelPlacement) private var labelPlacement

    @Binding var value: Double
    let range: ClosedRange<Double>

    var tickSpacing: CGFloat = 10
    var majorTickEvery: Int = 10

    @GestureState private var dragTranslation: CGFloat = 0
    @State private var startValue: Double
    @State private var isDragging = false

    private var span: Double {
        return self.range.upperBound - self.range.lowerBound
    }

    private var tickCount: Int {
        return max(1, min(Int((self.span * 10).rounded(.up)), 500)) + 1
    }

    private var totalLength: CGFloat {
        return CGFloat(self.tickCount - 1) * self.tickSpacing
    }

    init(value: Binding<Double>, in range: ClosedRange<Double>, tickSpacing: CGFloat = 10, majorTickEvery: Int = 10) {
        self._value = value
        self.range = range
        self.tickSpacing = tickSpacing
        self.majorTickEvery = majorTickEvery
        self._startValue = State(initialValue: value.wrappedValue)
    }

    var body: some View {
        GeometryReader { proxy in
            let viewSize = self.orientation == .horizontal ? proxy.size.width : proxy.size.height
            let centerOffset = viewSize / 2
            // Visual offset is anchored to startValue — only dragTranslation moves the strip
            // This avoids a feedback loop where value changes also shift the strip
            let baseOffset = self.offset(for: self.startValue)
            let dragOffset = centerOffset - baseOffset + self.dragTranslation
            let crossAxisSize = self.orientation == .horizontal ? proxy.size.height : proxy.size.width

            let opacities = self.tickOpacities(dragOffset: dragOffset, viewSize: viewSize)

            self.tickScale(proxy: proxy, opacities: opacities)
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
                .animation(nil, value: self.dragTranslation)
                .animation(.interactiveSpring(), value: self.startValue)
                .gesture(
                    DragGesture()
                        .updating(self.$dragTranslation) { gestureValue, state, _ in
                            let translation =
                                self.orientation == .horizontal
                                ? gestureValue.translation.width
                                : gestureValue.translation.height
                            state = translation
                            let delta = Double(translation) / Double(self.totalLength) * self.span
                            let newValue = (self.startValue - delta)
                                .clamped(self.range.lowerBound, self.range.upperBound)
                            if newValue != self.value {
                                self.value = newValue
                            }
                        }
                        .onChanged { _ in
                            if !self.isDragging {
                                self.isDragging = true
                                self.onEditingChanged?(true)
                            }
                        }
                        .onEnded { _ in
                            // Commit: move the base anchor to the final value position
                            self.startValue = self.value
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
        .onChange(of: self.value) { _, newValue in
            if !self.isDragging {
                self.startValue = newValue
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
    private func tickScale(proxy: GeometryProxy, opacities: [Double]) -> some View {
        let crossAxisSize = self.orientation == .horizontal ? proxy.size.height : proxy.size.width
        if self.orientation == .horizontal {
            HStack(spacing: self.tickSpacing - 1) {
                ForEach(0..<self.tickCount, id: \.self) { index in
                    RulerTickMark(
                        isMajor: index % self.majorTickEvery == 0,
                        crossAxisSize: crossAxisSize,
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
                        crossAxisSize: crossAxisSize,
                        orientation: self.orientation,
                        opacity: opacities.indices.contains(index) ? opacities[index] : 1
                    )
                }
            }
        }
    }

    private func offset(for value: Double) -> CGFloat {
        guard self.span > 0 else { return 0 }
        let normalized = (value - self.range.lowerBound) / self.span
        return CGFloat(normalized) * self.totalLength
    }
}

#Preview("Horizontal without Labels") {
    @Previewable @State var value = 0.5
    VStack {
        Text(String(format: "%.3f", value))
            .font(.body.monospacedDigit())
        FreeRulerRenderer(value: $value, in: 0...1)
            .pickerOrientation(.horizontal)
            .frame(height: 30)
    }
}

#Preview("Horizontal with Labels") {
    @Previewable @State var value = 0.5
    VStack {
        Text(String(format: "%.3f", value))
            .font(.body.monospacedDigit())
        FreeRulerRenderer(value: $value, in: 0...1)
            .pickerOrientation(.horizontal)
            .pickerRulerLabels(placement: .after) { index in
                Text(String(format: "%.1f", Double(index) / 10))
                    .font(.caption.bold().monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .frame(height: 30)
    }
}

#Preview("Vertical without Labels") {
    @Previewable @State var value = 0.5
    HStack {
        Text(String(format: "%.3f", value))
            .font(.body.monospacedDigit())
        FreeRulerRenderer(value: $value, in: 0...1)
            .pickerOrientation(.vertical)
            .frame(width: 30)
    }
}

#Preview("Vertical with Labels") {
    @Previewable @State var value = 0.5
    HStack {
        Text(String(format: "%.3f", value))
            .font(.body.monospacedDigit())
        FreeRulerRenderer(value: $value, in: 0...1)
            .pickerOrientation(.vertical)
            .pickerRulerLabels(placement: .after) { index in
                Text(String(format: "%.1f", Double(index) / 10))
                    .font(.caption.bold().monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .frame(width: 30)
    }
}
