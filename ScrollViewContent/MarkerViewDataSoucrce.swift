//
//  MarkerViewDataSoucrce.swift
//  ScrollViewMarker
//
//  Created by Seong ho Hong on 2018. 1. 1..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

public struct MarkerViewDataSource {
    private var _scrollView: UIScrollView
    private var _imageView: UIImageView
    private var _ratioByImage: Double
    private var _ratioSize: CGSize
    private var _audioContentView: AudioContentView?
    private var _videoContentView: VideoContentView?
    private var _textContentView: TextContentView?
    private var _titleLabelView: UILabel?

    init(scrollView: UIScrollView, imageView: UIImageView, ratioByImage: Double, titleLabelView: UILabel?, audioContentView: AudioContentView?, videoContentView: VideoContentView?, textContentView: TextContentView?) {
        self._scrollView = scrollView
        self._imageView = imageView
        self._ratioByImage = ratioByImage
        self._ratioSize = imageView.frame.size.divide(double: ratioByImage)
        self._titleLabelView = titleLabelView
        self._audioContentView = audioContentView
        self._videoContentView = videoContentView
        self._textContentView = textContentView
        self._titleLabelView?.isHidden = true
        self._audioContentView?.isHidden = true
        self._videoContentView?.isHidden = true
        self._textContentView?.isHidden = true
        
        videoContentView?.setVideoPlayer()
        audioContentView?.setAudioPlayer()
        textContentView?.setTextContent()
    }

    var ratioSize: CGSize {
        get{return _ratioSize}
    }
    
    var scrollView: UIScrollView {
        get{return _scrollView}
    }
    
    var imageView: UIImageView {
        get{return _imageView}
    }

    var titleLabelView: UILabel? {
        get {return _titleLabelView}
    }

    var audioContentView: AudioContentView? {
        get {return _audioContentView}
    }

    var videoContentView: VideoContentView? {
        get {return _videoContentView}
    }

    var textContentView: TextContentView? {
        get {return _textContentView}
    }
}

extension MarkerViewDataSource {
    // 해당 위치로 줌
    func zoom(destinationRect: CGRect) {
        // zoom 사이에 error 수정
        scrollView.isMultipleTouchEnabled = false
        
        UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
            self.scrollView.zoom(to: destinationRect, animated: false)
        }, completion: {
            completed in
            self.scrollView.isMultipleTouchEnabled = true
            if let delegate = self.scrollView.delegate, delegate.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:))), let view = delegate.viewForZooming?(in: self.scrollView) {
                delegate.scrollViewDidEndZooming!(self.scrollView, with: view, atScale: 1.0)
            }
        })
    }
    
    // 마커 선택 해제
    func reset() {
        zoom(destinationRect: CGRect(x: 0, y: 0, width: (imageView.image?.size.width)!, height: (imageView.image?.size.height)!))
        titleLabelView?.isHidden = true
        audioContentView?.isHidden = true
        videoContentView?.isHidden = true
        textContentView?.isHidden = true
        
        // 실행중인 content 종료
        audioContentView?.stopAudio()
        videoContentView?.pauseVideo()
    }
    
    // zoom에 따른 크기, 위치 조정
    func framSet(markerView: MarkerView) {
        let ratioLength = ratioSize.height < ratioSize.width ? ratioSize.height : ratioSize.width
        let scaleLength = ratioLength/scrollView.zoomScale
        
        if scrollView.zoomScale > 1 {
            markerView.frame = CGRect(x: markerView.x * scrollView.zoomScale - scaleLength/2, y: markerView.y * scrollView.zoomScale - scaleLength/2, width: scaleLength, height: scaleLength)
        } else {
            markerView.frame = CGRect(x: markerView.x * scrollView.zoomScale - ratioLength/2, y: markerView.y * scrollView.zoomScale - ratioLength/2, width: ratioLength, height: ratioLength)
        }
        
        if markerView.imageView != nil {
            markerView.imageView?.frame.size = markerView.frame.size
        }
    }
}

extension CGSize {
    public func divide(double: Double) -> CGSize{
        return CGSize(width: Double(self.width)/double, height: Double(self.height)/double)
    }
}


