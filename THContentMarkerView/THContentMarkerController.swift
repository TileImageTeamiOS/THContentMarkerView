//
//  THContentMarkerController.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 2. 12..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

class THContentMarkerController {
    open var markerViewSize: CGSize = CGSize(width: 20, height: 20)
    open var markerViewImage: UIImage?
    open var scrollView: UIScrollView?
    open var markerViewArray: [THMarkerView] = []
//    var contentWrapArray: [THContentWrapper] = []

    var dataSource: THContentMarkerControllerDataSource!

    public func set(parentView: UIView, scrollView: UIScrollView, dataSource: THContentMarkerControllerDataSource) {
        self.scrollView = scrollView
        self.dataSource = dataSource
//        self.dataSource = dataSource
//        contentWrapArray.removeAll()
//        contentWrapArray = dataSource.setContentView(self)
//
//        contentWrapArray.map { contentView in
//            parentView.addSubview(contentView.contentView)
//            contentView.contentView.isHidden = true
//        }
        
        for index in 0..<self.dataSource.numberOfMarker(self) {
            let thMarkerView = THMarkerView()
            thMarkerView.frame.size = markerViewSize
            thMarkerView.origin = self.dataSource.setMarker(self, index: index).origin
            thMarkerView.index = index
            thMarkerView.setMarker()

            if let image = markerViewImage {
                setImage(markerImage: image, markerView: thMarkerView)
            }
            markerViewArray.append(thMarkerView)
            self.scrollView?.addSubview(thMarkerView)
        }
    }
    
    public func setMarkerFrame() {
        for marker in markerViewArray {
            marker.frame = CGRect(x: marker.origin.x * (self.scrollView?.zoomScale)! - marker.frame.size.width/2, y: marker.origin.y * (self.scrollView?.zoomScale)! - marker.frame.size.height/2, width: marker.frame.size.width, height: marker.frame.size.height)
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
    
//
//    func show(content: THContent) {
//        for (index, contentView) in contentWrapArray.enumerated() {
//            if let info = content.contentInfo[contentView.contentKey] {
//                contentView.contentView.delegate.setContent(info: info)
//                contentView.contentView.isHidden = false
//            }
//        }
//    }
//
//    func dismiss() {
//        for contentWrap in contentWrapArray {
//            contentWrap.contentView.isHidden = true
//            contentWrap.contentView.delegate.dismiss()
//        }
//    }
    
}

//protocol THContentType {
//    var contentInfo: Dictionary<String, Any?> { get set }
//}
//
//public struct THContent: THContentType {
//    var contentInfo: Dictionary<String, Any?>
//}
//
//public class THContentView: UIView {
//    var delegate: THContentViewDelegate!
//}
//
//public protocol THContentViewDelegate: class {
//    func setContent(info: Any?)
//    func dismiss()
//}

public class THMarkerView: UIView, UIGestureRecognizerDelegate {
    open var origin: CGPoint = CGPoint()
    open var zoomScale: CGFloat = CGFloat()
    open var index: Int = Int()
    
    private var markerTapGestureRecognizer = UITapGestureRecognizer()
    
    func setMarker() {
        markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
        markerTapGestureRecognizer.delegate = self
        self.addGestureRecognizer(markerTapGestureRecognizer)
    }
    
    @objc func markerViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        print(self.index)
    }
}


public struct THMarker {
    public var zoomScale: CGFloat
    public var origin: CGPoint
}


protocol THContentMarkerControllerDataSource: class {
//    func setContentView(_ contentController: THContentMarkerController) -> [THContentWrapper]
    func numberOfMarker(_ contentMarkerController: THContentMarkerController) -> Int
    func setMarker(_ contentMarkerController: THContentMarkerController, index: Int) -> THMarker
}
