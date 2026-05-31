//
//  PickerRulerTickAlignment.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

public enum PickerRulerTickAlignment: Sendable {
    /// Ticks grow from the top edge (horizontal) or leading edge (vertical).
    case leading
    /// Ticks are centered in the cross-axis. Default.
    case center
    /// Ticks grow from the bottom edge (horizontal) or trailing edge (vertical).
    case trailing
}
