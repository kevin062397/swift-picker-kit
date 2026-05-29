//
//  PickerHapticsMode.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

#if canImport(UIKit)
    import UIKit

    public enum PickerHapticsMode: Sendable {
        case enabled(UIImpactFeedbackGenerator.FeedbackStyle = .light)
        case disabled
    }
#else
    public enum PickerHapticsMode: Sendable {
        case disabled
    }
#endif
