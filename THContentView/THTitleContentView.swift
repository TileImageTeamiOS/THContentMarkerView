//
//  THTitleContentView.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 2. 9..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

public class THTitleContentView: THContentView {
    var titleLabel = UILabel()
    
    func setView() {
        delegate = self
    }
    
    func set(title: String) {
        titleLabel.text = title
        titleLabel.sizeToFit()
        titleLabel.center = self.center
    }
}

extension THTitleContentView: THContentViewDelegate {
    public func setContent(info: Any?) {
        var titleInfo = info as? String
        set(title: titleInfo!)
    }
    
    public func dismiss() {
        
    }
}
