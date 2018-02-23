//
//  THTextContentViewUnitTests.swift
//  THContentMarkerViewUnitTests
//
//  Created by Seong ho Hong on 2018. 2. 20..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import XCTest
@testable import THContentMarkerView

class THTextContentViewUnitTests: XCTestCase {
    let thTextContent = THTextContentView()
    var textLink = [String: String]()

    override func setUp() {
        super.setUp()
        // test set view
        thTextContent.frame = CGRect(x: 0, y: 300,
                                     width: 100,
                                     height: 50)
        thTextContent.setContentView(upYFloat: 40)

        // test set content
        textLink["title"] = "test"

        textLink["link"] = "http://bit.ly/2DdfdJV"

        let text1 = "전직 오버워치 요원인 트레이서는 시간을 넘나서는 활기찬 모험가이다. 레나 옥스턴(호출명: 트레이서)은 오버워치의 실험 비행 프로그램에 투입된 최연소 참가자였다. 과감한 비행 기술로 명성을 떨친 그녀는 순간 이동 전투기의 프로토타입, '슬립 스트림'의 실험 대상으로 선발되었다."
        let text2 = "하지만 첫 비행에서 전투기는 순간 이동 매트릭스의 오작동에 의해 사라져 버렸고, 레나는 사망한 것으로 여겨졌다. 레나는 수 개월 후 다시 나타났으나, 이 비극은 그녀를 송두리째 바꿔버렸다. 레나의 분자 구조는 시간의 흐름을 따라가지 못하게 되었다."
        let text3 = "그녀는 살아 있는 유령이 되어, '시간과 분리된 상태'에서 몇 시간, 또는 며칠간 사라지며 고통받게 되었다. 심지어 잠깐 현재에 있을 때에도 물리적인 형태를 유지할 수 없었다. 누구보다 발전된 기술을 가진 오버워치의 의료진과 과학자들까지도 처음 겪어 보는 이 특이 사례에는 속수무책이었다."
        let text4 = "트레이서의 상황은 절망적이었으나, 윈스턴이라는 과학자가 트레이서를 현재에 묶을 수 있는 시간 가속기를 개발하며 상황은 반전을 맞았다. 시간 가속기 덕분에 트레이서는 자신의 시간을 조종해 마음대로 속도를 높이거나 줄일 수도 있게 되었다."
        let text5 = "새로 얻은 이 능력과 함께, 트레이서는 오버워치의 핵심 요원 중 하나로 거듭났다. 오버워치가 해체된 뒤, 트레이서는 기회가 있을 때마다 정의의 편에 서서 잘못된 것을 바로잡기 위해 싸우고 있다."
        textLink["text"] = text1 + text2 + text3 + text4 + text5
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetContentView() {
        XCTAssertNotNil(thTextContent.delegate)
        XCTAssertNotEqual(thTextContent.contentScrollView.frame, CGRect.zero)
        XCTAssertEqual(thTextContent.upImageView.image, UIImage(named: "up.png"))

        // test set upFloat set
        thTextContent.frameSet(upYFloat: 30)
        XCTAssertEqual(thTextContent.upYFloat, 30)
    }

    func testSetContent() {
        // test set text content
        thTextContent.delegate.setContent(info: textLink)
        XCTAssertNotEqual(thTextContent.titleLable.frame.size, CGSize.zero)
        XCTAssertNotEqual(thTextContent.titleLable.text, "")
        XCTAssertNotEqual(thTextContent.linkLable.frame.size, CGSize.zero)
        XCTAssertNotEqual(thTextContent.linkLable.text, "")
        XCTAssertNotEqual(thTextContent.textLabel.frame.size, CGSize.zero)
        XCTAssertNotEqual(thTextContent.textLabel.text, "")

        // test dismiss text content
        thTextContent.delegate.dismiss()
        XCTAssertEqual(thTextContent.titleLable.frame.size, CGSize.zero)
        XCTAssertEqual(thTextContent.titleLable.text, "")
        XCTAssertEqual(thTextContent.linkLable.frame.size, CGSize.zero)
        XCTAssertEqual(thTextContent.linkLable.text, "")
        XCTAssertEqual(thTextContent.textLabel.frame.size, CGSize.zero)
        XCTAssertEqual(thTextContent.textLabel.text, "")
    }
}
