//
//  PickerRulerLabelContentKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct PickerRulerLabelContent: @unchecked Sendable {
    let makeLabel: (Int) -> AnyView
}

struct PickerRulerLabelContentKey: EnvironmentKey {
    static let defaultValue: PickerRulerLabelContent? = nil
}

extension EnvironmentValues {
    var pickerRulerLabelContent: PickerRulerLabelContent? {
        get {
            return self[PickerRulerLabelContentKey.self]
        }
        set {
            self[PickerRulerLabelContentKey.self] = newValue
        }
    }
}
