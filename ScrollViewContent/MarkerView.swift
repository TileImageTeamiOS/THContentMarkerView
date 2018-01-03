//
//  MarkerView.swift
//  ScrollViewMarker
//
//  Created by Seong ho Hong on 2018. 1. 1..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

class MarkerView: UIView {
    fileprivate var dataSource: MarkerViewDataSource!
    private var x = Double()
    private var y = Double()
    private var zoomScale = Double()
    
    private var positionX = Double()
    private var positionY = Double()
    private var ratioLength = Double()
    private var scaleLength = Double()
    
    private var markerTapGestureRecognizer = UITapGestureRecognizer()
    
    public func set(dataSource: MarkerViewDataSource, x: Double, y: Double) {
        NotificationCenter.default.addObserver(self, selector: #selector(frameSet),
                                               name: NSNotification.Name(rawValue: "scollViewAction"),
                                               object: nil)
        self.dataSource = dataSource
        self.x = x
        self.y = y
        dataSource.scrollView.addSubview(self)
        
        markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
        markerTapGestureRecognizer.delegate = self
        self.addGestureRecognizer(markerTapGestureRecognizer)
    }
    
    @objc private func frameSet() {
        positionX = x * dataSource.zoomScale
        positionY = y * dataSource.zoomScale
        ratioLength = dataSource.rationHeight > dataSource.ratioWidth ? dataSource.rationHeight : dataSource.ratioWidth
        scaleLength = dataSource.zoomScaleHeight > dataSource.zoomScaleWidth ? dataSource.zoomScaleHeight : dataSource.zoomScaleWidth

        
        if dataSource.zoomScale > 1.0 {
            self.frame = CGRect(x: positionX, y: positionY, width: scaleLength, height: scaleLength)
        } else {
            self.frame = CGRect(x: positionX, y: positionY, width: ratioLength, height: ratioLength)
        }
        
        self.backgroundColor = UIColor.red
    }
    
    func zoom(scale: CGFloat) {
        print(dataSource.ratioWidth)
        
        var destinationRect: CGRect = .zero
        destinationRect.size.width = dataSource.scrollView.frame.width/scale
        destinationRect.size.height = dataSource.scrollView.frame.height/scale
        destinationRect.origin.x = CGFloat(x - Double((self.dataSource.scrollView.frame.width/scale))/2)
        destinationRect.origin.y = CGFloat(y - Double((self.dataSource.scrollView.frame.height/scale))/2)
        
        
        UIView.animate(withDuration: 5.0, delay: 0.0, usingSpringWithDamping: 3.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
            self.dataSource.scrollView.zoom(to: destinationRect, animated: false)
        }, completion: {
            completed in
            if let delegate = self.dataSource.scrollView.delegate, delegate.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:))), let view = delegate.viewForZooming?(in: self.dataSource.scrollView) {
                delegate.scrollViewDidEndZooming!(self.dataSource.scrollView, with: view, atScale: 1.0)
            }
        })
    }
}

extension MarkerView: UIGestureRecognizerDelegate {
    @objc func markerViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        print("tap")
        zoom(scale: 1)
    }
}

