//
//  THContentMarkerController.swift
//  THContentMarkerView
//
//  Created by Seong ho Hong on 2018. 2. 18..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

open class THContentMarkerController: THMarkerViewDelegate {
    // MARK: - Properties [Public]
    public init() {}

    /// The 'MarkerViewSize' manage marker view size in UIScrollView
    /// default CGSize(width: 20, height: 20)
    open var markerViewSize: CGSize = CGSize(width: 20, height: 20)
    /// The 'MarkerViewImage' set markerview image
    open var markerViewImage: UIImage?

    open var dataSource: THContentMarkerControllerDataSource!
    open var delegate: THContentMarkerControllerDelegate!

    /// contentView is set and input in 'ParentView'
    var parentView: UIView!
    /// markerView is set and input in 'ScrollView'
    var scrollView: UIScrollView!

    /// THContentMarkerController is controll 'THMarkerView', and datamodel 'THMarker', contentSet 'THContentSet'
    var markerViewArray: [THMarkerView] = []
    var contentSetArray: [THContentSet] = []

    /// you can controller markerZoom by duration, delay, initalSpringVelocity
    private var duration: Double = 3.0
    private var delay: Double = 0.0
    private var initialSpringVelocity: CGFloat = 0.66

    public func setZoomAnimation(duration: Double, delay: Double, initialSpringVelocity: CGFloat) {
        self.duration = duration
        self.delay = delay
        self.initialSpringVelocity = initialSpringVelocity
    }

    // MARK: - Initializers
    public func set(parentView: UIView, scrollView: UIScrollView) {
        /// parentView and scrollView set in initalizers
        self.parentView = parentView
        self.scrollView = scrollView

        /// when set, markerview reset
        markerViewArray.forEach { markerView in
            markerView.removeFromSuperview()
        }
        markerViewArray.removeAll()

        /// set markerView, by dataSource
        for index in 0..<self.dataSource.numberOfMarker(self) {

            let marker = self.dataSource.setMarker(self, markerIndex: index)
            /// when set markerView, use THMarker data in dataSource
            /// and 'THMarkerView' has index by 'THMarker' array
            let thMarkerView = THMarkerView(marker: marker, index: index)

            thMarkerView.frame.size = markerViewSize
            thMarkerView.setMarker(scrollView: self.scrollView)
            thMarkerView.delegate = self

            if let image = markerViewImage {
                setImage(markerImage: image, markerView: thMarkerView)
            }
            markerViewArray.append(thMarkerView)
            self.scrollView?.addSubview(thMarkerView)
        }

        self.contentSetArray.removeAll()
        /// set contentView, by dataSource
        for index in 0..<self.dataSource.numberOfContent(self) {
            self.parentView.addSubview(dataSource.setContentView(self, contentSetIndex: index).contentView)
            self.contentSetArray.append(dataSource.setContentView(self, contentSetIndex: index))
        }

        /// 'THContentView' is hidden normally
        for contentSet in contentSetArray {
            contentSet.contentView.isHidden = true
        }
    }

    /// when scrollView zoom change, all marker frame is change by zoomScale.
    public func setMarkerFrame() {
        guard let scrollView = self.scrollView else { return }

        for markerView in markerViewArray {
            let markerSize = markerView.frame.size
            let originX = (markerView.marker.origin.x * scrollView.zoomScale) - markerSize.width / 2
            let originY = (markerView.marker.origin.y * scrollView.zoomScale) - markerSize.height / 2

            markerView.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: markerSize)
        }
    }

    /// when change 'THMarker', you can reload 'THMarkerView' by reloadData
    public func reloadData() {
        markerViewArray.forEach { markerView in
            markerView.removeFromSuperview()
        }
        markerViewArray.removeAll()

        for index in 0..<self.dataSource.numberOfMarker(self) {
            let marker = self.dataSource.setMarker(self, markerIndex: index)
            let thMarkerView = THMarkerView(marker: marker, index: index)
            thMarkerView.frame.size = markerViewSize
            thMarkerView.setMarker(scrollView: self.scrollView)

            if let image = markerViewImage {
                setImage(markerImage: image, markerView: thMarkerView)
            }

            markerViewArray.append(thMarkerView)
            self.scrollView?.addSubview(thMarkerView)
        }
    }

    public func removeMarker() {
        for marker in markerViewArray {
            marker.removeFromSuperview()
        }
        markerViewArray.removeAll()
    }

    /// if you want 'THMarker' hidden controller, you use 'MarkerHidden'
    public func markerHidden(bool: Bool) {
        markerViewArray.forEach { markerView in
            markerView.isHidden = bool
        }
    }

    /// if you dismiss of contentView, you use contentDismiss
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

    // MARK: - Methods [Private]
    /// when you tap 'THMarker', zoom animate set
    private func zoom(destinationRect: CGRect) {
        self.scrollView.isMultipleTouchEnabled = false
        UIView.animate(withDuration: self.duration, delay: self.delay, usingSpringWithDamping: 2.0,
                       initialSpringVelocity: self.initialSpringVelocity, options: [.allowUserInteraction],
                       animations: {
                        self.scrollView.zoom(to: destinationRect, animated: false)
        }, completion: { _ in
            self.scrollView.isMultipleTouchEnabled = true
            if let delegate = self.scrollView.delegate,
                delegate.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:))),
                let view = delegate.viewForZooming?(in: self.scrollView) {
                delegate.scrollViewDidEndZooming!(self.scrollView, with: view, atScale: 1.0)
            }
        })
    }

    /// 'THMarkerView' tap event set
    public func tapEvent(markerView: THMarkerView) {
        delegate.markerTap(self, markerView: markerView)
        zoom(destinationRect: markerView.destinationRect)
        if let contentInfo = markerViewArray[markerView.index].marker.contentInfo {
            for contentIndex in 0..<self.dataSource.numberOfContent(self) {
                if let info = contentInfo[contentSetArray[contentIndex].contentKey] {
                    contentSetArray[contentIndex].contentView.isHidden = false
                    contentSetArray[contentIndex].contentView.delegate.setContent(info: info)
                }
            }
        }
    }
}

public protocol THContentMarkerControllerDataSource: class {
    func numberOfMarker(_ contentMarkerController: THContentMarkerController) -> Int
    func setMarker(_ contentMarkerController: THContentMarkerController, markerIndex: Int) -> THMarker
    func numberOfContent(_ contentMarkerController: THContentMarkerController) -> Int
    func setContentView(_ contentMarkerController: THContentMarkerController, contentSetIndex: Int) -> THContentSet
}

public protocol THContentMarkerControllerDelegate: class {
    func markerTap(_ contentMarkerController: THContentMarkerController, markerView: THMarkerView)
}
