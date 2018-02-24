# THContentMarkerVIew

## Feature
- [x] 📄'UIScrollView' 위에 컨텐츠가 담긴 마커를 찍을수 있습니다.
- [x] 🛫'THMarkerView'는 'UIScrollView'에 origin과  zoomScale이 담겨있어서, 해당 위치로 가는 카메라 오토파일럿 기능을 합니다.
- [x] 🎥'THContentMarkerView'에서는 기본 콘텐츠로 'THVideoContentView', 'THAudioContentView', 'THTextContentView', 'THTitleContentView'를 제공합니다.
- [x] 👍이 외에 원하시는 콘텐츠 뷰를 만들고 싶다면, 'THContentView'를 상속받아 만들수 있습니다.

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

  - THContentSet: 'THContentSet'은 해당 프로젝트에서 사용할 'THContentView'와 해당 뷰의 Key를 가지고 있습니다. (해당 라이브러리에선 기본적으로  'THVideoContentView', 'THAudioContentView', 'THTextContentView', 'THTitleContentView'를 제공합니다.)

  ```Swift
  // 기본 'THContentView' 세팅
  var contentSetArray = [THContentSet]()

  func setContentView() {
      // 해당 'THContentView'의 key  세팅
      let videoContnetKey = "videoContent"
      let audioContentKey = "audioContent"
      let titleContentKey = "titleContent"
      let textContentKey = "textContent"

      // 'THContentView' 호출을 하고 세팅
      let videoContentView = THVideoContentView()
      let audioContent = THAudioContentView()
      let titleContent = THTitleContentView()
      let textContent = THTextContentView()

      videoContentView.setContentView()
      audioContent.setContentView()
      titleContent.setView()
      textContent.setContentView(upYFloat: 180)

      // contentSetArray에 어펜드
      contentSetArray.append(THContentSet(contentKey: videoContnetKey, contentView: videoContentView))
      contentSetArray.append(THContentSet(contentKey: audioContentKey, contentView: audioContent))
      contentSetArray.append(THContentSet(contentKey: titleContentKey, contentView: titleContent))
      contentSetArray.append(THContentSet(contentKey: textContentKey, contentView: textContent))

      // ViewController의 view의 frame 세팅
      videoContentView.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
      audioContent.frame = CGRect(x: 0, y: 200, width: 80, height: 80)
      titleContent.frame.size = CGSize(width: 100, height: 50)
      titleContent.center = self.view.center
      textContent.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height*(1/5),
                                   width: self.view.frame.width,
                                   height: self.view.frame.height*(1/5))
  }
  ```

  
