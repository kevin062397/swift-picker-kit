//
//  PickerOrientationKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

struct PickerOrientationKey: EnvironmentKey {
    static let defaultValue: PickerOrientation = .horizontal
}

extension EnvironmentValues {
    var pickerOrientation: PickerOrientation {
        get {
            return self[PickerOrientationKey.self]
        }
        set {
            self[PickerOrientationKey.self] = newValue
        }
    }
}
