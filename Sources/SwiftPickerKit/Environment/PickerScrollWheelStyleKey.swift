//
//  PickerScrollWheelStyleKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

struct AnyPickerScrollWheelStyle: @unchecked Sendable {
    private let _makeBody: (PickerScrollWheelStyleConfiguration) -> AnyView

    init<S: PickerScrollWheelStyle>(_ style: S) {
        self._makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: PickerScrollWheelStyleConfiguration) -> AnyView {
        self._makeBody(configuration)
    }
}

struct PickerScrollWheelStyleKey: EnvironmentKey {
    static let defaultValue: AnyPickerScrollWheelStyle? = nil
}

extension EnvironmentValues {
    var pickerScrollWheelStyle: AnyPickerScrollWheelStyle? {
        get {
            return self[PickerScrollWheelStyleKey.self]
        }
        set {
            self[PickerScrollWheelStyleKey.self] = newValue
        }
    }
}
