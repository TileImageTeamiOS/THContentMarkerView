//
//  ViewController.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2017. 12. 31..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    var isEditor = false
    
    var x: Double = 0
    var y: Double = 0
    var width: Double = 0
    var height: Double = 0
    
    var centerPoint = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        imageView.frame.size = (imageView.image?.size)!
        scrollView.delegate = self
        
        setZoomParametersForSize(scrollView.bounds.size)
        recenterImage()
        
        centerPoint.frame = CGRect(x: scrollView.center.x, y: scrollView.center.y, width: CGFloat(10), height: CGFloat(10))
        centerPoint.backgroundColor = UIColor.red
        centerPoint.layer.cornerRadius = 5
        
        self.view.addSubview(centerPoint)
        centerPoint.isHidden = true
        doneButton.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        setZoomParametersForSize(scrollView.bounds.size)
        recenterImage()
    }
    
    @IBAction func editionButton(_ sender: Any) {
        if isEditor == false {
            scrollView.layer.borderWidth = 4
            scrollView.layer.borderColor = UIColor.red.cgColor
            centerPoint.isHidden = isEditor
            doneButton.isHidden = isEditor
            
            isEditor = true
        } else {
            scrollView.layer.borderWidth = 0
            centerPoint.isHidden = isEditor
            doneButton.isHidden = isEditor
            
            isEditor = false
        }
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        print(scrollView.zoomScale)
    }
    
    func recenterImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = imageView.frame.size
        
        let horizontalSpace = imageSize.width < scrollViewSize.width ? (scrollViewSize.width - imageSize.width) / 2 : 0
        let verticalSpace = imageSize.height < scrollViewSize.height ? (scrollViewSize.height - imageSize.height) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
    }
    
    func setZoomParametersForSize(_ scrollViewSize: CGSize) {
        let imageSize = imageView.bounds.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = minScale
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        x = Double(scrollView.contentOffset.x)
        y = Double(scrollView.contentOffset.y)
        height = Double(scrollView.bounds.height)
        width = Double(scrollView.bounds.width)
    }
}

extension UIImage {
    func cropCGRect(rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(<#T##size: CGSize##CGSize#>, <#T##opaque: Bool##Bool#>, <#T##scale: CGFloat##CGFloat#>)
    }
}
