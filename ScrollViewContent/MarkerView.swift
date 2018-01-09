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
    
    //marker content 존재 여부
    private var isTitleContent = false
    private var isAudioContent = false
    private var isVideoContent = false
    
    private var touchEnable = true
    private var imageView : UIImageView!
    private var markerTitle: String = ""
    
    var videoURL: URL?
    var title: String?
    
    public func initial(){
        dataSource.audioContentView?.isHidden = true
        dataSource.videoContentView?.isHidden = true

    }
    public func set(dataSource: MarkerViewDataSource, x: Double, y: Double, zoomScale: Double, isTitleContent: Bool, isAudioContent: Bool, isVideoContent: Bool, markerTitle: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(frameSet),
                                               name: NSNotification.Name(rawValue: "scollViewAction"),
                                               object: nil)
        // marker 위치 설정후 scrollview에 추가
        self.dataSource = dataSource
        self.x = x
        self.y = y
        self.zoomScale = zoomScale
        self.markerTitle = markerTitle
        dataSource.scrollView.addSubview(self)
        
        // marker tap 설정
        markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
        markerTapGestureRecognizer.delegate = self
        self.addGestureRecognizer(markerTapGestureRecognizer)
        
        // content 존재 여부 설정
        self.isTitleContent = isTitleContent
        self.isAudioContent = isAudioContent
        self.isVideoContent = isVideoContent
    
        // 이미지 설정
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
            self.frame = CGRect(x: positionX-scaleLength/4, y: positionY-scaleLength/4, width: scaleLength, height: scaleLength)
        } else {
            self.frame = CGRect(x: positionX-ratioLength/4, y: positionY-ratioLength/4, width: ratioLength, height: ratioLength)
        }
        
        removeImage()
        
        let background = UIImage(named: "page")
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
    
    // 비디오 url 설정
    func setVideoContent(url: URL) {
        dataSource.videoContentView?.setVideoPlayer()
//        dataSource.videoContentView?.setVideoUrl(url: url)
        videoURL = url
    }
    
    // title string 설정
    func setTitle(title: String) {
        self.title = title
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
    
    // 마커 클릭식, contentView set
    private func markerContentSet() {
        // content 존재 여부에 따라 view Hidden 결정
        if isTitleContent {
            dataSource.titleLabelView?.text = title
            dataSource.titleLabelView?.sizeToFit()
            dataSource.titleLabelView?.isHidden = false
        }
        
        if isAudioContent {
            dataSource.audioContentView?.isHidden = false
        }
        
        if isVideoContent {
            dataSource.videoContentView?.setVideoUrl(url: videoURL!)
            dataSource.videoContentView?.isHidden = false
        }
    }
}

extension MarkerView: UIGestureRecognizerDelegate {
    @objc func markerViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if touchEnable {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "click"), object: nil)
            zoom(scale: CGFloat(zoomScale))
            
//            dataSource.videoContentView?.setVideoUrl(url: videoURL!)
//            if isAudioContent {
//                dataSource.audioContentView?.isHidden = false
//            }
//
//            if isVideoContent {
//                dataSource.videoContentView?.isHidden = false
//            }
//
//            dataSource.titleLabelView?.isHidden = false
//            dataSource.titleLabelView?.text = title
//            dataSource.titleLabelView?.sizeToFit()
            markerContentSet()
        }
    }
}

