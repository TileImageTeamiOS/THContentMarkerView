import UIKit
import SwiftyJSON

enum ContentStatus: Int {
    case show = 1
    case hide
}
public class THTextContentView: ContentView {
    var textContentResizeView = UIView()
    private var resizeTapGestureRecognizer = UITapGestureRecognizer()
    private var linkLabelTapGestureRecognizer = UITapGestureRecognizer()
    
    var contentScrollView = UIScrollView()
    var titleLable = UILabel()
    var linkLable = UILabel()
    var textLabel = UILabel()
    
    var contentStatus: ContentStatus = .hide
    
    private func scrollSet() {
        contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        contentScrollView.canCancelContentTouches = true
        self.addSubview(contentScrollView)
    }
    
    public func labelSet(title: String?, link: String?, text: String?) {
        titleLable.frame.size = CGSize(width: self.frame.width, height: 10)
        titleLable.frame.origin = CGPoint(x: 10, y: 10)
        titleLable.text = title
        titleLable.numberOfLines = 2
        titleLable.textAlignment = .left
        titleLable.font = UIFont.boldSystemFont(ofSize: 15)
        titleLable.sizeToFit()
        
        linkLable.frame.size = CGSize(width: self.frame.width, height: 10)
        linkLable.frame.origin = CGPoint(x: 10, y: titleLable.frame.origin.y + titleLable.frame.height + 10)
        linkLable.text = link
        linkLable.numberOfLines = 2
        linkLable.textAlignment = .left
        linkLable.textColor = UIColor.blue
        linkLable.sizeToFit()
        linkLable.isUserInteractionEnabled = true
        
        textLabel.frame.size = CGSize(width: self.frame.width, height: 10)
        textLabel.frame.origin = CGPoint(x: 10, y: linkLable.frame.origin.y + linkLable.frame.height + 10)
        textLabel.text = text
        textLabel.numberOfLines = 100
        textLabel.textAlignment = .left
        textLabel.sizeToFit()
        
        contentScrollView.addSubview(titleLable)
        contentScrollView.addSubview(linkLable)
        contentScrollView.addSubview(textLabel)
        
        contentScrollView.sizeToFit()
        contentScrollView.contentSize = CGSize(width: self.frame.width, height: titleLable.frame.height + linkLable.frame.height + textLabel.frame.height + 10 + 10 + 10)
    }
}

extension THTextContentView: ContentViewDelegate {
    public func setContentInfo() {
        let textContent = info as! JSON
        let title = textContent["textTitle"].description
        let link = textContent["link"].description
        let text = textContent["text"].description
        
        labelSet(title: title, link: link, text: text)
    }
    
    public func setContentView() {
        scrollSet()
        self.backgroundColor = UIColor.white
        
        textContentResizeView = UIView(frame: CGRect(x: self.frame.width - 30, y: 10, width: 25, height: 25))
        textContentResizeView.backgroundColor = UIColor.white
        contentScrollView.addSubview(textContentResizeView)
        
        resizeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resizeViewTap(_:)))
        resizeTapGestureRecognizer.delegate = self
        textContentResizeView.addGestureRecognizer(resizeTapGestureRecognizer)
        
        linkLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(linkLabelTap(_:)))
        linkLabelTapGestureRecognizer.delegate = self
        linkLable.addGestureRecognizer(linkLabelTapGestureRecognizer)
    }
}

extension THTextContentView: UIGestureRecognizerDelegate {
    @objc func resizeViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if contentStatus == .hide {
            contentStatus = .show
            
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: 0, y: (self.superview?.frame.height)! - 400, width: (self.superview?.frame.width)!, height: 400)
                self.contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            })
        } else {
            contentStatus = .hide
            
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: 0, y: (self.superview?.frame.height)! - 100, width: (self.superview?.frame.width)!, height: 100)
                self.contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            })
        }
    }
    
    @objc func linkLabelTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let parentVC = self.parentViewController
        let webViewController = UIViewController()
        
        let webView = UIWebView(frame: webViewController.view.frame)
        webViewController.view.addSubview(webView)
        webView.loadRequest(URLRequest(url: URL(string: linkLable.text!)!))
        
        parentVC?.show(webViewController, sender: nil)
    }
}
