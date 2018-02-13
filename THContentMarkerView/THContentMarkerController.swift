//
//  THContentMarkerController.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 2. 12..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

class THContentMarkerController: THMarkerViewDelegate {
    open var markerViewSize: CGSize = CGSize(width: 20, height: 20)
    open var markerViewImage: UIImage?

    private var duration = Double(3.0)
    private var delay = Double(0.0)
    private var initialSpringVelocity = CGFloat(0.66)
    
    var dataSource: THContentMarkerControllerDataSource!
    var delegate: THContentMarkerControllerDelegate!
    
    var parentView: UIView!
    var scrollView: UIScrollView!
    var markerViewArray: [THMarkerView] = []
    var markerDataArray: [THMarker] = []
    
    var contentSetArray: [THContentSet] = []

    public func set(parentView: UIView, scrollView: UIScrollView, dataSource: THContentMarkerControllerDataSource, delegate: THContentMarkerControllerDelegate) {
        self.parentView = parentView
        self.scrollView = scrollView
        self.dataSource = dataSource
        self.delegate = delegate

        markerViewArray.removeAll()
        markerViewArray.forEach { markerView in
            markerView.removeFromSuperview()
        }
        
        // set markerView
        for index in 0..<self.dataSource.numberOfMarker(self) {
            let thMarkerView = THMarkerView()
            thMarkerView.frame.size = markerViewSize
            thMarkerView.zoomScale = self.dataSource.setMarker(self, markerIndex: index).zoomScale
            thMarkerView.origin = self.dataSource.setMarker(self, markerIndex: index).origin
            thMarkerView.index = index
            thMarkerView.setMarker(scrollView: self.scrollView)
            thMarkerView.delegate = self
            markerDataArray.append(self.dataSource.setMarker(self, markerIndex: index))

            if let image = markerViewImage {
                setImage(markerImage: image, markerView: thMarkerView)
            }
            markerViewArray.append(thMarkerView)
            self.scrollView?.addSubview(thMarkerView)
        }
        
        // set contentView
        for index in 0..<self.dataSource.numberOfContent(self) {
            self.parentView.addSubview(dataSource.setContentView(self, contentSetIndex: index).contentView)
            self.contentSetArray.append(dataSource.setContentView(self, contentSetIndex: index))
        }
        
        for contentSet in contentSetArray {
            contentSet.contentView.isHidden = true
        }
    }
    
    public func setMarkerFrame() {
        for marker in markerViewArray {
            marker.frame = CGRect(x: marker.origin.x * (self.scrollView?.zoomScale)! - marker.frame.size.width/2, y: marker.origin.y * (self.scrollView?.zoomScale)! - marker.frame.size.height/2, width: marker.frame.size.width, height: marker.frame.size.height)
        }
    }
    
    public func reloadData(dataSource: THContentMarkerControllerDataSource) {
        markerViewArray.removeAll()
        
        for marker in markerViewArray {
            marker.removeFromSuperview()
        }
        
        for index in 0..<self.dataSource.numberOfMarker(self) {
            let thMarkerView = THMarkerView()
            thMarkerView.frame.size = markerViewSize
            thMarkerView.origin = self.dataSource.setMarker(self, markerIndex: index).origin
            thMarkerView.index = index
            thMarkerView.setMarker(scrollView: self.scrollView)
            
            if let image = markerViewImage {
                setImage(markerImage: image, markerView: thMarkerView)
            }
            markerViewArray.append(thMarkerView)
            self.scrollView?.addSubview(thMarkerView)
        }
    }
    
    public func setZoom(duration: Double, delay: Double, initialSpringVelocity: CGFloat){
        self.duration = duration
        self.delay = delay
        self.initialSpringVelocity = initialSpringVelocity
    }
    
    func tapEvent(marker: THMarkerView) {
        delegate.markerTap(self, markerIndex: marker.index)
        zoom(destinationRect: marker.destinationRect)
        if let contentInfo = markerDataArray[marker.index].contentInfo {
            for contentIndex in 0..<self.dataSource.numberOfContent(self) {
                if let info = contentInfo[contentSetArray[contentIndex].contentKey] {
                    contentSetArray[contentIndex].contentView.isHidden = false
                    contentSetArray[contentIndex].contentView.delegate.setContent(info: info)
                }
            }
        }
    }
    
    public func markerHidden(Bool: Bool) {
        markerViewArray.forEach { markerView in
            markerView.isHidden = Bool
        }
    }
    
    public func contentDismiss() {
        contentSetArray.forEach { contentSet in
            contentSet.contentView.delegate.dismiss()
            contentSet.contentView.isHidden = true
        }
    }
    
    private func setImage(markerImage: UIImage, markerView: UIView){
        let width = markerView.frame.size.width
        let height = markerView.frame.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.image = markerImage
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFit
        
        markerView.addSubview(imageViewBackground)
        markerView.sendSubview(toBack: imageViewBackground)
    }
    
    private func zoom(destinationRect: CGRect){
        self.scrollView.isMultipleTouchEnabled = false
        UIView.animate(withDuration: self.duration, delay: self.delay, usingSpringWithDamping: 2.0, initialSpringVelocity: initialSpringVelocity, options: [.allowUserInteraction], animations: {
            self.scrollView.zoom(to: destinationRect, animated: false)
        }, completion: {
            completed in
            self.scrollView.isMultipleTouchEnabled = true
            if let delegate = self.scrollView.delegate, delegate.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:))), let view = delegate.viewForZooming?(in: self.scrollView) {
                delegate.scrollViewDidEndZooming!(self.scrollView, with: view, atScale: 1.0)
            }
        })
    }
}

public class THMarkerView: UIView, UIGestureRecognizerDelegate {
    open var origin: CGPoint = CGPoint()
    open var zoomScale: CGFloat = CGFloat()
    open var index: Int = Int()
    open var delegate: THMarkerViewDelegate?
    open var destinationRect = CGRect()
    
    private var markerTapGestureRecognizer = UITapGestureRecognizer()
    
    func setMarker(scrollView: UIScrollView) {
        markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
        markerTapGestureRecognizer.delegate = self
        self.addGestureRecognizer(markerTapGestureRecognizer)
        
        self.destinationRect.size.width = scrollView.frame.width/zoomScale
        self.destinationRect.size.height = scrollView.frame.height/zoomScale
        self.destinationRect.origin.x = self.origin.x - destinationRect.width/2
        self.destinationRect.origin.y = self.origin.y - destinationRect.height/2
    }
    
    @objc func markerViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.tapEvent(marker: self)
    }
}

public protocol THMarkerViewDelegate: AnyObject {
    func tapEvent(marker: THMarkerView)
}

public struct THContentSet {
    public var contentKey: String
    public var contentView: THContentView
}

public struct THMarker {
    public var zoomScale: CGFloat
    public var origin: CGPoint
    public var contentInfo: Dictionary<String, Any?>?
}

protocol THContentMarkerControllerDataSource: class {
    func numberOfMarker(_ contentMarkerController: THContentMarkerController) -> Int
    func setMarker(_ contentMarkerController: THContentMarkerController, markerIndex: Int) -> THMarker
    
    func numberOfContent(_ contentMarkerController: THContentMarkerController) -> Int
    func setContentView(_ contentMarkerController: THContentMarkerController, contentSetIndex: Int) -> THContentSet
}

protocol THContentMarkerControllerDelegate: class {
    func markerTap(_ contentMarkerController: THContentMarkerController, markerIndex: Int)
}
