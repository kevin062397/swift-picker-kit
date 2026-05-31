//
//  RulerCenterIndicator.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct RulerCenterIndicator: View {
    @Environment(\.pickerRulerTickAlignment) private var alignment

    let crossAxisSize: CGFloat
    let orientation: PickerOrientation

    var body: some View {
        if self.orientation == .horizontal {
            VStack(spacing: 0) {
                if self.alignment == .trailing {
                    Spacer(minLength: 0)
                }
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: 3, height: self.crossAxisSize)
                if self.alignment == .leading {
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
        } else {
            HStack(spacing: 0) {
                if self.alignment == .trailing {
                    Spacer(minLength: 0)
                }
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: self.crossAxisSize, height: 3)
                if self.alignment == .leading {
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
        }
    }
}
