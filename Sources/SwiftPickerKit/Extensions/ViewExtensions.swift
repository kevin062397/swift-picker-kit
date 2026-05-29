//
//  ViewExtensions.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

extension View {
    public func pickerDisplayStyle(_ displayStyle: PickerDisplayStyle) -> some View {
        self.environment(\.pickerDisplayStyle, displayStyle)
    }

    public func pickerOrientation(_ orientation: PickerOrientation) -> some View {
        self.environment(\.pickerOrientation, orientation)
    }

    public func pickerHapticsMode(_ hapticsMode: PickerHapticsMode) -> some View {
        self.environment(\.pickerHapticsMode, hapticsMode)
    }
}
