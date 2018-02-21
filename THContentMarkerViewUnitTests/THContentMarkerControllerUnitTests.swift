//
//  THContentMarkerControllerUnitTests.swift
//  THContentMarkerViewUnitTests
//
//  Created by Seong ho Hong on 2018. 2. 20..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import XCTest
@testable import THContentMarkerView

class THContentMarkerControllerUnitTests: XCTestCase {
    var contentMarkerController = THContentMarkerController(duration: 3.0, delay: 0.0, initialSpringVelocity: 0.66)

    var scrollView = UIScrollView()
    var imageView = UIImageView()
    var view = UIView()

    // THData Set
    var markerArray = [THMarker]()
    var contentSetArray = [THContentSet]()

    override func setUp() {
        super.setUp()

        // view set
        imageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 4000, height: 5000))
        scrollView.addSubview(imageView)
        view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 400, height: 500))
        view.addSubview(scrollView)
        recenterImage()

        // content and merker set
        setContentView()
        setMarker()

        // content data source, view set
        contentMarkerController.dataSource = self
        contentMarkerController.set(parentView: self.view, scrollView: self.scrollView)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetContentMarker() {
        // set test, 'THMarker' and 'THMarkerView'
        XCTAssertEqual(markerArray.count, contentMarkerController.markerViewArray.count)
        // 'THContentSet' and 'THContentView'
        XCTAssertEqual(contentSetArray.count, contentMarkerController.contentSetArray.count)
    }

    func testReloadData() {
        // append 'THMarker' data
        markerArray.append(THMarker(zoomScale: CGFloat(2), origin: CGPoint(x: 3000, y: 5000), contentInfo: nil))
        contentMarkerController.reloadData()

        // if reload data, 'THMarkerView' reload.
        XCTAssertEqual(markerArray.count, contentMarkerController.markerViewArray.count)
    }

    func testMarkerHidden() {
        // if markerHidden is true, all 'THMarkerView' is Hidden
        contentMarkerController.markerHidden(bool: true)
        for contentMarker in contentMarkerController.markerViewArray {
            XCTAssertTrue(contentMarker.isHidden)
        }

        // if markerHidden is false, all 'THMarkerView' is not Hidden
        contentMarkerController.markerHidden(bool: false)
        for contentMarker in contentMarkerController.markerViewArray {
            XCTAssertFalse(contentMarker.isHidden)
        }
    }

    func testMarkerEvent() {
        // if tap marker, 'THMarkerView's content show
        contentMarkerController.tapEvent(marker: contentMarkerController.markerViewArray[0])
        XCTAssertFalse(contentMarkerController.contentSetArray[2].contentView.isHidden)

        // if dismiss the content, all 'THContentView' is Hidden
        contentMarkerController.contentDismiss()
        XCTAssertTrue(contentMarkerController.contentSetArray[2].contentView.isHidden)
    }
}

extension THContentMarkerControllerUnitTests: THContentMarkerControllerDataSource {
    func numberOfMarker(_ contentMarkerController: THContentMarkerController) -> Int {
        return markerArray.count
    }

    func setMarker(_ contentMarkerController: THContentMarkerController, markerIndex: Int) -> THMarker {
        return markerArray[markerIndex]
    }

    func numberOfContent(_ contentMarkerController: THContentMarkerController) -> Int {
        return contentSetArray.count
    }

    func setContentView(_ contentMarkerController: THContentMarkerController, contentSetIndex: Int) -> THContentSet {
        return contentSetArray[contentSetIndex]
    }

    func recenterImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = imageView.frame.size

