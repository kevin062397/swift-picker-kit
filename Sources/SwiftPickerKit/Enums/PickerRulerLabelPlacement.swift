//
//  PickerRulerLabelPlacement.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

public enum PickerRulerLabelPlacement: Sendable {
    /// No labels (default).
    case none
    /// Labels on the opposite side from the tick marks.
    /// Above ticks in horizontal orientation; leading of ticks in vertical orientation.
    case before
    /// Labels on the same side as the tick marks.
    /// Below ticks in horizontal orientation; trailing of ticks in vertical orientation.
    case after
}
