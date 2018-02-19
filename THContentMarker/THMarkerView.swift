//
//  THMarkerView.swift
//  THContentMarkerView
//
//  Created by Seong ho Hong on 2018. 2. 18..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

public class THMarkerView: UIView {
    /// Origin is 'THMarkerView' location
    open var origin: CGPoint = .zero
    /// zoomScale is when tap 'THMarkerView', the focus zoomScale
    open var zoomScale: CGFloat = 0.0
    open var index: Int = 0
    weak var delegate: THMarkerViewDelegate?
    /// destinationRect is when tap 'THMarkerView', the focus rect
    open var destinationRect: CGRect = .zero

    // MARK: - Initializers
    convenience init(origin: CGPoint, zoomScale: CGFloat = 0.0, index: Int = 0) {
        self.init()
        self.origin = origin
        self.zoomScale = zoomScale
        self.index = index
    }

    func setMarker(scrollView: UIScrollView) {
        let markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
        self.addGestureRecognizer(markerTapGestureRecognizer)

        /// set destinationRect
        self.destinationRect.size.width = scrollView.frame.width/zoomScale
        self.destinationRect.size.height = scrollView.frame.height/zoomScale
        self.destinationRect.origin.x = self.origin.x - destinationRect.width/2
        self.destinationRect.origin.y = self.origin.y - destinationRect.height/2
    }

    /// for markerViewTap delegate
    @objc func markerViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.tapEvent(marker: self)
    }
}

public protocol THMarkerViewDelegate: AnyObject {
    func tapEvent(marker: THMarkerView)
}
