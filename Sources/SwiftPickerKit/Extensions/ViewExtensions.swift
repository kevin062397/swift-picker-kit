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

    public func pickerTickMarkRulerStyle<S: PickerTickMarkRulerStyle>(_ style: S) -> some View {
        self.environment(\.pickerTickMarkRulerStyle, AnyPickerTickMarkRulerStyle(style))
    }

    public func pickerScrollWheelStyle<S: PickerScrollWheelStyle>(_ style: S) -> some View {
        self.environment(\.pickerScrollWheelStyle, AnyPickerScrollWheelStyle(style))
    }

    public func pickerOnEditingChanged(_ action: @escaping (Bool) -> Void) -> some View {
        self.environment(\.pickerOnEditingChanged, PickerEditingChangedAction(action: action))
    }

    public func pickerRulerTickAlignment(_ alignment: PickerRulerTickAlignment) -> some View {
        self.environment(\.pickerRulerTickAlignment, alignment)
    }

    public func pickerRulerLabels<Label: View>(placement: PickerRulerLabelPlacement = .after, @ViewBuilder label: @escaping (Int) -> Label) -> some View {
        self.environment(\.pickerRulerLabelPlacement, placement).environment(\.pickerRulerLabelContent, PickerRulerLabelContent(makeLabel: { AnyView(label($0)) }))
    }
    
    public func pickerRulerFadeMinOpacity(_ opacity: Double) -> some View {
        self.environment(\.pickerRulerFadeMinOpacity, opacity)
    }
    
    public func pickerRulerFadePlateau(_ plateau: CGFloat) -> some View {
        self.environment(\.pickerRulerFadePlateau, plateau)
    }

    public func pickerRulerFadeStrength(_ strength: CGFloat) -> some View {
        self.environment(\.pickerRulerFadeStrength, strength)
    }
}
