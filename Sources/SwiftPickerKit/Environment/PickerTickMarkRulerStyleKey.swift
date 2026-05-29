//
//  PickerTickMarkRulerStyleKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

struct AnyPickerTickMarkRulerStyle: @unchecked Sendable {
    private let _makeBody: (PickerTickMarkRulerStyleConfiguration) -> AnyView

    init<S: PickerTickMarkRulerStyle>(_ style: S) {
        self._makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: PickerTickMarkRulerStyleConfiguration) -> AnyView {
        self._makeBody(configuration)
    }
}

struct PickerTickMarkRulerStyleKey: EnvironmentKey {
    static let defaultValue: AnyPickerTickMarkRulerStyle? = nil
}

extension EnvironmentValues {
    var pickerTickMarkRulerStyle: AnyPickerTickMarkRulerStyle? {
        get {
            return self[PickerTickMarkRulerStyleKey.self]
        }
        set {
            self[PickerTickMarkRulerStyleKey.self] = newValue
        }
    }
}
