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
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(titleLabel)
    }
}

extension THTitleContentView: THContentViewDelegate {
    public func setContent(info: Any?) {
        let titleInfo = info as? String
        set(title: titleInfo!)
    }
    
    public func dismiss() {
        titleLabel.text = ""
    }
}
