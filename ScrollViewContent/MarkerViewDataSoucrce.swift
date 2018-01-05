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
    private var _size: CGSize
    private var _audioContentView: AudioContentView?
    private var _videoContentView: VideoContentView?
    private var _titleLabel: UILabel
    
    init(scrollView: UIScrollView, imageView: UIImageView, ratioByImage: Double,titleLabel: UILabel ,audioContentView: AudioContentView?, videoContentView: VideoContentView?) {
        self._scrollView = scrollView
        self._imageView = imageView
        self._ratioByImage = ratioByImage
        self._size = imageView.frame.size.divide(double: ratioByImage)
        self._titleLabel = titleLabel
        self._audioContentView = audioContentView
        self._videoContentView = videoContentView
    }
    
    var titleLabel: UILabel {
        get{return _titleLabel}
    }
    
    var scrollView: UIScrollView {
        get{return _scrollView}
    }
    
    var zoomScale: Double {
        get {return Double(self._scrollView.zoomScale)}
    }
    
    var ratioWidth: Double {
        get {return Double(self._size.width)}
    }
    
    var rationHeight: Double {
        get {return Double(self._size.height)}
    }
    
    var zoomScaleWidth: Double {
        get {return (Double(self._size.width)/zoomScale)}
    }
    
    var zoomScaleHeight: Double {
        get {return (Double(self._size.height)/zoomScale)}
    }
    
    var audioContentView: AudioContentView? {
        get {return _audioContentView}
    }
    
    var videoContentView: VideoContentView? {
        get {return _videoContentView}
    }
}

extension CGSize {
    public func divide(double: Double) -> CGSize{
        return CGSize(width: Double(self.width)/double, height: Double(self.height)/double)
    }
}

