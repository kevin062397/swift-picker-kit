//
//  PickerTickMarkRulerStyle.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

public struct PickerTickMarkRulerStyleConfiguration {
    public let scale: AnyView
    public let indicator: AnyView
    public let currentValue: Double
    public let range: ClosedRange<Double>
}

public protocol PickerTickMarkRulerStyle {
    associatedtype Body: View
    @ViewBuilder func makeBody(configuration: PickerTickMarkRulerStyleConfiguration) -> Body
}
