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
    
    private var isAudioContent = false
    private var isVideoContent = false
    
    private var touchEnable = true
    private var imageView : UIImageView!
    
    public func initial(){
        dataSource.audioContentView?.isHidden = true
        dataSource.videoContentView?.isHidden = true

    }
    public func set(dataSource: MarkerViewDataSource, x: Double, y: Double, zoomScale: Double, isAudioContent: Bool, isVideoContent: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(frameSet),
                                               name: NSNotification.Name(rawValue: "scollViewAction"),
                                               object: nil)
        self.dataSource = dataSource
        self.x = x
        self.y = y
        self.zoomScale = zoomScale
        dataSource.scrollView.addSubview(self)
        
        markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
        markerTapGestureRecognizer.delegate = self
        self.addGestureRecognizer(markerTapGestureRecognizer)
        
        // audio 세팅
        self.isAudioContent = isAudioContent
        
        // video 세팅
        self.isVideoContent = isVideoContent
        imageView = UIImageView(frame: self.bounds)
        NotificationCenter.default.addObserver(self, selector: #selector(back), name: NSNotification.Name(rawValue: "back"), object: nil)
    }
    @objc func back(){
        touchEnable = true
        self.isHidden = false
    }
    
    func click(){
        self.isHidden = true
        touchEnable = false
    }
    
    // 줌에 따른 마커 크기, 위치 세팅 변화
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
        
        removeImage()
        
        let background = UIImage(named: "page-1")
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        self.addSubview(imageView)
    }
    
    func removeImage(){
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
    // audio 정보 세팅
    func setAudioContent(name: String, format: String) {
        dataSource.audioContentView?.setAudioPlayer()
        dataSource.audioContentView?.setAudio(name: name, format: format)
    }
    
    // video 정보 세팅
    func setVideoContent(name: String, format: String) {
        dataSource.videoContentView?.setVideoPlayer()
        dataSource.videoContentView?.setVideo(name: name, format: format)
    }
    
    func setVideoContent(url: URL) {
        dataSource.videoContentView?.setVideoPlayer()
        dataSource.videoContentView?.setVideoUrl(url: url)
    }
    
    // 마커 클릭시 카운데 정렬과, 줌 세팅
    private func zoom(scale: CGFloat) {
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
        if touchEnable {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "click"), object: nil)
            zoom(scale: CGFloat(zoomScale))
            if isAudioContent {
                dataSource.audioContentView?.isHidden = false
            }
            
            if isVideoContent {
                dataSource.videoContentView?.isHidden = false
            }
        }
    }
}

