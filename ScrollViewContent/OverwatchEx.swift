//
//  OverwatchEx.swift
//  Demo
//
//  Created by mac on 2018. 1. 15..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class OverwatchEx {
    var markerArray = [THMarkerView]()
    var contentArray = [Dictionary<String, Any>]()
    var contentViewController = ContentViewController()
    func setOverwatchEx(scrollView: UIScrollView, completionHandler:@escaping (Bool) -> ()) {
        Alamofire.request("http://127.0.0.1:5000/image1", method: .get).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let markers = json["markers"]
                    let markerNum = markers.array!.count
                    for i in 0..<markerNum {
                        let marker = THMarkerView()
                        var content = Dictionary<String, Any>()
                        let position = markers[i]["position"]
                        let x = position["x"].floatValue
                        let y = position["y"].floatValue
                        let zoomScale = position["zoomScale"].floatValue
                        let contents = markers[i]["contents"]
                        let video = contents["video"].description
                        let audio = contents["audio"].description
                        let textContent = contents["textContent"]
                        let title = textContent["title"].description
                        let text = textContent["text"].description
                        let link = textContent["link"].description
                        let textTitle = textContent["textTitle"].description
                        
                        marker.frame.size =  CGSize(width: 20, height: 20)
                        marker.set(origin: CGPoint(x: CGFloat(x), y: CGFloat(y)), zoomScale: CGFloat(zoomScale), scrollView: scrollView)
                        marker.setImage(markerImage: UIImage(named: "marker.png")!)
                        marker.index = i
                        
                        if video != "" {
                            content["thVideoContentView"] = URL(string: video)
                        }
                        if audio != "" {
                            content["thAudioContentView"] = URL(string: audio)
                        }
                        if !(textTitle == "" && text == "" && link == "") {
                            content["thTextContentView"] = textContent
                        }
                        
//                        marker.setTitle(title: title)
//                        marker.setText(title: textTitle, link: link, content: text)
//                        marker.setAudioContent(audioUrl: audio)
//                        marker.setVideoContent(videoUrl: video)
                        self.markerArray.append(marker)
                        self.contentArray.append(content)
                    }
                    completionHandler(true)
                case .failure(let error):
                    print(error)
                    completionHandler(false)
                }
        }
    }
}


