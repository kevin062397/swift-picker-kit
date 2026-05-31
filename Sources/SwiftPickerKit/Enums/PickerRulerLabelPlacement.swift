//
//  PickerRulerLabelPlacement.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/30/26.
//

/// Controls where text labels are rendered relative to major tick marks on a ruler picker.
public enum PickerRulerLabelPlacement: Sendable {
    /// No labels are rendered. Default.
    case none

    /// Labels appear on the side opposite to the tick growth direction.
    /// Above the tick area in horizontal orientation; to the leading side in vertical orientation.
    case before

    /// Labels appear on the same side as the tick growth direction.
    /// Below the tick area in horizontal orientation; to the trailing side in vertical orientation.
    case after
}
