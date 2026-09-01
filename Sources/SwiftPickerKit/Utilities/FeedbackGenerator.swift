//
//  FeedbackGenerator.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/28/26.
//

#if canImport(UIKit)
    import UIKit

    enum FeedbackGenerator {
        @MainActor
        static func impactOccurred(
            _ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle,
            intensity: CGFloat? = nil,
            at location: CGPoint? = nil
        ) {
            let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
            generator.prepare()
            if let intensity = intensity, let location = location {
                if #available(iOS 17.5, *) {
                    generator.impactOccurred(intensity: intensity, at: location)
                } else {
                    generator.impactOccurred(intensity: intensity)
                }
            } else if let intensity = intensity {
                generator.impactOccurred(intensity: intensity)
            } else if let location = location {
                if #available(iOS 17.5, *) {
                    generator.impactOccurred(at: location)
                } else {
                    generator.impactOccurred()
                }
            } else {
                generator.impactOccurred()
            }
        }

        @MainActor
        static func notificationOccurred(
            _ feedbackType: UINotificationFeedbackGenerator.FeedbackType,
            at location: CGPoint? = nil
        ) {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            if let location = location {
                if #available(iOS 17.5, *) {
                    generator.notificationOccurred(feedbackType, at: location)
                } else {
                    generator.notificationOccurred(feedbackType)
                }
            } else {
                generator.notificationOccurred(feedbackType)
            }
        }

        @MainActor
        static func selectionChanged(at location: CGPoint? = nil) {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            if let location = location {
                if #available(iOS 17.5, *) {
                    generator.selectionChanged(at: location)
                } else {
                    generator.selectionChanged()
                }
            } else {
                generator.selectionChanged()
            }
        }
    }
#endif
