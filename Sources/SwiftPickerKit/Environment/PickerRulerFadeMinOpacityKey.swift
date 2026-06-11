//
//  PickerRulerFadeMinOpacityKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

import SwiftUI

struct PickerRulerFadeMinOpacityKey: EnvironmentKey {
    /// The minimum opacity applied to tick marks and labels at the edges of the view.
    /// 0.0 = fully transparent at the edge. Default.
    /// 1.0 = no fading effect regardless of fade strength.
    static let defaultValue: Double = 0.0
}

extension EnvironmentValues {
    var pickerRulerFadeMinOpacity: Double {
        get {
            return self[PickerRulerFadeMinOpacityKey.self]
        }
        set {
            self[PickerRulerFadeMinOpacityKey.self] = newValue
        }
    }
}
