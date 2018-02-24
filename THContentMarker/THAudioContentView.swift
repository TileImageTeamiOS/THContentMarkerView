//
//  THAudioContentView.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 2. 9..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//
import UIKit
import AVFoundation

enum AudioStatus: Int {
    case play = 0
    case stop
    case finish
}

public class THAudioContentView: THContentView {
    var audioButton = UIButton()
    var audioCurrentTime = UILabel()
    var audioStatus = AudioStatus.stop
    
    var audioPlayer = AVPlayer()
    
    public func setContentView() {
        delegate = self
        audioButton.frame.origin = CGPoint.zero
        audioButton.frame.size = self.frame.size
        audioButton.setImage(UIImage(named: "audioPlay.png"), for: .normal)
        audioButton.alpha = 0.5
        audioButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        audioButton.addTarget(self, action: #selector(pressAudioButton(_:)), for: .touchUpInside)
        
        self.addSubview(audioButton)
        self.addSubview(audioCurrentTime)
    }
    
    func playAudio() {
        audioStatus = .play
        audioButton.setImage(UIImage(named: "audioPause.png"), for: .normal)
        //        audioPlayer?.play()
        audioPlayer.automaticallyWaitsToMinimizeStalling = false
        audioPlayer.playImmediately(atRate: 1.0)
    }
    
    func stopAudio() {
        audioButton.setImage(UIImage(named: "audioPlay.png"), for: .normal)
        audioStatus = .stop
        audioPlayer.pause()
    }
    
    @objc func pressAudioButton(_ sender: UIButton!) {
        if audioStatus == .stop {
            playAudio()
        } else if audioStatus == .play {
            stopAudio()
        } else if audioStatus == .finish {
            playAudio()
        }
    }
}

extension THAudioContentView: THContentViewDelegate {
    public func setContent(info: Any?) {
        if let url = info as? URL {
            audioPlayer = AVPlayer(url: url)
        }
        audioPlayer.allowsExternalPlayback = false
    }
    
    public func dismiss() {
        stopAudio()
    }
}

