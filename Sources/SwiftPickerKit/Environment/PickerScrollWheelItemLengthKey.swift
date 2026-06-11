//
//  PickerScrollWheelItemLengthKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/31/26.
//

import SwiftUI

struct PickerScrollWheelItemLengthKey: EnvironmentKey {
    /// The length of each item cell along the scroll axis, in points. Default is 60.
    static let defaultValue: CGFloat = 60.0
}

extension EnvironmentValues {
    var pickerScrollWheelItemLength: CGFloat {
        get {
            return self[PickerScrollWheelItemLengthKey.self]
        }
        set {
            self[PickerScrollWheelItemLengthKey.self] = newValue
        }
    }
}
