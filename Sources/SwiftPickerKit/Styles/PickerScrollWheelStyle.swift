//
//  PickerScrollWheelStyle.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

public struct PickerScrollWheelStyleConfiguration {
    public struct Item {
        public let label: AnyView
        public let isSelected: Bool
        /// Fractional distance from the centered position. 0 = centered, ±1 = one item away.
        /// Updates continuously during drag for real-time visual feedback.
        public let distanceFromCenter: CGFloat
    }

    public let items: [Item]
}

public protocol PickerScrollWheelStyle {
    associatedtype Body: View
    @ViewBuilder func makeBody(configuration: PickerScrollWheelStyleConfiguration) -> Body
}
