//
//  DefaultScrollWheelStyle.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/29/26.
//

import SwiftUI

struct DefaultScrollWheelStyle: PickerScrollWheelStyle {
    func makeBody(configuration: PickerScrollWheelStyleConfiguration) -> some View {
        HStack(spacing: 0) {
            ForEach(configuration.items.indices, id: \.self) { index in
                let item = configuration.items[index]
                let (scale, opacity) = self.emphasis(distanceFromCenter: item.distanceFromCenter)
                item.label
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
        }
    }

    private func emphasis(distanceFromCenter: CGFloat) -> (scale: CGFloat, opacity: Double) {
        let d = abs(distanceFromCenter)
        let scale = max(0.6, 1 - d * 0.15)
        let opacity = max(0.2, 1 - d * 0.4)
        return (CGFloat(scale), Double(opacity))
    }
}
