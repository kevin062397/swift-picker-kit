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
                configuration.items[index].label
            }
        }
    }
}
