//
//  THAudioContentViewTests.swift
//  THContentMarkerViewUnitTests
//
//  Created by Seong ho Hong on 2018. 2. 19..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import XCTest
@testable import THContentMarkerView

class THAudioContentViewUnitTests: XCTestCase {
    let thAudioContent = THAudioContentView()

    override func setUp() {
        super.setUp()
        thAudioContent.setContentView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetContentView() {
        // set contentView
        XCTAssertNotNil(thAudioContent.delegate)
        XCTAssertNotNil(thAudioContent.audioButton.frame)
        XCTAssertEqual(thAudioContent.audioButton.imageView?.image, UIImage(named: "audioPlay.png"))
    }

    func testContent() {
        // set audio content
        thAudioContent.delegate.setContent(info: URL(string: "http://barronsbooks.com/tp/toeic/audio/hf28u/Track%2001.mp3"))

        // test audioContent play
        thAudioContent.playAudio()
        XCTAssertEqual(thAudioContent.audioStatus, AudioStatus.play)
        XCTAssertEqual(thAudioContent.audioButton.imageView?.image, UIImage(named: "audioPause.png"))

        // test audioContent stop
        thAudioContent.stopAudio()
        XCTAssertEqual(thAudioContent.audioStatus, AudioStatus.stop)
        XCTAssertEqual(thAudioContent.audioButton.imageView?.image, UIImage(named: "audioPlay.png"))

        // test press button
        // when stop
        thAudioContent.pressAudioButton(nil)
        XCTAssertEqual(thAudioContent.audioStatus, AudioStatus.play)
        XCTAssertEqual(thAudioContent.audioButton.imageView?.image, UIImage(named: "audioPause.png"))
        // when play
        thAudioContent.pressAudioButton(nil)
        XCTAssertEqual(thAudioContent.audioStatus, AudioStatus.stop)
        XCTAssertEqual(thAudioContent.audioButton.imageView?.image, UIImage(named: "audioPlay.png"))

        // test dismiss content
        thAudioContent.delegate.dismiss()
        XCTAssertEqual(thAudioContent.audioStatus, AudioStatus.stop)
        XCTAssertEqual(thAudioContent.audioButton.imageView?.image, UIImage(named: "audioPlay.png"))
    }
}
