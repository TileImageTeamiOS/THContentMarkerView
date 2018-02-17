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
    
    var dataSource: THContentMarkerControllerDataSource!
    var delegate: THContentMarkerControllerDelegate!
    
    var parentView: UIView!
    var scrollView: UIScrollView!
    var markerViewArray: [THMarkerView] = []
    var markerDataArray: [THMarker] = []
    var contentSetArray: [THContentSet] = []
    
    private var duration: Double
    private var delay: Double
    private var initialSpringVelocity: CGFloat

    init(duration: Double, delay: Double, initialSpringVelocity: CGFloat) {
        self.duration = duration
        self.delay = delay
        self.initialSpringVelocity = initialSpringVelocity
    }

    public func set(parentView: UIView, scrollView: UIScrollView) {
        self.parentView = parentView
        self.scrollView = scrollView

        markerViewArray.removeAll()
        markerViewArray.forEach { markerView in
            markerView.removeFromSuperview()
        }
        
        // set markerView
        for index in 0..<self.dataSource.numberOfMarker(self) {

            let origin = self.dataSource.setMarker(self, markerIndex: index).origin
            let zoomScale = self.dataSource.setMarker(self, markerIndex: index).zoomScale

            let thMarkerView = THMarkerView(origin: origin, zoomScale: zoomScale, index: index)

            thMarkerView.frame.size = markerViewSize
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
        guard let scrollView = self.scrollView else { return }

        for marker in markerViewArray {

            let markerSize = marker.frame.size
            let originX = (marker.origin.x * scrollView.zoomScale) - markerSize.width / 2
            let originY = (marker.origin.y * scrollView.zoomScale) - markerSize.height / 2

            marker.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: markerSize)
        }
    }
    
    public func reloadData(dataSource: THContentMarkerControllerDataSource) {
        markerViewArray.removeAll()
        
        for marker in markerViewArray {
            marker.removeFromSuperview()
        }
        
        for index in 0..<self.dataSource.numberOfMarker(self) {

            let origin = self.dataSource.setMarker(self, markerIndex: index).origin
            let thMarkerView = THMarkerView(origin: origin, index: index)

            thMarkerView.frame.size = markerViewSize
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
    
    private func setImage(markerImage: UIImage, markerView: UIView) {
        let size = markerView.frame.size

        let imageViewBackground = UIImageView(frame: CGRect(origin: .zero, size: size))
        imageViewBackground.image = markerImage
        imageViewBackground.contentMode = .scaleAspectFit
        
        markerView.addSubview(imageViewBackground)
        markerView.sendSubview(toBack: imageViewBackground)
    }
    
    private func zoom(destinationRect: CGRect) {
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
}

public class THMarkerView: UIView {
    open var origin: CGPoint = .zero
    open var zoomScale: CGFloat = 0.0
    open var index: Int = 0
    open var delegate: THMarkerViewDelegate?
    open var destinationRect: CGRect = .zero

    convenience init(origin: CGPoint, zoomScale: CGFloat = 0.0, index: Int = 0) {
        self.init()
        self.origin = origin
        self.zoomScale = zoomScale
        self.index = index
    }

    func setMarker(scrollView: UIScrollView) {
        let markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
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
