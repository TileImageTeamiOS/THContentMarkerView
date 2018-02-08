//
//  ExplainView.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 2. 5..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

open class ContentViewController {
    var contentInfo: Any?
    var contentViewArray = [ContentView]()
    
    public func showContent(contentDict: Dictionary<String, Any>) {
        for contentView in contentViewArray {
            if let contentInfo = contentDict[contentView.identifier] {
                contentView.isHidden = false
                contentView.info = contentInfo
                contentView.delegate?.setContentInfo()
            }
        }
    }
    
    public func dismissContent() {
        for contentView in contentViewArray {
            contentView.isHidden = true
        }
    }
    
    public func set(contentView: ContentView, parentView: UIView) {
        contentViewArray.append(contentView)
        contentView.delegate = contentView as! ContentViewDelegate
        contentView.delegate.setContentView()
        contentView.isHidden = true
        parentView.addSubview(contentView)
    }
}