        let horizontalSpace = imageSize.width < scrollViewSize.width ? (scrollViewSize.width - imageSize.width) / 2 : 0
        let verticalSpace = imageSize.height < scrollViewSize.height ? (scrollViewSize.height - imageSize.height) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace,
                                               bottom: verticalSpace, right: horizontalSpace)
    }

    // dummy content view
    func setContentView() {
        // contentView set
        let videoKey = "videoContent"
        let thVideoContent = THVideoContentView()
        thVideoContent.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
        thVideoContent.setContentView()
        contentSetArray.append(THContentSet(contentKey: videoKey, contentView: thVideoContent))

        let audioKey = "audioContent"
        let thAudioContent = THAudioContentView()
        thAudioContent.frame = CGRect(x: 0, y: 200, width: 80, height: 80)
        thAudioContent.setContentView()
        contentSetArray.append(THContentSet(contentKey: audioKey, contentView: thAudioContent))

        let titleKey = "titleContent"
        let thTitleContent = THTitleContentView()
        thTitleContent.frame.size = CGSize(width: 100, height: 50)
        thTitleContent.center = self.view.center
        thTitleContent.setView()
        contentSetArray.append(THContentSet(contentKey: titleKey, contentView: thTitleContent))

        let textKey = "textContent"
        let thTextContent = THTextContentView()
        thTextContent.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height*(1/5),
                                     width: self.view.frame.width,
                                     height: self.view.frame.height*(1/5))
        thTextContent.setContentView()
        contentSetArray.append(THContentSet(contentKey: textKey, contentView: thTextContent))
    }

    // dummy marker
    func setMarker() {
        // marker set
        var content1 = [String: Any?]()
        content1[contentSetArray[0].contentKey] = URL(string: "http://amd-ssl.cdn.turner.com/cnn/big/ads/2018/01/18/Tohoku_Hiking_digest_30_pre-roll_2_768x432.mp4")
        content1[contentSetArray[1].contentKey] = URL(string: "http://barronsbooks.com/tp/toeic/audio/hf28u/Track%2001.mp3")

        var content2 = [String: Any?]()
        content2[contentSetArray[2].contentKey] = "테스트"

        var textLink = [String: Any?]()
        textLink["link"] = "http://bit.ly/2DdfdJV"

        let text1 = "전직 오버워치 요원인 트레이서는 시간을 넘나서는 활기찬 모험가이다. 레나 옥스턴(호출명: 트레이서)은 오버워치의 실험 비행 프로그램에 투입된 최연소 참가자였다. 과감한 비행 기술로 명성을 떨친 그녀는 순간 이동 전투기의 프로토타입, '슬립 스트림'의 실험 대상으로 선발되었다."
        let text2 = "하지만 첫 비행에서 전투기는 순간 이동 매트릭스의 오작동에 의해 사라져 버렸고, 레나는 사망한 것으로 여겨졌다. 레나는 수 개월 후 다시 나타났으나, 이 비극은 그녀를 송두리째 바꿔버렸다. 레나의 분자 구조는 시간의 흐름을 따라가지 못하게 되었다."
        let text3 = "그녀는 살아 있는 유령이 되어, '시간과 분리된 상태'에서 몇 시간, 또는 며칠간 사라지며 고통받게 되었다. 심지어 잠깐 현재에 있을 때에도 물리적인 형태를 유지할 수 없었다. 누구보다 발전된 기술을 가진 오버워치의 의료진과 과학자들까지도 처음 겪어 보는 이 특이 사례에는 속수무책이었다."
        let text4 = "트레이서의 상황은 절망적이었으나, 윈스턴이라는 과학자가 트레이서를 현재에 묶을 수 있는 시간 가속기를 개발하며 상황은 반전을 맞았다. 시간 가속기 덕분에 트레이서는 자신의 시간을 조종해 마음대로 속도를 높이거나 줄일 수도 있게 되었다."
        let text5 = "새로 얻은 이 능력과 함께, 트레이서는 오버워치의 핵심 요원 중 하나로 거듭났다. 오버워치가 해체된 뒤, 트레이서는 기회가 있을 때마다 정의의 편에 서서 잘못된 것을 바로잡기 위해 싸우고 있다."
        textLink["text"] = text1 + text2 + text3 + text4 + text5

        content2[contentSetArray[3].contentKey] = textLink

        contentMarkerController.markerViewImage = #imageLiteral(resourceName: "marker")
        markerArray.append(THMarker(zoomScale: CGFloat(2), origin: CGPoint(x: 4000, y: 4000), contentInfo: content2))
        markerArray.append(THMarker(zoomScale: CGFloat(2.5), origin: CGPoint(x: 500, y: 500), contentInfo: content1))
        markerArray.append(THMarker(zoomScale: CGFloat(3), origin: CGPoint(x: 1000, y: 1000), contentInfo: nil))
        markerArray.append(THMarker(zoomScale: CGFloat(2), origin: CGPoint(x: 2000, y: 2000), contentInfo: content1))
        contentMarkerController.markerViewSize = CGSize(width: 18, height: 18)
    }
}
