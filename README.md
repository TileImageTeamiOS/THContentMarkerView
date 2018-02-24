# THContentMarkerView

## Feature
- [x] 📄'You can take a marker containing content above the ``` UIScrollView ```.
- [x] 🛫'```THMarkerView``` has origin and zoomScale in ```UIScrollView``` so it functions as a camera autopilot to that position.
- [x] 🎥```THContentMarkerView``` provides ```THVideoContentView```, ```THAudioContentView```, ```THTextContentView```, and ```THTitleContentView``` as default content.
- [x] 👍If you want to create a content view of your choice, you can make your content view that inherit ```THContentView```.

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

1. ```THContentMarkerView``` can basically be controlled using two data models ```THMarker``` and ```THContentSet```.

  - THMarker : ``` THMarker``` has marker origin, zoomScale, and contentInfo.
    - ```zoomScale``` : zoomScale to be set to ```UIScrollView``` when the marker is tapped
    - ```origin``` : Where the marker will be drawn on the ```UIScrollView```
    - ```markerID``` : Identifier to distinguish markers
    - ```contnetInfo``` : The key value to enter the content view and the info dictionary

  ```Swift
  // When creating 'THMarker' with no content
  var markerArray = [THMarker]()

  func setMarker() {
      // set 'THMarker'
        markerArray.append(THMarker(zoomScale: CGFloat(3),
                                          origin: CGPoint(x: 1000, y: 1000),
                                          markerID: "markerIdentifier",
                                          contentInfo: [:]))
  }
  ```

  - THContentSet: ```THContentSet``` has ```THContentView``` and the key of the view to use in the project. <br>
  (The library provides ```THVideoContentView```, ```THAudioContentView```, ```THTextContentView```, and ```THTitleContentView``` by default.)

  ```Swift
  //  'THContentView' setting
  var contentSetArray = [THContentSet]()

  func setContentView() {
      // key Generation
      let videoContentKey = "videoContent"
      let audioContentKey = "audioContent"
      let titleContentKey = "titleContent"
      let textContentKey = "textContent"

    // THVideoView set example
    let videoContent = THVideoContentView()
    let videoFrame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
    videoContnetKey.setContentView(frame: videoFrame)
  contentSetArray.append(THContentSet(contentKey: videoContentKey, contentView: videoContent))

    // THAudioContentView set example
    let audioContent = THAudioContentView()
    audioContent.frame = CGRect(x: 0, y: 200, width: 80, height: 80)
    audioContent.setContentView()
    contentSetArray.append(THContentSet(contentKey: audioContentKey, contentView: audioContent))

    // THTitleContentView set example
    let titleContent = THTitleContentView()
    titleContent.frame.size = CGSize(width: 100, height: 50)
    titleContent.center = self.view.center
    titleContent.setView(fontSize: 25)
    contentSetArray.append(THContentSet(contentKey: titleContentKey, contentView: titleContent))

    // THTextContentView set example
    let textContent = THTextContentView()
    textContent.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height*(1/5),  width: self.view.frame.width, height: self.view.frame.height*(1/5))
    textContent.setContentView(upYFloat: 180)
    contentSetArray.append(THContentSet(contentKey: textContentKey, contentView: textContent))
  }
  ```
2. If you want to show the required content, you can make content view that inherit 'THContentView'.
  ```Swift
  // 'THContentView' creation example
  public class THExampleContentView: THContentView {
    public setExampleContent {
      // Sets the delegate for the content view.
      delegate = self
    }
  }

  extension THExampleContentView: THContentViewDelegate {
    public func setContent(info: Any?) {
      // Setting up contentInfo in content view
    }

    public func dismiss() {
      // When you dismiss the content
    }
  }
  ```
3. Call ```THContentMarkerController``` and implement dataSource, delegate.
  ```swift
  class ViewController: UIViewController {

    var contentMarkerController = THContentMarkerController()

    // Work data in 'THContentMarkerController'
    var markerArray = [THMarker]()
    var contentSetArray = [THContentSet]()

    override func viewDidLoad() {
       super.viewDidLoad()

       contentMarkerController.dataSource = self
       contentMarkerController.delegate = self

       contentMarkerController.set(parentView: self.view, scrollView: self.scrollView)

       // Data set implemented above
       setMarker()
       setContentView()
    }
 }
// 'THContentMarkerControllerDataSource' returns 'THMarker' and 'THContentSet'
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
// In 'THContentMarkerControllerDelegate', you can implement the event when the marker is clicked.
extension  ViewController: THContentMarkerControllerDelegate {
  func markerTap(_ contentMarkerController: THContentMarkerController, markerView: THMarkerView) {
        // If you want the marker to disappear when you select a marker, add below code.
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

## License

`THContentMarkerView` is released under the MIT license. [See LICENSE](https://github.com/TileImageTeamiOS/THContentMarkerView/blob/master/LICENSE) for details.
