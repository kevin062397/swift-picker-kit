//
//  PickerHapticsMode.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

/// Controls whether a picker produces haptic feedback when its value changes.
public enum PickerHapticsMode: Sendable {
    /// No haptic feedback is produced.
    case disabled

    /// A selection-style haptic is produced on each value change.
    /// Uses `UISelectionFeedbackGenerator` on iOS.
    case enabled
}
