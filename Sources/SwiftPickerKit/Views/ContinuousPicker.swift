//
//  ContinuousPicker.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/29/26.
//

import SwiftUI

public struct ContinuousPicker: View {
    @Binding private var value: Double

    private let range: ClosedRange<Double>
    private let step: Double?

    public init(value: Binding<Double>, in range: ClosedRange<Double>, step: Double? = nil) {
        self._value = value
        self.range = range
        self.step = step
    }

    private var steppedValues: [Double] {
        guard let step = self.step, step > 0 else { return [] }
        let lower = self.range.lowerBound
        let upper = self.range.upperBound
        var result: [Double] = []
        var current = lower
        while current < upper - step * 0.0001 {
            result.append(current)
            current += step
        }
        result.append(upper)
        return result
    }

    private func nearestSteppedValue(to target: Double) -> Double {
        return self.steppedValues.min(by: { abs($0 - target) < abs($1 - target) }) ?? target
    }

    public var body: some View {
        let clamped = self.value.clamped(self.range.lowerBound, self.range.upperBound)

        if self.step != nil {
            // Stepped: snaps to discrete tick values
            let snappedValue = Binding<Double>(
                get: {
                    return self.nearestSteppedValue(to: clamped)
                },
                set: {
                    self.value = $0
                }
            )
            TickMarkRulerRenderer(selection: snappedValue, values: self.steppedValues)
        } else {
            // Step-less: free continuous drag, no snapping
            let continuousValue = Binding<Double>(
                get: {
                    return clamped
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
        ContinuousPicker(value: $value, in: 0...1, step: 0.1)
            .pickerDisplayStyle(.tickMarkRuler)
            .pickerOrientation(.horizontal)
            .frame(height: 30)
    }
}

#Preview("No Step") {
    @Previewable @State var value = 0.5
    VStack {
        Text(String(format: "%.3f", value))
            .font(.body.monospacedDigit())
        ContinuousPicker(value: $value, in: 0...1)
            .pickerDisplayStyle(.tickMarkRuler)
            .pickerOrientation(.horizontal)
            .frame(height: 30)
    }
}
