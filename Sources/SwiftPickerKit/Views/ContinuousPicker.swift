//
//  ContinuousPicker.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/29/26.
//

import SwiftUI

/// A picker that selects a floating-point value within a continuous range.
///
/// `Value` may be any `BinaryFloatingPoint` type — `Double`, `Float`,
/// `CGFloat`, and so on. The concrete type is inferred from the `value` binding.
///
/// When a `step` is provided, the picker snaps to discrete tick marks spaced by
/// that step value. Without a step, the ruler scrolls freely and the value updates
/// proportionally to position with no snapping.
///
/// ```swift
/// // Stepped — snaps to 0.0, 0.05, 0.10, …, 1.0
/// ContinuousPicker(value: $volume, in: 0.0...1.0, step: 0.05)
///
/// // Step-less — value updates continuously as the user drags
/// ContinuousPicker(value: $position, in: 0.0...1.0)
/// ```
public struct ContinuousPicker<Value: BinaryFloatingPoint>: View {
    @Binding private var value: Value

    private let range: ClosedRange<Value>
    private let step: Value?

    /// Creates a continuous picker.
    /// - Parameter value: A binding to the selected value. Values outside `range` are clamped.
    /// - Parameter range: The valid range of values.
    /// - Parameter step: The distance between snappable values. Pass `nil` (default) for free continuous drag.
    public init(value: Binding<Value>, in range: ClosedRange<Value>, step: Value? = nil) {
        self._value = value
        self.range = range
        self.step = step
    }

    private var steppedValues: [Value] {
        guard let step = self.step, step > 0.0 else { return [] }
        let lower = self.range.lowerBound
        let upper = self.range.upperBound
        var result: [Value] = []
        var current = lower
        while current < upper - step * 0.0001 {
            result.append(current)
            current += step
        }
        result.append(upper)
        return result
    }

    private func nearestSteppedValue(to target: Value) -> Value {
        return self.steppedValues.min(by: { abs($0 - target) < abs($1 - target) }) ?? target
    }

    public var body: some View {
        let clamped = self.value.clamped(self.range.lowerBound, self.range.upperBound)

        if self.step != nil {
            // Stepped: snaps to discrete tick values
            let snappedValue = Binding<Value>(
                get: {
                    self.nearestSteppedValue(to: clamped)
                },
                set: {
                    self.value = $0
                }
            )
            TickMarkRulerRenderer(selection: snappedValue, values: self.steppedValues)
        } else {
            // Step-less: free continuous drag, no snapping
            let continuousValue = Binding<Value>(
                get: {
                    clamped
                },
                set: {
                    self.value = $0
                }
            )
            FreeRulerRenderer(value: continuousValue, in: self.range)
        }
    }
}

// MARK: - Previews

#Preview("With Step") {
    @Previewable @State var value = 0.5
    VStack {
        Text(String(format: "%.3f", value))
            .font(.body.monospacedDigit())
        ContinuousPicker(value: $value, in: 0.0...1.0, step: 0.1)
            .pickerOrientation(.horizontal)
            .frame(height: 30.0)
    }
}

#Preview("No Step") {
    @Previewable @State var value = 0.5
    VStack {
        Text(String(format: "%.3f", value))
            .font(.body.monospacedDigit())
        ContinuousPicker(value: $value, in: 0.0...1.0)
            .pickerOrientation(.horizontal)
            .frame(height: 30.0)
    }
}
