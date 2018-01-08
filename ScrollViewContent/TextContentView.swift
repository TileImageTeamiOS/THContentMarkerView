//
//  TextContentView.swift
//  ScrollViewMarker
//
//  Created by Seong ho Hong on 2018. 1. 7..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

class TextContentView: UIView {
    var textContentResizeView = UIView()
    private var resizeTapGestureRecognizer = UITapGestureRecognizer()
    
    var contentScrollView = UIScrollView()
    var titleLable = UILabel()
    var linkLable = UILabel()
    var textLabel = UILabel()
    
    func set() {
        scrollSet()
        labelSet()
        textContentResizeView = UIView(frame: CGRect(x: self.frame.width - 50, y: 10, width: 25, height: 25))
        textContentResizeView.backgroundColor = UIColor.white
        self.addSubview(textContentResizeView)
        
        resizeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resizeViewTap(_:)))
        resizeTapGestureRecognizer.delegate = self
        textContentResizeView.addGestureRecognizer(resizeTapGestureRecognizer)
    }
    
    private func scrollSet() {
        contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(contentScrollView)
    }
    
    private func labelSet() {
        titleLable.frame.size = CGSize(width: self.frame.width, height: 10)
        titleLable.frame.origin = CGPoint(x: 10, y: 10)
        titleLable.text = titleExam
        titleLable.numberOfLines = 2
        titleLable.textAlignment = .left
        titleLable.font = UIFont.boldSystemFont(ofSize: 15)
        titleLable.sizeToFit()
        
        linkLable.frame.size = CGSize(width: self.frame.width, height: 10)
        linkLable.frame.origin = CGPoint(x: 10, y: titleLable.frame.origin.y + titleLable.frame.height + 10)
        linkLable.text = linkExam
        linkLable.numberOfLines = 2
        linkLable.textAlignment = .left
        linkLable.sizeToFit()
        
        textLabel.frame.size = CGSize(width: self.frame.width, height: 10)
        textLabel.frame.origin = CGPoint(x: 10, y: linkLable.frame.origin.y + linkLable.frame.height + 10)
        textLabel.text = textExam
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

extension TextContentView: UIGestureRecognizerDelegate {
    @objc func resizeViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        print("tap")

    }
}
