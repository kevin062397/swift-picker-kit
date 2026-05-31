//
//  PickerDisplayStyle.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

/// The visual style used to render a picker control.
public enum PickerDisplayStyle: Sendable {
    /// A scrollable wheel of discrete labeled items. Items near the center are
    /// emphasised; items further away fade out toward the edges.
    case scrollWheel

    /// A scrollable ruler of tick marks with a fixed center indicator.
    /// Major ticks are taller than minor ticks. Suitable for both discrete
    /// stepped values and continuous ranges.
    case tickMarkRuler
}
