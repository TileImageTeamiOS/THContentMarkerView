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
    var strokeTextAttributes = [NSAttributedStringKey: Any]()
    public func setView(fontSize: CGFloat) {
        delegate = self
        strokeTextAttributes = [
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.strokeWidth: -2.0,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: fontSize)
        ]
    }

    func set(title: String) {
        titleLabel.attributedText = NSMutableAttributedString(string: title, attributes: strokeTextAttributes)
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
        set(title: "")
    }
}
