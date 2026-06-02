//
//  RulerCenterIndicator.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct RulerCenterIndicator: View {
    @Environment(\.pickerRulerTickAlignment) private var tickAlignment
    @Environment(\.pickerRulerTickStyle) private var tickStyle

    let crossAxisSize: CGFloat
    let orientation: PickerOrientation

    var body: some View {
        let color = self.tickStyle.indicatorColor
        let lineWidth = self.tickStyle.indicatorLineWidth

        if self.orientation == .horizontal {
            VStack(spacing: 0) {
                if self.tickAlignment == .trailing {
                    Spacer(minLength: 0)
                }
                Rectangle()
                    .fill(color)
                    .frame(width: lineWidth, height: self.crossAxisSize)
                if self.tickAlignment == .leading {
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
        } else {
            HStack(spacing: 0) {
                if self.tickAlignment == .trailing {
                    Spacer(minLength: 0)
                }
                Rectangle()
                    .fill(color)
                    .frame(width: self.crossAxisSize, height: lineWidth)
                if self.tickAlignment == .leading {
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
        }
    }
}
