//
//  THVideoContentViewTests.swift
//  THContentMarkerViewUnitTests
//
//  Created by Seong ho Hong on 2018. 2. 19..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import XCTest
@testable import THContentMarkerView

class THVideoContentViewTests: XCTestCase {
    let thVideoContent = THVideoContentView()

    override func setUp() {
        super.setUp()
        thVideoContent.setContentView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetContentView() {
        // set contentView
        XCTAssertNotNil(thVideoContent.delegate)
        XCTAssertNotNil(thVideoContent.fullscreenButton.frame)
        XCTAssertNotNil(thVideoContent.videoButton.frame)
    }

    func testContent() {
        // set video content
        thVideoContent.delegate.setContent(info: URL(string: "http://amd-ssl.cdn.turner.com/cnn/big/ads/2018/01/18/Tohoku_Hiking_digest_30_pre-roll_2_768x432.mp4"))

        // test videoContent play
        thVideoContent.playVideo()
        XCTAssertEqual(thVideoContent.playStatus, PlayStatus.play)
        XCTAssertEqual(thVideoContent.videoStatus, VideoStatus.show)
        XCTAssertEqual(thVideoContent.videoButton.imageView?.image, UIImage(named: "pauseBtn.png"))

        // test videoContent pause
        thVideoContent.pauseVideo()
        XCTAssertEqual(thVideoContent.playStatus, PlayStatus.pause)
        XCTAssertEqual(thVideoContent.videoButton.imageView?.image, UIImage(named: "playBtn.png"))

        // test videoContent pressVideoButton
        thVideoContent.pressVideoButton(nil)
        XCTAssertEqual(thVideoContent.playStatus, PlayStatus.play)

        // test videoContent pressfullscreenButton
        thVideoContent.pressfullscreenButton(nil)

        // test videoContent dismiss
        thVideoContent.delegate.dismiss()
        XCTAssertEqual(thVideoContent.playStatus, PlayStatus.pause)
        XCTAssertEqual(thVideoContent.videoStatus, VideoStatus.hide)
    }
}
