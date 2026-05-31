//
//  PickerRulerFadeStrengthKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct PickerRulerFadeStrengthKey: EnvironmentKey {
    /// How aggressively tick marks and labels fade out toward the edges of the view.
    /// 0.0 = no fading; all ticks are fully opaque.
    /// 1.0 = full fade; ticks at the edge reach minimum opacity. Default.
    /// Values above 1.0 cause ticks to reach minimum opacity before the edge.
    static let defaultValue: CGFloat = 1
}

extension EnvironmentValues {
    var pickerRulerFadeStrength: CGFloat {
        get {
            return self[PickerRulerFadeStrengthKey.self]
        }
        set {
            self[PickerRulerFadeStrengthKey.self] = newValue
        }
    }
}
