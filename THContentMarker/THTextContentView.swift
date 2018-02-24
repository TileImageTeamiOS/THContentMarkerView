//
//  THTextContentView.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 2. 9..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//
import UIKit

enum ContentStatus: Int {
    case show = 1
    case hide
}

public class THTextContentView: THContentView {
    var textContentResizeView = UIView()
    var upImageView = UIImageView()
    private var resizeTapGestureRecognizer = UITapGestureRecognizer()
    private var linkLabelTapGestureRecognizer = UITapGestureRecognizer()
    
    var contentScrollView = UIScrollView()
    var titleLable = UILabel()
    var linkLable = UILabel()
    var textLabel = UILabel()
    var upYFloat = CGFloat(180)
    var contentStatus: ContentStatus = .hide
    
    public func setContentView(upYFloat: CGFloat) {
        self.upYFloat = upYFloat
        delegate = self
        scrollSet()
        self.backgroundColor = UIColor.white
        
        textContentResizeView = UIView(frame: CGRect(x: self.frame.width/2 - 12.5, y: 3, width: 25, height: 25))
        upImageView.frame.origin = .zero
        upImageView.frame.size = textContentResizeView.frame.size
        upImageView.image = UIImage(named: "up.png")
        upImageView.contentMode = .scaleAspectFit
        contentScrollView.addSubview(textContentResizeView)
        textContentResizeView.addSubview(upImageView)
        
        resizeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resizeViewTap(_:)))
        resizeTapGestureRecognizer.delegate = self
        textContentResizeView.addGestureRecognizer(resizeTapGestureRecognizer)
        
        linkLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(linkLabelTap(_:)))
        linkLabelTapGestureRecognizer.delegate = self
        linkLable.addGestureRecognizer(linkLabelTapGestureRecognizer)
    }
    
    private func scrollSet() {
        contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        contentScrollView.canCancelContentTouches = true
        self.addSubview(contentScrollView)
    }
    
    public func frameSet(upYFloat: CGFloat) {
        self.upYFloat = upYFloat
    }
}

extension THTextContentView: UIGestureRecognizerDelegate {
    @objc func resizeViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if contentStatus == .hide {
            contentStatus = .show
            
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: 0, y: self.frame.origin.y - self.upYFloat,
                                    width: (self.superview?.frame.width)!,
                                    height: self.frame.height+self.upYFloat)
                self.contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                self.upImageView.transform = self.upImageView.transform.rotated(by: CGFloat(Double.pi))
            })
        } else {
            contentStatus = .hide
            
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: 0, y: self.frame.origin.y + self.upYFloat,
                                    width: (self.superview?.frame.width)!,
                                    height: self.frame.height-self.upYFloat)
                self.contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                self.upImageView.transform = self.upImageView.transform.rotated(by: CGFloat(Double.pi))
            })
        }
    }
    
    @objc func linkLabelTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let url = URL(string: linkLable.text!)!
        
        if UIApplication.shared.canOpenURL(url).hashValue == 1 {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Invaild input URL", message: nil, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            
            let parentVC = self.parentViewController
            parentVC?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func labelSet(title: String?, link: String?, text: String?) {
        titleLable.frame.size = CGSize(width: self.frame.width, height: 10)
        titleLable.frame.origin = CGPoint(x: 10, y: 40)
        titleLable.text = title
        titleLable.numberOfLines = 2
        titleLable.textAlignment = .left
        titleLable.font = UIFont.boldSystemFont(ofSize: 23)
        titleLable.sizeToFit()
        
        linkLable.frame.size = CGSize(width: self.frame.width, height: 10)
        linkLable.frame.origin = CGPoint(x: 10, y: titleLable.frame.origin.y + titleLable.frame.height + 10)
        let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        linkLable.attributedText = NSAttributedString(string: link!, attributes: underlineAttribute)
        linkLable.numberOfLines = 2
        linkLable.textAlignment = .left
        linkLable.sizeToFit()
        linkLable.isUserInteractionEnabled = true
        
        textLabel.frame.size = CGSize(width: (self.frame.width - 20), height: 10)
        textLabel.frame.origin = CGPoint(x: 10, y: linkLable.frame.origin.y + linkLable.frame.height + 25)
        let attString = NSMutableAttributedString(string: text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 40
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = 2
        paragraphStyle.lineHeightMultiple = 1.3
        attString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attString.length))
        attString.addAttribute(NSAttributedStringKey.font, value: textLabel.font, range: NSMakeRange(0, attString.length))
        textLabel.numberOfLines = 0
        textLabel.attributedText = attString
        textLabel.sizeToFit()
        
        contentScrollView.addSubview(titleLable)
        contentScrollView.addSubview(linkLable)
        contentScrollView.addSubview(textLabel)
        
        contentScrollView.sizeToFit()
        contentScrollView.contentSize = CGSize(width: self.frame.width,
                                               height: titleLable.frame.height +
                                                linkLable.frame.height +
                                                textLabel.frame.height + 100)
    }
}

extension THTextContentView: THContentViewDelegate {
    public func setContent(info: Any?) {
        let contentInfo = info as? [String: String]
        var title = ""
        var link = ""
        var text = ""
        
        if let titleInfo = contentInfo!["title"] {
            title = titleInfo
        }
        
        if let linkInfo = contentInfo!["link"] {
            link = linkInfo
        }
        
        if let textInfo = contentInfo!["text"] {
            text = textInfo
        }
        
        labelSet(title: title, link: link, text: text)
    }
    
    public func dismiss() {
        labelSet(title: "", link: "", text: "")
        textContentResizeView = UIView(frame: CGRect(x: self.frame.width - 30, y: 10, width: 25, height: 25))
        if contentStatus == .show{
            contentStatus = .hide
            self.frame = CGRect(x: 0, y: self.frame.origin.y + self.upYFloat,
                                width: (self.superview?.frame.width)!,
                                height: self.frame.height-self.upYFloat)
            self.contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.upImageView.transform = self.upImageView.transform.rotated(by: CGFloat(Double.pi))
        }
    }
}
