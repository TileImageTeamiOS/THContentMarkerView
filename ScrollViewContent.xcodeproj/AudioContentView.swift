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
}

class AudioContentView: UIView {
    var audioButton = UIButton()
    var audioCurrentTime = UILabel()
    var audioStatus = AudioStatus.stop
    
    private var audioUrl: URL?
    private var audioPlayer: AVAudioPlayer?
    private var audioIntever = TimeInterval()
    
    func setAudioPlayer() {
        //버튼 세팅
        audioButton.frame = CGRect(x: CGFloat(Double(self.frame.width - 50)/2),
                                   y: CGFloat(10),
                                   width: CGFloat(50),
                                   height: CGFloat(50))
        audioButton.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        audioButton.addTarget(self, action: #selector(pressAudioButton(_:)), for: .touchUpInside)
        
        //시간 라벨 세팅
        audioCurrentTime.frame = CGRect(x: 0, y: self.frame.width - 20, width: self.frame.width, height: 20)
        audioCurrentTime.backgroundColor = UIColor.yellow
        
        self.addSubview(audioButton)
        self.addSubview(audioCurrentTime)
    }
    
    func setAudio(name: String, format: String) {
        audioUrl = Bundle.main.url(forResource: name, withExtension: format)
        
        if let url = audioUrl {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                guard let sound = audioPlayer else { return }
                sound.prepareToPlay()
            } catch let error {
                print(error)
            }
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
        } else {
            stopAudio()
        }
    }
}
