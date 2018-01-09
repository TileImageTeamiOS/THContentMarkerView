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
        
        marker.set(dataSource: markerDataSource, x: x as! Double, y: y as! Double, zoomScale: zoom as! Double, isTitleContent: true, isAudioContent: isAudioContent as! Bool, isVideoContent: isVideoContent as! Bool, markerTitle: markerTitle! as! String)
        
        marker.setAudioContent(url: audioURL as! URL)
        marker.setVideoContent(url: videoURL as! URL)
        marker.setTitle(title: markerTitle as! String)
        
        back()
        markerArray.append(marker)
    }
    
    @objc func click(){
        for marker in markerArray{
            marker.click()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(click), name: NSNotification.Name(rawValue: "click"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addMarker), name: NSNotification.Name(rawValue: "makeMarker"), object: nil)
        scrollView.contentInsetAdjustmentBehavior = .never
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
        videoContentView.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 30, width: 150, height: 100)
        self.view.addSubview(videoContentView)
        
        // markerData Source 설정
        markerDataSource = MarkerViewDataSource(scrollView: scrollView, imageView: imageView, ratioByImage: 275, titleLabelView: titleLabel, audioContentView: audioContentView, videoContentView: videoContentView)
        
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
        
//        let textContentView = TextContentView(frame: CGRect(x: 0, y: self.view.frame.height - 80, width: self.view.frame.width, height: 100) )
//        textContentView.setTextContent()
//        textContentView.backgroundColor = UIColor.brown
//        self.view.addSubview(textContentView)
    }
    
    override func viewWillLayoutSubviews() {
        setZoomParametersForSize(scrollView.bounds.size)
        recenterImage()
    }
    
    @IBAction func editionButton(_ sender: Any) {
        if isEditor == false {
            editorBtn.title = "done"
            scrollView.layer.borderWidth = 4
            scrollView.layer.borderColor = UIColor.red.cgColor
            centerPoint.isHidden = isEditor
            //markerView.setOpacity(alpha: 0)
            isEditor = true
            
        } else {
            editorBtn.title = "editor"
            scrollView.layer.borderWidth = 0
            centerPoint.isHidden = isEditor
            //markerView.setOpacity(alpha: 1)
            isEditor = false
            performSegue(withIdentifier: "editor", sender: editorBtn)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editor") {
            let vc = segue.destination as! EditorViewController
            vc.zoom = Double(scrollView.zoomScale)
            vc.x = Double(scrollView.contentOffset.x/scrollView.zoomScale + scrollView.bounds.size.width/scrollView.zoomScale/2)
            vc.y = Double(scrollView.contentOffset.y/scrollView.zoomScale + scrollView.bounds.size.height/scrollView.zoomScale/2)
        }
    }
    func back() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "back"), object: nil)
        editorBtn.title = "editor"
        scrollView.layer.borderWidth = 0
        centerPoint.isHidden = true
        //markerView.setOpacity(alpha: 1)
        isEditor = false
        markerDataSource.videoContentView?.isHidden = true
        markerDataSource.audioContentView?.isHidden = true
        markerDataSource.titleLabelView?.isHidden = true
        
        var destinationRect: CGRect = .zero
        destinationRect.size.width = (imageView.image?.size.width)!
        destinationRect.size.height = (imageView.image?.size.height)!
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 3.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
            self.scrollView.zoom(to: destinationRect, animated: false)
        }, completion: {
            completed in
            if let delegate = self.scrollView.delegate, delegate.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:))), let view = delegate.viewForZooming?(in: self.scrollView) {
                delegate.scrollViewDidEndZooming!(self.scrollView, with: view, atScale: 1.0)
            }
        })
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
       back()
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
}
