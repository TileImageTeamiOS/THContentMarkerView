//
//  THContentMarkerController.swift
//  THContentMarkerView
//
//  Created by Seong ho Hong on 2018. 2. 18..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

class THContentMarkerController: THMarkerViewDelegate {
    // MARK: - Properties [Public]

    /// The 'MarkerViewSize' manage marker view size in UIScrollView
    /// default CGSize(width: 20, height: 20)
    open var markerViewSize: CGSize = CGSize(width: 20, height: 20)
    /// The 'MarkerViewImage' set markerview image
    open var markerViewImage: UIImage?

    weak var dataSource: THContentMarkerControllerDataSource!
    weak var delegate: THContentMarkerControllerDelegate!

    /// contentView is set and input in 'ParentView'
    var parentView: UIView!
    /// markerView is set and input in 'ScrollView'
    var scrollView: UIScrollView!

    /// THContentMarkerController is controll 'THMarkerView', and datamodel 'THMarker', contentSet 'THContentSet'
    var markerViewArray: [THMarkerView] = []
    var markerDataArray: [THMarker] = []
    var contentSetArray: [THContentSet] = []

    /// you can controller markerZoom by duration, delay, initalSpringVelocity
    private var duration: Double
    private var delay: Double
    private var initialSpringVelocity: CGFloat

    init(duration: Double, delay: Double, initialSpringVelocity: CGFloat) {
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
        markerViewArray.removeAll()
        markerViewArray.forEach { markerView in
            markerView.removeFromSuperview()
        }

        /// set markerView, by dataSource
        for index in 0..<self.dataSource.numberOfMarker(self) {

            let origin = self.dataSource.setMarker(self, markerIndex: index).origin
            let zoomScale = self.dataSource.setMarker(self, markerIndex: index).zoomScale

            /// when set markerView, use THMarker data in dataSource
            /// and 'THMarkerView' has index by 'THMarker' array
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

        for marker in markerViewArray {

            let markerSize = marker.frame.size
            let originX = (marker.origin.x * scrollView.zoomScale) - markerSize.width / 2
            let originY = (marker.origin.y * scrollView.zoomScale) - markerSize.height / 2

            marker.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: markerSize)
        }
    }

    /// when change 'THMarker', you can reload 'THMarkerView' by reloadData
    public func reloadData() {
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
        UIView.animate(withDuration: self.duration, delay: self.delay, usingSpringWithDamping: 2.0, initialSpringVelocity: initialSpringVelocity, options: [.allowUserInteraction], animations: {
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

protocol THContentMarkerControllerDataSource: class {
    func numberOfMarker(_ contentMarkerController: THContentMarkerController) -> Int
    func setMarker(_ contentMarkerController: THContentMarkerController, markerIndex: Int) -> THMarker

    func numberOfContent(_ contentMarkerController: THContentMarkerController) -> Int
    func setContentView(_ contentMarkerController: THContentMarkerController, contentSetIndex: Int) -> THContentSet
}

protocol THContentMarkerControllerDelegate: class {
    func markerTap(_ contentMarkerController: THContentMarkerController, markerIndex: Int)
}
