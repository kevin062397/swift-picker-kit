//
//  PickerRulerTickAlignmentKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct PickerRulerTickAlignmentKey: EnvironmentKey {
    static let defaultValue: PickerRulerTickAlignment = .center
}

extension EnvironmentValues {
    var pickerRulerTickAlignment: PickerRulerTickAlignment {
        get {
            return self[PickerRulerTickAlignmentKey.self]
        }
        set {
            self[PickerRulerTickAlignmentKey.self] = newValue
        }
    }
}
