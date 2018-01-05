//
//  VideoContentView.swift
//  ScrollViewMarker
//
//  Created by Seong ho Hong on 2018. 1. 5..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

enum VideoStatus: Int {
    case play = 0
    case pause
}

class VideoContentView: UIView {
    private var videoTapGestureRecognizer = UITapGestureRecognizer()
    var player =  AVPlayer()
    var videoStatus = VideoStatus.pause
    
    func setVideoPlayer() {
        videoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoViewTap(_:)))
        videoTapGestureRecognizer.delegate = self
        self.addGestureRecognizer(videoTapGestureRecognizer)
    }
    
    func setVideo(name: String, format: String) {
        let videoUrl = Bundle.main.url(forResource: name, withExtension: format)
        if let url = videoUrl {
            player =  AVPlayer(url: url)
            player.allowsExternalPlayback = false
            
            let layer: AVPlayerLayer = AVPlayerLayer(player: player)
            layer.frame = self.bounds
            layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.layer.addSublayer(layer)
        }
    }
    
    func setVideoUrl(url: URL) {
        player =  AVPlayer(url: url)
        player.allowsExternalPlayback = false
            
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.frame = self.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        self.layer.addSublayer(layer)
    }
    
    private func playVideo() {
        videoStatus = .play
        player.play()
    }
    
    private func pauseVideo() {
        videoStatus = .pause
        player.pause()
    }
}

extension VideoContentView: UIGestureRecognizerDelegate {
    @objc func videoViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if videoStatus == .pause {
            playVideo()
        } else {
            pauseVideo()
        }
    }
}
