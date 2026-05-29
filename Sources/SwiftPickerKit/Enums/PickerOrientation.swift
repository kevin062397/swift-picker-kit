//
//  PickerOrientation.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

import SwiftUI

public enum PickerOrientation: Sendable {
    case horizontal
    case vertical

    var scrollAxis: Axis.Set {
        return self == .horizontal ? .horizontal : .vertical
    }
}
