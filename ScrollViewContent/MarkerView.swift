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
    private var audioContentView: AudioContentView?
    
    private var isVideoContent = false
    private var videoContentView: VideoContentView?
    
    public func initial(){
        audioContentView = dataSource.audioContentView
        audioContentView?.isHidden = true
        videoContentView = dataSource.videoContentView
        videoContentView?.isHidden = true

    }
    public func set( x: Double, y: Double, zoomScale: Double, isAudioContent: Bool, isVideoContent: Bool){
       
        self.x = x
        self.y = y
        self.zoomScale = zoomScale
        // audio 세팅
        self.isAudioContent = isAudioContent
        audioContentView?.isHidden = true
        
        // video 세팅
        self.isVideoContent = isVideoContent
        videoContentView?.isHidden = true
    }
    
    public func draw(dataSource: MarkerViewDataSource) {
        NotificationCenter.default.addObserver(self, selector: #selector(frameSet),
                                               name: NSNotification.Name(rawValue: "scollViewAction"),
                                               object: nil)
        self.dataSource = dataSource
        dataSource.scrollView.addSubview(self)
        
        markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
        markerTapGestureRecognizer.delegate = self
        self.addGestureRecognizer(markerTapGestureRecognizer)
        
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
        
        self.backgroundColor = UIColor.red
    }
    
    // audio 정보 세팅
    func setAudioContent(name: String, format: String) {
        audioContentView?.setAudioPlayer()
        audioContentView?.setAudio(name: name, format: format)
    }
    
    // video 정보 세팅
    func setVideoContent(name: String, format: String) {
        videoContentView?.setVideoPlayer()
        videoContentView?.setVideo(name: name, format: format)
    }
    
    func setVideoContent(url: URL) {
        videoContentView?.setVideoPlayer()
        videoContentView?.setVideoUrl(url: url)
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
    
    public func setOpacity(alpha: CGFloat){
        self.backgroundColor = UIColor.red.withAlphaComponent(alpha)
    }
}

extension MarkerView: UIGestureRecognizerDelegate {
    @objc func markerViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        zoom(scale: CGFloat(zoomScale))
        
        if isAudioContent {
            audioContentView?.isHidden = false
        }
        
        if isVideoContent {
            videoContentView?.isHidden = false
        }
    }
}

