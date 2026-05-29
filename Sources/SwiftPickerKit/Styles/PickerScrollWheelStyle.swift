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
        public let distanceFromCenter: Int
    }

    public let items: [Item]
}

public protocol PickerScrollWheelStyle {
    associatedtype Body: View
    @ViewBuilder func makeBody(configuration: PickerScrollWheelStyleConfiguration) -> Body
}
