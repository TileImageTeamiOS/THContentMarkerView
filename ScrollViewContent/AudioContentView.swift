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
    var audioPlayer: AVAudioPlayer?
    var audioIntever = TimeInterval()

    func setAudioPlayer() {
        self.backgroundColor = UIColor.white
        
        audioButton.frame.origin = CGPoint.zero
        audioButton.frame.size = self.frame.size
        audioButton.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        audioButton.addTarget(self, action: #selector(pressAudioButton(_:)), for: .touchUpInside)

        self.addSubview(audioButton)
        self.addSubview(audioCurrentTime)
    }

    func setAudio(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            guard let sound = audioPlayer else { return }
            sound.prepareToPlay()
        } catch let error {
            print(error)
        }
    }

    func playAudio() {
        audioStatus = .play
        audioButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
        if audioIntever == 0.0 {
            audioPlayer?.play()
        } else {
            audioPlayer?.play(atTime: audioIntever)
        }
    }

    func stopAudio() {
        audioButton.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        audioStatus = .stop
        audioPlayer?.stop()
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

extension AudioContentView: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioStatus = .finish
        audioButton.setImage(#imageLiteral(resourceName: "replay"), for: .normal)
    }
}

