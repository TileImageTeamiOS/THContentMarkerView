//
//  THMarkerView.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 1. 30..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

open class THMarkerView: UIView {
    
    // MARK: - Properties
    private var scrollView = UIScrollView()
    private var zoomScale = CGFloat()
    private var origin = CGPoint()
    private var destinationRect = CGRect()
    
    /// marker has tap Gesture, and we implement tap event in `THMarkerView`
    private var markerTapGestureRecognizer = UITapGestureRecognizer()
    
    open weak var delegate: THMarkerViewDelegate?
    public var index = Int()

    // MARK: - Methods
    func set(origin: CGPoint, zoomScale: CGFloat, scrollView: UIScrollView){
        self.zoomScale = zoomScale
        self.scrollView = scrollView
        self.origin = origin
        
        frame.origin = origin
        scrollView.addSubview(self)
        markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
        markerTapGestureRecognizer.delegate = self
        self.addGestureRecognizer(markerTapGestureRecognizer)
        destinationRect.size.width = scrollView.frame.width/zoomScale
        destinationRect.size.height = scrollView.frame.height/zoomScale
        destinationRect.origin.x = self.origin.x - destinationRect.width/2
        destinationRect.origin.y = self.origin.y - destinationRect.height/2
    }
    
    func setImage(markerImage: UIImage){
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.image = markerImage
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFit
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
    
    func framSet() {
        // set when scrollview change, marker frame change
        self.frame = CGRect(x: self.origin.x * scrollView.zoomScale - frame.size.width/2, y: self.origin.y * scrollView.zoomScale - frame.size.height/2, width: frame.size.width, height: frame.size.height)
    }
    
    func zoom(duration: Double, delay: Double, initialSpringVelocity: CGFloat){
        scrollView.isMultipleTouchEnabled = false
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 2.0, initialSpringVelocity: initialSpringVelocity, options: [.allowUserInteraction], animations: {
            self.scrollView.zoom(to: self.destinationRect, animated: false)
        }, completion: {
            completed in
            self.scrollView.isMultipleTouchEnabled = true
            if let delegate = self.scrollView.delegate, delegate.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:))), let view = delegate.viewForZooming?(in: self.scrollView) {
                delegate.scrollViewDidEndZooming!(self.scrollView, with: view, atScale: 1.0)
            }
        })
    }
}

extension THMarkerView: UIGestureRecognizerDelegate {
    @objc func markerViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        // tap marker, scrollview zoom to destinatione rect
        zoom(duration: 3.0, delay: 0.0, initialSpringVelocity: 0.66)
        delegate?.tapEvent(marker: self)
    }
}

