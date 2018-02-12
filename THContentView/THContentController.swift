//
//  THContentView.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 2. 7..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//
import UIKit

struct THContentWrapper {
    var contentKey: String
    var contentView: THContentView
}

class THContentViewController: UIViewController {
    var contentWrapArray: [THContentWrapper] = []
    
    var dataSource: THContentViewControllerDataSource!
    
    func set(parentView: UIView, dataSource: THContentViewControllerDataSource) {
        self.dataSource = dataSource
        contentWrapArray.removeAll()
        contentWrapArray = dataSource.setContentView(self)
        
        contentWrapArray.map { contentView in
            parentView.addSubview(contentView.contentView)
            contentView.contentView.isHidden = true
        }
    }
    
    func show(content: THContent) {
        for (index, contentView) in contentWrapArray.enumerated() {
            if let info = content.contentInfo[contentView.contentKey] {
                contentView.contentView.delegate.setContent(info: info)
                contentView.contentView.isHidden = false
            }
        }
    }
    
    func dismiss() {
        for contentWrap in contentWrapArray {
            contentWrap.contentView.isHidden = true
            contentWrap.contentView.delegate.dismiss()
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
    func dismiss()
}


protocol THContentViewControllerDataSource: class {
    func setContentView(_ contentController: THContentViewController) -> [THContentWrapper]
}
