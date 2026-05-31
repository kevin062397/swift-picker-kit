//
//  PickerRulerTickAlignment.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

/// Controls which edge tick marks grow from within the ruler's cross-axis.
///
/// In horizontal orientation, the cross-axis is vertical (height).
/// In vertical orientation, the cross-axis is horizontal (width).
public enum PickerRulerTickAlignment: Sendable {
    /// Ticks grow from the top edge (horizontal) or leading edge (vertical).
    case leading

    /// Ticks are centered in the cross-axis. Default.
    case center

    /// Ticks grow from the bottom edge (horizontal) or trailing edge (vertical).
    case trailing
}
