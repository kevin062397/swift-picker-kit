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
    @Environment(\.pickerTickMarkRulerStyle) private var customStyle

    @GestureState private var dragTranslation: CGFloat = 0

    @State private var baseIndex: Int = 0
    @State private var isDragging = false

    @Binding var selection: Value

    let values: [Value]
    /// Distance between tick centers in points.
    var tickSpacing: CGFloat = 10
    var majorTickEvery: Int = 10

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

            self.tickContent(proxy: proxy)
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
                            let offset = state / self.tickSpacing
                            let newIndex = (CGFloat(self.baseIndex) - offset).rounded()
                            let clamped = Int(min(max(newIndex, 0), CGFloat(self.tickCount - 1)))
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
                            let clamped = Int(min(max(newIndex, 0), CGFloat(tickCount - 1)))
                            self.selection = self.values[clamped]
                            self.baseIndex = clamped
                            self.isDragging = false
                            self.onEditingChanged?(false)
                        }
                )
        }
        .clipped()
        .overlay(self.centerIndicator)
        .onAppear {
            self.baseIndex = self.selectedIndex
        }
        .onChange(of: self.selection) { _, _ in
            if !self.isDragging {
                self.baseIndex = self.selectedIndex
            }
            #if canImport(UIKit)
                if case .enabled(let style) = hapticsMode {
                    FeedbackGenerator.impact(style)
                }
            #endif
        }
    }

    @ViewBuilder
    private func tickContent(proxy: GeometryProxy) -> some View {
        if let customStyle {
            customStyle.makeBody(
                configuration: PickerTickMarkRulerStyleConfiguration(
                    scale: AnyView(self.tickScale(proxy: proxy)),
                    indicator: AnyView(self.centerIndicator),
                    currentValue: Double(self.selectedIndex),
                    range: 0...Double(self.tickCount - 1)
                )
            )
        } else {
            self.tickScale(proxy: proxy)
        }
    }

    @ViewBuilder
    private func tickScale(proxy: GeometryProxy) -> some View {
        if self.orientation == .horizontal {
            HStack(spacing: self.tickSpacing - 1) {
                ForEach(0..<self.tickCount, id: \.self) { index in
                    self.tickMark(index: index, crossAxisSize: proxy.size.height)
                }
            }
        } else {
            VStack(spacing: self.tickSpacing - 1) {
                ForEach(0..<self.tickCount, id: \.self) { index in
                    self.tickMark(index: index, crossAxisSize: proxy.size.width)
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
}

#Preview("Horizontal") {
    @Previewable @State var selected = 10
    let values = Array(0..<100)
    VStack {
        Text("\(selected)")
            .font(.body.monospacedDigit())
        TickMarkRulerRenderer(selection: $selected, values: values, tickSpacing: 10)
            .pickerOrientation(.horizontal)
    }
}

#Preview("Vertical") {
    @Previewable @State var selected = 10
    let values = Array(0..<100)
    HStack {
        Text("\(selected)")
            .font(.body.monospacedDigit())
        TickMarkRulerRenderer(selection: $selected, values: values, tickSpacing: 10)
            .pickerOrientation(.vertical)
    }
}
