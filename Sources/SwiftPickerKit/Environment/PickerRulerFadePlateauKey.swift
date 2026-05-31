//
//  PickerRulerFadePlateauKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct PickerRulerFadePlateauKey: EnvironmentKey {
    /// Fraction of the half-view size within which opacity is always 1.0.
    /// 0.0 = fade starts immediately from center.
    /// 0.5 = central 50% of the half-view is fully opaque before fading begins. Default.
    /// 1.0 = the entire view is fully opaque; effectively disables fading regardless of fade strength.
    static let defaultValue: CGFloat = 0.5
}

extension EnvironmentValues {
    var pickerRulerFadePlateau: CGFloat {
        get {
            return self[PickerRulerFadePlateauKey.self]
        }
        set {
            self[PickerRulerFadePlateauKey.self] = newValue
        }
    }
}
