# THContentMarkerView

## Feature
- [x] 📄'UIScrollView' 위에 컨텐츠가 담긴 마커를 찍을수 있습니다.
- [x] 🛫'THMarkerView'는 'UIScrollView'에 origin과  zoomScale이 담겨있어서, 해당 위치로 가는 카메라 오토파일럿 기능을 합니다.
- [x] 🎥'THContentMarkerView'에서는 기본 콘텐츠로 'THVideoContentView', 'THAudioContentView', 'THTextContentView', 'THTitleContentView'를 제공합니다.
- [x] 👍이 외에 원하시는 콘텐츠 뷰를 만들고 싶다면, 'THContentView'를 상속받아 만들수 있습니다.

## Demo
![THContentMarkerView](Image/THContentMarkerView.gif)

## Installation

### CocoaPods

To integrate ```THContentMarkerView``` into your Xcode project using CocoaPods, specify it in your Podfile:

```
pod "THContentMarkerView"
```

## Requirement

THContentMarkerView is written in Swift 4, and compatible with iOS 9.0+

## How to use

1. 'THContentMarkerView'는 기본적으로 'THMarker', 'THContentSet' 2가지 데이터 모델을 이용해서 컨트롤을 할수 있습니다.

  - THMarker : 'THMarker'는 마커의 origin과 zoomScale, contentInfo를 가지고 있습니다.
    - ```zoomScale``` : 마커를 탭했을때 'UIScrollView'에 세팅될 zoomScale
    - ```origin``` : 마커가 그려질 위치
    - ```markerID``` : 마커를 구별알 identifier
    - ```contnetInfo``` : 컨텐츠 뷰에 들어갈 key값과 info Dictionary

  ```Swift
  // 콘텐츠가 없는 'THMarker'를 만들때
  var markerArray = [THMarker]()

  func setMarker() {
      // 마커 생성
        markerArray.append(THMarker(zoomScale: CGFloat(3),
                                          origin: CGPoint(x: 1000, y: 1000),
                                          markerID: "markerIdentifier",
                                          contentInfo: [:]))
  }
  ```

  - THContentSet: 'THContentSet'은 해당 프로젝트에서 사용할 'THContentView'와 해당 뷰의 Key를 가지고 있습니다. <br>
  (해당 라이브러리에선 기본적으로  'THVideoContentView', 'THAudioContentView', 'THTextContentView', 'THTitleContentView'를 제공합니다.)

  ```Swift
  // 기본 'THContentView' 세팅
  var contentSetArray = [THContentSet]()

  func setContentView() {
      // 해당 'THContentView'의 key  세팅
      let videoContentKey = "videoContent"
      let audioContentKey = "audioContent"
      let titleContentKey = "titleContent"
      let textContentKey = "textContent"

    // THVideoView Set 예제
    let videoContent = THVideoContentView()
    let videoFrame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
    videoContnetKey.setContentView(frame: videoFrame)
  contentSetArray.append(THContentSet(contentKey: videoContentKey, contentView: videoContent))

    // THAdioContentView Set 예제
    let audioContent = THAudioContentView()
    audioContent.frame = CGRect(x: 0, y: 200, width: 80, height: 80)
    audioContent.setContentView()
    contentSetArray.append(THContentSet(contentKey: audioContentKey, contentView: audioContent))

    // THTitleContentView Set 예제
    let titleContent = THTitleContentView()
    titleContent.frame.size = CGSize(width: 100, height: 50)
    titleContent.center = self.view.center
    titleContent.setView(fontSize: 25)
    contentSetArray.append(THContentSet(contentKey: titleContentKey, contentView: titleContent))

    // THTextContentView Set 예제
    let textContent = THTextContentView()
    textContent.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height*(1/5),  width: self.view.frame.width, height: self.view.frame.height*(1/5))
    textContent.setContentView(upYFloat: 180)
    contentSetArray.append(THContentSet(contentKey: textContentKey, contentView: textContent))
  }
  ```
2. 만약 필요한 콘텐츠를 보여주고 싶다면, 'THContentView'를 상속받아 구현해 주시면 됩니다.
  ```Swift
  // 컨텐츠뷰 만들기 예제
  public class THExampleContentView: THContentView {
    public setExampleContent {
      // 콘텐츠뷰의 delegate를 설정해 줍니다.
      delegate = self
    }
  }

  extension THExampleContentView: THContentViewDelegate {
    public func setContent(info: Any?) {

    }

    public func dismiss() {

    }
  }
  ```
3. 'THContentMarkerController'를 호출하고 dataSource, delegate를 구현해 줍니다.
  ```swift
  // 'THContentMarkerController'를 호출하면서 마커의 줌 속도를 지정해 줍니다.
  class ViewController: UIViewController {

    var contentMarkerController = THContentMarkerController(duration: 3.0, delay: 0.0, initialSpringVelocity: 0.66)
    var markerArray = [THMarker]()
    var contentSetArray = [THContentSet]()

    override func viewDidLoad() {
       super.viewDidLoad()

       contentMarkerController.dataSource = self
       contentMarkerController.delegate = self

       contentMarkerController.set(parentView: self.view, scrollView: self.scrollView)

       setMarker()
       setContentView()
    }
 }
 // 'THContentMarkerControllerDataSource'에서는 'THMarker'와 'THContentSet'을 반환해 줍니다.
 extension ViewController: THContentMarkerControllerDataSource {
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
}
//'THContentMarkerControllerDelegate'에서는 마커를 클릭했을때 이벤트를 구현할수 있습니다.
extension  ViewController: THContentMarkerControllerDelegate {
  func markerTap(_ contentMarkerController: THContentMarkerController, markerView: THMarkerView) {
        // 만약 마커를 선택했을때 마커를 사라지게 하고 싶으면 추가해 줍니다.
        contentMarkerController.markerHidden(bool: true)
    }
}
```

### THContentMarkerView

- ```set(parentView: UIView, scrollView: UIScrollView)``` : 마커가 그려질 UIScrollView와 콘텐츠를 보여줄 UIView를 설정합니다.
- ```reloadData()``` : 만약 'THMarker'가 추가되거나 삭제될 경우 reloadData()를 이용하여 'THContentMarkerController'에 데이터를 reload해줍니다.
- ```setMarkerFrame()``` : 마커가 'UIScrollView'위에 있을때 zoom여부와 scroll 여부에 따라 마커의 frame을 바꿔줍니다.
- ```markerHidden(bool: Bool)``` : 마커의 Hidden 여부를 정합니다.
- ```contentDismiss()``` : 마커의 콘텐츠를 Dismiss 합니다.
- ```markerViewSize``` : 마커의 크기를 지정할수 있습니다.
- ```markerViewImage``` : 마커의 이미지를 지정할수 있습니다.
