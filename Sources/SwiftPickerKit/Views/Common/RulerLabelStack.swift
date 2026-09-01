//
//  RulerLabelStack.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct RulerLabelStack: View {
    @Environment(\.pickerOrientation) private var orientation
    @Environment(\.pickerRulerLabelPlacement) private var labelPlacement

    let crossAxisSize: CGFloat
    let tickCount: Int
    let tickSpacing: CGFloat
    let majorTickEvery: Int
    let labelContent: PickerRulerLabelContent
    var opacities: [Double] = []

    var body: some View {
        let gap: CGFloat = 5.0
        let crossOffset: CGFloat =
            self.labelPlacement == .after ? self.crossAxisSize + gap : -(self.crossAxisSize + gap)

        if self.orientation == .horizontal {
            HStack(spacing: self.tickSpacing - 1.0) {
                ForEach(0..<self.tickCount, id: \.self) { index in
                    Color.clear
                        .frame(width: 1.0, height: self.crossAxisSize)
                        .overlay(alignment: self.labelPlacement == .after ? .top : .bottom) {
                            if index % self.majorTickEvery == 0 {
                                self.labelContent.makeLabel(index)
                                    .fixedSize()
                                    .offset(y: crossOffset)
                                    .opacity(self.opacities.indices.contains(index) ? self.opacities[index] : 1.0)
                            }
                        }
                }
            }
            .allowsHitTesting(false)
        } else {
            VStack(spacing: self.tickSpacing - 1.0) {
                ForEach(0..<self.tickCount, id: \.self) { index in
                    Color.clear
                        .frame(width: self.crossAxisSize, height: 1.0)
                        .overlay(alignment: self.labelPlacement == .after ? .leading : .trailing) {
                            if index % self.majorTickEvery == 0 {
                                self.labelContent.makeLabel(index)
                                    .fixedSize()
                                    .offset(x: crossOffset)
                                    .opacity(self.opacities.indices.contains(index) ? self.opacities[index] : 1.0)
                            }
                        }
                }
            }
            .allowsHitTesting(false)
        }
    }
}
