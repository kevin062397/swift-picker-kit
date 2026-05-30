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
    @Environment(\.pickerOrientation) private var orientation
    @Environment(\.pickerTickMarkRulerStyle) private var customStyle
    @Environment(\.pickerHapticsMode) private var hapticsMode
    @Environment(\.pickerOnEditingChanged) private var onEditingChanged

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

            self.tickScale(proxy: proxy)
                .offset(
                    x: self.orientation == .horizontal ? dragOffset : 0,
                    y: self.orientation == .vertical ? dragOffset : 0
                )
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
        .clipped()
        .overlay(self.centerIndicator)
        .onChange(of: self.value) { _, newValue in
            if !self.isDragging {
                self.startValue = newValue
            }
        }
    }

    @ViewBuilder
    private func tickScale(proxy: GeometryProxy) -> some View {
        let crossAxisSize = self.orientation == .horizontal ? proxy.size.height : proxy.size.width
        if self.orientation == .horizontal {
            HStack(spacing: self.tickSpacing - 1) {
                ForEach(0..<self.tickCount, id: \.self) { index in
                    self.tickMark(index: index, crossAxisSize: crossAxisSize)
                }
            }
        } else {
            VStack(spacing: self.tickSpacing - 1) {
                ForEach(0..<self.tickCount, id: \.self) { index in
                    self.tickMark(index: index, crossAxisSize: crossAxisSize)
                }
            }
        }
    }

    @ViewBuilder
    private func tickMark(index: Int, crossAxisSize: CGFloat) -> some View {
        let isMajor = index % self.majorTickEvery == 0
        let majorLength: CGFloat = crossAxisSize * 0.7
        let minorLength: CGFloat = crossAxisSize * 0.4
        let tickLength = isMajor ? majorLength : minorLength

        if self.orientation == .horizontal {
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                Rectangle()
                    .fill(isMajor ? Color.primary.opacity(0.6) : Color.primary.opacity(0.25))
                    .frame(width: 1, height: tickLength)
            }
            .frame(width: 1, height: crossAxisSize)
        } else {
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Rectangle()
                    .fill(isMajor ? Color.primary.opacity(0.6) : Color.primary.opacity(0.25))
                    .frame(width: tickLength, height: 1)
            }
            .frame(width: crossAxisSize, height: 1)
        }
    }

    private var centerIndicator: some View {
        Group {
            if self.orientation == .horizontal {
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: 2)
            } else {
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(height: 2)
            }
        }
        .allowsHitTesting(false)
    }

    private func offset(for value: Double) -> CGFloat {
        guard self.span > 0 else { return 0 }
        let normalized = (value - self.range.lowerBound) / self.span
        return CGFloat(normalized) * self.totalLength
    }
}

#Preview("Horizontal") {
    @Previewable @State var value = 0.5
    VStack {
        Text(value.formatted(.percent))
            .font(.body.monospacedDigit())
        FreeRulerRenderer(value: $value, in: 0...1)
            .pickerOrientation(.horizontal)
    }
}

#Preview("Vertical") {
    @Previewable @State var value = 0.5
    HStack {
        Text(value.formatted(.percent))
            .font(.body.monospacedDigit())
        FreeRulerRenderer(value: $value, in: 0...1)
            .pickerOrientation(.vertical)
    }
}
