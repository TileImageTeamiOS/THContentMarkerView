//
//  ViewController.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2017. 12. 31..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var editorBtn: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var minimapView: MinimapView!
    @IBOutlet weak var minimapHeight: NSLayoutConstraint!
    @IBOutlet weak var minimapWidth: NSLayoutConstraint!
    
    // THContent
    var contentArray: [THContent] = []
    var contentViewController = THContentViewController()
    
    var minimapDataSource: MinimapDataSource!
    var isEditor = false
    var centerPoint = UIView()
    var markerArray = [THMarkerView]()

    @objc func addMarker(_ notification: NSNotification){
        let x = notification.userInfo?["x"]
        let y = notification.userInfo?["y"]
        let zoom =  notification.userInfo?["zoomScale"]
        let isAudioContent = notification.userInfo?["isAudioContent"]
        let isVideoContent = notification.userInfo?["isVideoContent"]
        let videoURL = notification.userInfo?["videoURL"]
        let audioURL = notification.userInfo?["audioURL"]
        let markerTitle = notification.userInfo?["title"]
        let link = notification.userInfo?["link"]
        let text = notification.userInfo?["text"]
        let isText = notification.userInfo?["isText"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(addMarker), name: NSNotification.Name(rawValue: "makeMarker"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showMarker), name: NSNotification.Name(rawValue: "showMarker"), object: nil)
        scrollView.contentInsetAdjustmentBehavior = .never
        imageView.frame.size = (imageView.image?.size)!
        scrollView.delegate = self
        
//        UICollectionView
        let marker = THMarkerView()
        marker.frame.size =  CGSize(width: 20, height: 20)
        marker.set(origin: CGPoint(x:1500, y:1500), zoomScale: 2.0, scrollView: scrollView)
        marker.setImage(markerImage: UIImage(named: "marker.png")!)
        
         marker.delegate = self
        
        marker.index = markerArray.count
        markerArray.append(marker)
        
        let marker1 = THMarkerView()
        marker1.frame.size =  CGSize(width: 20, height: 20)
        marker1.set(origin: CGPoint(x:1800, y:2000), zoomScale: 3.0, scrollView: scrollView)
        marker1.setImage(markerImage: UIImage(named: "marker.png")!)
        
        marker1.delegate = self
        
        marker1.index = markerArray.count
        markerArray.append(marker1)
        
        let marker2 = THMarkerView()
        marker2.frame.size =  CGSize(width: 20, height: 20)
        marker2.set(origin: CGPoint(x:2100, y:2300), zoomScale: 4.0, scrollView: scrollView)
        marker2.setImage(markerImage: UIImage(named: "marker.png")!)
        
        marker2.delegate = self
        
        marker2.index = markerArray.count
        markerArray.append(marker2)
        
        // minimap 설정
        minimapDataSource = MinimapDataSource(scrollView: scrollView, image: imageView.image!, borderWidth: 2, borderColor: UIColor.yellow.cgColor, ratio: 70.0)
        minimapView.set(dataSource: minimapDataSource, height: minimapHeight, width: minimapWidth)
        
        setZoomParametersForSize(scrollView.bounds.size)
        recenterImage()
        
        // edit center point 설정
        centerPoint.frame = CGRect(x: view.frame.width/2, y: view.frame.height/2 + scrollView.frame.origin.y/2, width: CGFloat(10), height: CGFloat(10))
        centerPoint.backgroundColor = UIColor.red
        centerPoint.layer.cornerRadius = 5
        
        self.view.addSubview(centerPoint)
        centerPoint.isHidden = true
        doneButton.isHidden = true
        
//        // thVideoContentView 설정
//        thVideoContentView.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
//        thVideoContentView.identifier = "thVideoContentView"
//        contentViewController.set(contentView: thVideoContentView, parentView: self.view)
//
//        // thAudioContentView 설정
//        thAudioContentView.frame = CGRect(x: 0, y: 200, width: 80, height: 80)
//        thAudioContentView.identifier = "thAudioContentView"
//        contentViewController.set(contentView: thAudioContentView, parentView: self.view)
        
        // content dict 설정
//        var videoContentDict = Dictionary<String, Any>()
//        videoContentDict["thVideoContentView"] = URL(string: "http://amd-ssl.cdn.turner.com/cnn/big/ads/2018/01/18/Tohoku_Hiking_digest_30_pre-roll_2_768x432.mp4")
//        contentArray.append(videoContentDict)
//
//        var audioContentDict = Dictionary<String, Any>()
//        audioContentDict["thAudioContentView"] = URL(string: "http://barronsbooks.com/tp/toeic/audio/hf28u/Track%2001.mp3")
//        contentArray.append(audioContentDict)
        
        // content dict 설정
        var content1 = Dictionary<String, Any>()
        content1["videoContent"] = URL(string: "http://amd-ssl.cdn.turner.com/cnn/big/ads/2018/01/18/Tohoku_Hiking_digest_30_pre-roll_2_768x432.mp4")
        contentArray.append(THContent(contentInfo: content1))
    
        var content2 = Dictionary<String, Any>()
        content2["audioContent"] = URL(string: "http://barronsbooks.com/tp/toeic/audio/hf28u/Track%2001.mp3")
        contentArray.append(THContent(contentInfo: content2))
        
        contentViewController.dataSource = self
        contentViewController.set(parentView: self.view)
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
            
            editorViewController.zoom = Double(scrollView.zoomScale)
            editorViewController.x = Double(scrollView.contentOffset.x/scrollView.zoomScale + scrollView.bounds.size.width/scrollView.zoomScale/2)
            editorViewController.y = Double(scrollView.contentOffset.y/scrollView.zoomScale + scrollView.bounds.size.height/scrollView.zoomScale/2)
            
            self.show(editorViewController, sender: nil)
        }
    }
    
    @objc func showMarker(){
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.title = ""
        for marker in markerArray {
            marker.isHidden = true
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        isEditor = false
        scrollView.layer.borderWidth = 0
        centerPoint.isHidden = true
        editorBtn.title = "Editor"
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.title = "Editor"
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scollViewAction"), object: nil, userInfo: nil)
    }
   
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        markerArray.map { marker in
            marker.framSet()
        }
    }
}

extension ViewController: THMarkerViewDelegate {
    func tapEvent(marker: THMarkerView) {
        contentViewController.show(content: contentArray[marker.index])
    }
}

extension ViewController: THContentViewControllerDataSource {
    func setContentView(_ contentController: THContentViewController) -> [THContentView] {
        let videoContentView = THVideoContentView()
        videoContentView.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
        videoContentView.setContentView()
        
        return [videoContentView]
    }
    
    func setContentKey(_ contentController: THContentViewController) -> [String] {
        return ["videoContent"]
    }
}
