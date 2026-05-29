//
//  PickerStyleKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

struct PickerStyleKey: EnvironmentKey {
    static let defaultValue: PickerDisplayStyle = .scrollWheel
}

extension EnvironmentValues {
    var pickerDisplayStyle: PickerDisplayStyle {
        get {
            return self[PickerStyleKey.self]
        }
        set {
            self[PickerStyleKey.self] = newValue
        }
    }
}
