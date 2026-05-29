//
//  PickerHapticsKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

struct PickerHapticsKey: EnvironmentKey {
    static let defaultValue: PickerHapticsMode = .disabled
}

extension EnvironmentValues {
    var pickerHapticsMode: PickerHapticsMode {
        get {
            return self[PickerHapticsKey.self]
        }
        set {
            self[PickerHapticsKey.self] = newValue
        }
    }
}
