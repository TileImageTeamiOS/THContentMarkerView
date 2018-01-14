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
    var audioContentView = AudioContentView()
    var videoContentView = VideoContentView()
    var textContentView = TextContentView()
    var titleLabel = UILabel()
    
    var minimapDataSource: MinimapDataSource!
    var markerDataSource: MarkerViewDataSource!
    var isEditor = false
    var centerPoint = UIView()
    var markerArray = [MarkerView]()

    @objc func addMarker(_ notification: NSNotification){
        let marker = MarkerView()
        
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
        
        marker.set(dataSource: markerDataSource, x: CGFloat(x as! Double), y: CGFloat(y as! Double), zoomScale: CGFloat(zoom as! Double), isTitleContent: true, isAudioContent: isAudioContent as! Bool, isVideoContent: isVideoContent as! Bool, isTextContent: isText as! Bool)
        
        marker.setAudioContent(url: audioURL as! URL)
        marker.setVideoContent(url: videoURL as! URL)
        marker.setTitle(title: markerTitle as! String)
        marker.setText(title: "", link: link as! String, content: text as! String)
        marker.setMarkerImage(markerImage: #imageLiteral(resourceName: "page"))
        
        markerArray.append(marker)
        markerDataSource.framSet(markerView: marker)
        markerDataSource.reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(addMarker), name: NSNotification.Name(rawValue: "makeMarker"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showMarker), name: NSNotification.Name(rawValue: "showMarker"), object: nil)
//        scrollView.contentInsetAdjustmentBehavior = .never
        imageView.frame.size = (imageView.image?.size)!
        scrollView.delegate = self

        // title contentView 설정
        titleLabel.center = self.view.center
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font.withSize(20)
        self.view.addSubview(titleLabel)
        
        // audio contentView 설정
        audioContentView.frame = CGRect(x: 0, y: 200, width: 80, height: 80)
        self.view.addSubview(audioContentView)
        
        // video contentview 설정
        videoContentView.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
        self.view.addSubview(videoContentView)
        
        // text contentView 설정
        textContentView.frame = CGRect(x: 0, y: self.view.frame.height - 80, width: self.view.frame.width, height: 100)
        self.view.addSubview(textContentView)
        
        // markerData Source 설정
        markerDataSource = MarkerViewDataSource(scrollView: scrollView, imageView: imageView, ratioByImage: 200, titleLabelView: titleLabel, audioContentView: audioContentView, videoContentView: videoContentView, textContentView: textContentView)
        
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
        markerDataSource?.reset()
        for marker in markerArray {
            marker.isSelected = false
            marker.isHidden = false
        }

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
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scollViewAction"), object: nil, userInfo: nil)
    }
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scollViewAction"), object: nil, userInfo: nil)
        markerArray.map { marker in
            markerDataSource?.framSet(markerView: marker)
        }
    }
}
