//
//  ViewController.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2017. 12. 31..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit
import THMarkerView

class ViewController: THContentViewController {
    @IBOutlet weak var editorBtn: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var jsonParsing = JsonParsing()
    var imageSize = CGSize()
    
    // THContent
    var contentArray: [THContent] = []
    var isEditor = false
    var centerPoint = UIView()
    var markerArray = [THMarkerView]()
    
    func showMarker() {
        markerArray.removeAll()
        jsonParsing.set(scrollView: scrollView) {_ in
            for i in 0..<self.jsonParsing.markerArray.count {
                self.jsonParsing.markerArray[i].delegate = self
                self.markerArray.append(self.jsonParsing.markerArray[i])
                self.contentArray.append(self.jsonParsing.contentArray[i])
            }
            for marker in self.markerArray {
                marker.framSet()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showMarker()
        back()
        self.scrollView.zoom(to: CGRect(x: 0, y: 0, width: (self.imageSize.width), height: (self.imageSize.height)), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMarker()
        scrollView.contentInsetAdjustmentBehavior = .never
        imageView.frame.size = (imageView.image?.size)!
        imageSize = (imageView.image?.size)!
        scrollView.delegate = self
        
        // edit center point 설정
        centerPoint.frame = CGRect(x: view.frame.width/2, y: view.frame.height/2 + scrollView.frame.origin.y/2, width: CGFloat(10), height: CGFloat(10))
        centerPoint.backgroundColor = UIColor.red
        centerPoint.layer.cornerRadius = 5
        
        self.view.addSubview(centerPoint)
        centerPoint.isHidden = true
        doneButton.isHidden = true
        
        dataSource = self
        set(parentView: self.view)
    }
    
    override func viewWillLayoutSubviews() {
        setZoomParametersForSize(scrollView.bounds.size)
        recenterImage()
    }
    
    @IBAction func editionButton(_ sender: Any) {
        if isEditor == false {
            editorBtn.title = "Done"
            scrollView.layer.borderWidth = 4
            scrollView.layer.borderColor = UIColor.red.cgColor
            centerPoint.isHidden = isEditor
            isEditor = true
            
        } else {
            editorBtn.title = "Editor"
            scrollView.layer.borderWidth = 0
            centerPoint.isHidden = isEditor
            isEditor = false
            
            let editorViewController = EditorContentViewController()
            
            editorViewController.zoom = scrollView.zoomScale
            editorViewController.x = scrollView.contentOffset.x/scrollView.zoomScale + scrollView.bounds.size.width/scrollView.zoomScale/2
            editorViewController.y = scrollView.contentOffset.y/scrollView.zoomScale + scrollView.bounds.size.height/scrollView.zoomScale/2
            
            self.show(editorViewController, sender: nil)
        }
    }
    func back() {
        isEditor = false
        scrollView.layer.borderWidth = 0
        centerPoint.isHidden = true
        editorBtn.title = "Editor"
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.title = "Editor"
        for marker in markerArray {
            marker.isHidden = false
        }
        dismiss()
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        back()
        UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
            self.scrollView.zoom(to: CGRect(x: 0, y: 0, width: (self.imageSize.width), height: (self.imageSize.height)), animated: false)
        })
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
   
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        for marker in markerArray {
            marker.framSet()
        }
    }
}

extension ViewController: THMarkerViewDelegate {
    func tapEvent(marker: THMarkerView) {
        for marker in markerArray {
            marker.isHidden = true
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.title = ""
        show(content: contentArray[marker.index])
    }
}

extension ViewController: THContentViewControllerDataSource {
    func setContentView(_ contentController: THContentViewController) -> [THContentWrapper] {
        let videoContentView = THVideoContentView()
        videoContentView.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
        videoContentView.setContentView()
        
        let audioContentView = THAudioContentView()
        audioContentView.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
        audioContentView.setContentView()
        
        let textContentView = THTextContentView()
        textContentView.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height*(1/5), width: self.view.frame.width, height: self.view.frame.height*(1/5))
        textContentView.setContentView()
        
        
        var contentArray: [THContentWrapper] = []
        contentArray.append(THContentWrapper(contentKey: "videoContent", contentView: videoContentView))
        contentArray.append(THContentWrapper(contentKey: "audioContent", contentView: audioContentView))
        contentArray.append(THContentWrapper(contentKey: "textContent", contentView: textContentView))
        
        return contentArray
    }
}
