//
//  AudioContentView.swift
//  ScrollViewMarker
//
//  Created by Seong ho Hong on 2018. 1. 4..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//
import UIKit
import AVFoundation

enum AudioStatus: Int {
    case play = 0
    case stop
    case finish
}

public class AudioContentView: UIView {
    var audioButton = UIButton()
    var audioCurrentTime = UILabel()
    var audioStatus = AudioStatus.stop

    var audioUrl: URL?
    var audioPlayer: AVPlayer?

    func setAudioPlayer() {
        audioButton.frame.origin = CGPoint.zero
        audioButton.frame.size = self.frame.size
        audioButton.setImage(UIImage(named: "audioPlay.png"), for: .normal)
        audioButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        audioButton.addTarget(self, action: #selector(pressAudioButton(_:)), for: .touchUpInside)

        self.addSubview(audioButton)
        self.addSubview(audioCurrentTime)
    }

    func setAudio(url: URL) {
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.allowsExternalPlayback = false
    }

    func playAudio() {
        audioStatus = .play
        audioButton.setImage(UIImage(named: "audioPause.png"), for: .normal)
    }

    func stopAudio() {
        audioButton.setImage(UIImage(named: "audioPlay.png"), for: .normal)
        audioStatus = .stop
        audioPlayer?.pause()
    }

    @objc func pressAudioButton(_ sender: UIButton!) {
        if audioStatus == .stop{
            playAudio()
        } else if audioStatus == .play {
            stopAudio()
        } else if audioStatus == .finish {
            playAudio()
        }
    }
}


