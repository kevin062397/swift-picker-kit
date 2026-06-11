//
//  PickerRulerTickStyleKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 6/2/26.
//

import SwiftUI

/// Visual appearance configuration for ruler tick marks and the center indicator.
public struct PickerRulerTickStyle: Sendable {
    /// The color of major tick marks.
    public var majorColor: Color
    /// The color of minor tick marks.
    public var minorColor: Color
    /// The line width of all tick marks in points.
    public var lineWidth: CGFloat
    /// The length of minor ticks as a fraction of the full cross-axis size. Must be in `0...1`.
    public var minorLengthRatio: CGFloat
    /// The color of the center indicator line.
    public var indicatorColor: Color
    /// The line width of the center indicator in points.
    public var indicatorLineWidth: CGFloat

    /// Creates a tick style configuration.
    /// - Parameter majorColor: Color of major tick marks. Default is `Color.primary.opacity(0.5)`.
    /// - Parameter minorColor: Color of minor tick marks. Default is `Color.primary.opacity(0.25)`.
    /// - Parameter lineWidth: Width of all tick marks in points. Default is `1`.
    /// - Parameter minorLengthRatio: Length of minor ticks as a fraction of the cross-axis size.
    ///   Default is `2/3`. Must be in `0...1`.
    /// - Parameter indicatorColor: Color of the center indicator line. Default is `Color.accentColor`.
    /// - Parameter indicatorLineWidth: Width of the center indicator line in points. Default is `3`.
    public init(
        majorColor: Color = Color.primary.opacity(0.5),
        minorColor: Color = Color.primary.opacity(0.25),
        lineWidth: CGFloat = 1.0,
        minorLengthRatio: CGFloat = 2.0 / 3.0,
        indicatorColor: Color = Color.accentColor,
        indicatorLineWidth: CGFloat = 3.0
    ) {
        self.majorColor = majorColor
        self.minorColor = minorColor
        self.lineWidth = lineWidth
        self.minorLengthRatio = minorLengthRatio
        self.indicatorColor = indicatorColor
        self.indicatorLineWidth = indicatorLineWidth
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
