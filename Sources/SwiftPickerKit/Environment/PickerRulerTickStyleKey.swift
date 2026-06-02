//
//  PickerRulerTickStyleKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 6/2/26.
//

import SwiftUI

/// Visual appearance configuration for ruler tick marks.
public struct PickerRulerTickStyle: Sendable {
    /// The color of major tick marks.
    public var majorColor: Color
    /// The color of minor tick marks.
    public var minorColor: Color
    /// The line width of all tick marks in points.
    public var lineWidth: CGFloat
    /// The length of minor ticks as a fraction of the full cross-axis size. Must be in `0...1`.
    public var minorLengthRatio: CGFloat

    /// Creates a tick style configuration.
    /// - Parameter majorColor: Color of major tick marks. Default is `Color.primary.opacity(0.5)`.
    /// - Parameter minorColor: Color of minor tick marks. Default is `Color.primary.opacity(0.25)`.
    /// - Parameter lineWidth: Width of all tick marks in points. Default is `1`.
    /// - Parameter minorLengthRatio: Length of minor ticks as a fraction of the cross-axis size.
    ///   Default is `2/3`. Must be in `0...1`.
    public init(
        majorColor: Color = Color.primary.opacity(0.5),
        minorColor: Color = Color.primary.opacity(0.25),
        lineWidth: CGFloat = 1,
        minorLengthRatio: CGFloat = 2 / 3
    ) {
        self.majorColor = majorColor
        self.minorColor = minorColor
        self.lineWidth = lineWidth
        self.minorLengthRatio = minorLengthRatio
    }
}

struct PickerRulerTickStyleKey: EnvironmentKey {
    static let defaultValue = PickerRulerTickStyle()
}

extension EnvironmentValues {
    var pickerRulerTickStyle: PickerRulerTickStyle {
        get {
            return self[PickerRulerTickStyleKey.self]
        }
        set {
            self[PickerRulerTickStyleKey.self] = newValue
        }
    }
}
