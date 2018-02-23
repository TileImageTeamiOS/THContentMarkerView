//
//  THMarker.swift
//  THContentMarkerView
//
//  Created by Seong ho Hong on 2018. 2. 18..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

public struct THMarker {
    // MARK: - Properties

    // When tap 'THMarkerView' focus zoomScale
    public var zoomScale: CGFloat

    // 'THMarkerView' location origin
    public var origin: CGPoint

    // When tap 'THMarkerView', show content info
    public var contentInfo: [String: Any?]?
    public var markerID: String

    public init() {
        zoomScale = 0
        origin = CGPoint.zero
        contentInfo = [:]
        markerID = ""
    }

    public init(zoomScale: CGFloat, origin: CGPoint, markerID: String, contentInfo: [String: Any?]) {
        self.zoomScale = zoomScale
        self.origin = origin
        self.markerID = markerID
        self.contentInfo = contentInfo
    }
}
