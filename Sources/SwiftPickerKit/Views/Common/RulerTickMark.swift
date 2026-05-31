//
//  RulerTickMark.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct RulerTickMark: View {
    let isMajor: Bool
    let crossAxisSize: CGFloat
    let orientation: PickerOrientation

    var body: some View {
        let majorLength: CGFloat = self.crossAxisSize
        let minorLength: CGFloat = self.crossAxisSize * 2 / 3
        let tickLength = self.isMajor ? majorLength : minorLength
        let color: Color = self.isMajor ? Color.primary.opacity(0.5) : Color.primary.opacity(0.25)

        if self.orientation == .horizontal {
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                Rectangle()
                    .fill(color)
                    .frame(width: 1, height: tickLength)
            }
            .frame(width: 1, height: self.crossAxisSize)
        } else {
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Rectangle()
                    .fill(color)
                    .frame(width: tickLength, height: 1)
            }
            .frame(width: self.crossAxisSize, height: 1)
        }
    }
}
