//
//  THContentView.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 2. 7..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

class THContentViewController {
    var contentKeyArray: [String] = []
    var contentViewArray: [THContentView] = []
    
    var dataSource: THContentViewControllerDataSource!
    
    func set(parentView: UIView) {
        contentKeyArray.removeAll()
        contentViewArray.removeAll()
        contentViewArray = dataSource.setContentView(self)
        contentKeyArray = dataSource.setContentKey(self)
        
        contentViewArray.map { contentView in
            parentView.addSubview(contentView)
            contentView.isHidden = true
        }
    }
    
    func show(content: THContent) {
        for (index, contentView) in contentViewArray.enumerated() {
            if let info = content.contentInfo[contentKeyArray[index]] {
                print(contentView.delegate)
                contentView.delegate.setContent(info: info)
                contentView.isHidden = false
            }
        }
    }
}

protocol THContentType {
    var contentInfo: Dictionary<String, Any?> { get set }
}

public struct THContent: THContentType {
    var contentInfo: Dictionary<String, Any?>
}

public class THContentView: UIView {
    var delegate: THContentViewDelegate!
}

public protocol THContentViewDelegate: class {
    func setContent(info: Any?)
}


protocol THContentViewControllerDataSource: class {
    func setContentView(_ contentController: THContentViewController) -> [THContentView]
    
    func setContentKey(_ contentController: THContentViewController) -> [String]
}
