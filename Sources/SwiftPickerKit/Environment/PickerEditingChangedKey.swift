//
//  PickerEditingChangedKey.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/29/26.
//

import SwiftUI

struct PickerEditingChangedAction: @unchecked Sendable {
    let action: (Bool) -> Void

    func callAsFunction(_ isEditing: Bool) {
        self.action(isEditing)
    }
}

struct PickerEditingChangedKey: EnvironmentKey {
    static let defaultValue: PickerEditingChangedAction? = nil
}

extension EnvironmentValues {
    var pickerOnEditingChanged: PickerEditingChangedAction? {
        get {
            return self[PickerEditingChangedKey.self]
        }
        set {
            self[PickerEditingChangedKey.self] = newValue
        }
    }
}
