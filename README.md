# THContentMarkerView

[![Build Status](https://travis-ci.org/TileImageTeamiOS/THContentMarkerView.svg?branch=master)](https://travis-ci.org/TileImageTeamiOS/THContentMarkerView)
[![Version](https://cocoapod-badges.herokuapp.com/v/THContentMarkerView/badge.png)](https://github.com/TileImageTeamiOS/THContentMarkerView)
[![platform](https://cocoapod-badges.herokuapp.com/p/THContentMarkerView/badge.png)](https://github.com/TileImageTeamiOS/THContentMarkerView)
[![License](https://cocoapod-badges.herokuapp.com/l/THContentMarkerView/badge.png)](https://github.com/TileImageTeamiOS/THContentMarkerView)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-%23FB613C.svg)](https://developer.apple.com/swift/)

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

- ```set(parentView: UIView, scrollView: UIScrollView)``` : Sets the ```UIScrollView``` on which the marker will be drawn and a ```UIView``` to show the content.
- ```reloadData()``` : If  ```THMarker``` is added or deleted, use reloadData () to reload the data into ```THContentMarkerController```.
- ```setMarkerFrame()``` : When the marker is on the 'UIScrollView', it changes the frame of the marker depending on whether it is zooming or not.
- ```markerHidden(bool: Bool)``` : Determines whether the marker is Hidden.
- ```contentDismiss()``` :
Dismiss the content view of the marker.
- ```markerViewSize``` : You can specify the size of the marker.
- ```markerViewImage``` : You can specify the image of the marker.

## License

`THContentMarkerView` is released under the MIT license. [See LICENSE](https://github.com/TileImageTeamiOS/THContentMarkerView/blob/master/LICENSE) for details.
