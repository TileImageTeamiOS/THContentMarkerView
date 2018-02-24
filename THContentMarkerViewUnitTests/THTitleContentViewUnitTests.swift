//
//  THTitleContentViewUnitTests.swift
//  THContentMarkerViewUnitTests
//
//  Created by Seong ho Hong on 2018. 2. 20..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import XCTest
@testable import THContentMarkerView

class THTitleContentViewUnitTests: XCTestCase {
    let thTitleContent = THTitleContentView()

    override func setUp() {
        super.setUp()
        thTitleContent.setView(fontSize: 40)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSetView() {
        XCTAssertNotNil(thTitleContent.delegate)
    }

    func testSetContent() {
        // test set title content
        thTitleContent.delegate.setContent(info: "test title")
        XCTAssertNotEqual(thTitleContent.titleLabel.frame.size, CGSize.zero)
        XCTAssertEqual(thTitleContent.titleLabel.text, "test title")

        // test dismiss title content
        thTitleContent.delegate.dismiss()
        XCTAssertEqual(thTitleContent.titleLabel.frame.size, CGSize.zero)
        XCTAssertEqual(thTitleContent.titleLabel.text, "")
    }
}
