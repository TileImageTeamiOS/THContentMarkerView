//
//  THMarkerView.swift
//  THContentMarkerView
//
//  Created by Seong ho Hong on 2018. 2. 18..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

public class THMarkerView: UIView {
    open var index: Int = 0
    weak var delegate: THMarkerViewDelegate?
    /// destinationRect is when tap 'THMarkerView', the focus rect
    open var destinationRect: CGRect = .zero
    open var marker: THMarker = THMarker()
    
    // MARK: - Initializers
    convenience init(marker: THMarker, index: Int) {
        self.init()
        self.marker = marker
        self.index = index
    }
    
    func setMarker(scrollView: UIScrollView) {
        let markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
        self.addGestureRecognizer(markerTapGestureRecognizer)
        
        /// set destinationRect
        self.destinationRect.size.width = scrollView.frame.width/marker.zoomScale
        self.destinationRect.size.height = scrollView.frame.height/marker.zoomScale
        self.destinationRect.origin.x = marker.origin.x - destinationRect.width/2
        self.destinationRect.origin.y = marker.origin.y - destinationRect.height/2
    }
    
    /// for markerViewTap delegate
    @objc func markerViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.tapEvent(markerView: self)
    }
}

public protocol THMarkerViewDelegate: AnyObject {
    func tapEvent(markerView: THMarkerView)
}

