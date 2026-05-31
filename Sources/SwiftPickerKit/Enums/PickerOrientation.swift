//
//  PickerOrientation.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

/// The scroll axis of a picker control.
public enum PickerOrientation: Sendable {
    /// Items scroll left and right.
    case horizontal

    /// Items scroll up and down.
    case vertical

    var scrollAxis: Axis.Set {
        return self == .horizontal ? .horizontal : .vertical
    }
}
