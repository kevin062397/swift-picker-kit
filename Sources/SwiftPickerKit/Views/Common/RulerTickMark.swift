//
//  RulerTickMark.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct RulerTickMark: View {
    @Environment(\.pickerRulerTickAlignment) private var alignment
    @Environment(\.pickerRulerTickStyle) private var tickStyle

    let isMajor: Bool
    let crossAxisSize: CGFloat
    let orientation: PickerOrientation
    var opacity: Double = 1

    var body: some View {
        let ratio = self.isMajor ? 1 : self.tickStyle.minorLengthRatio.clamped(0, 1)
        let tickLength = self.crossAxisSize * ratio
        let baseColor = self.isMajor ? self.tickStyle.majorColor : self.tickStyle.minorColor
        let color = baseColor.opacity(self.opacity)
        let lineWidth = self.tickStyle.lineWidth

        if self.orientation == .horizontal {
            ZStack(alignment: self.alignment == .trailing ? .bottom : (self.alignment == .leading ? .top : .center)) {
                Color.clear.frame(width: lineWidth, height: self.crossAxisSize)
                Rectangle()
                    .fill(color)
                    .frame(width: lineWidth, height: tickLength)
            }
        } else {
            ZStack(alignment: self.alignment == .trailing ? .trailing : (self.alignment == .leading ? .leading : .center)) {
                Color.clear.frame(width: self.crossAxisSize, height: lineWidth)
                Rectangle()
                    .fill(color)
                    .frame(width: tickLength, height: lineWidth)
            }
        }
    }
}
