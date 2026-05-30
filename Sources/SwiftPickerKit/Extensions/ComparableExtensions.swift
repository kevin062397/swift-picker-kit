//
//  ComparableExtensions.swift
//  SwiftPickerKit
//
//  Created by Haoyuan Xia on 5/29/26.
//

extension Comparable {
    func clamped(_ lower: Self, _ upper: Self) -> Self {
        return min(max(self, lower), upper)
    }
}
