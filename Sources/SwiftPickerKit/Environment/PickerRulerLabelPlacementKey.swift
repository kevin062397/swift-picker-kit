//
//  PickerRulerLabelPlacementKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct PickerRulerLabelPlacementKey: EnvironmentKey {
    static let defaultValue: PickerRulerLabelPlacement = .none
}

extension EnvironmentValues {
    var pickerRulerLabelPlacement: PickerRulerLabelPlacement {
        get {
            return self[PickerRulerLabelPlacementKey.self]
        }
        set {
            self[PickerRulerLabelPlacementKey.self] = newValue
        }
    }
}
