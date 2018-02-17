//
//  TextContentView.swift
//  ScrollViewMarker
//
//  Created by Seong ho Hong on 2018. 1. 7..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

class TextContentView: UIScrollView {
    var titleLable = UILabel()
    var linkLable = UILabel()
    var textLabel = UILabel()
    
    func set() {
        titleLable.text = titleExam
        titleLable.numberOfLines = 2
        titleLable.textAlignment = .left
        titleLable.font = UIFont.boldSystemFont(ofSize: 15)
        titleLable.sizeToFit()

        linkLable = UILabel(frame: CGRect(x: 10, y: 40, width: self.frame.width, height: 50))
        linkLable.text = linkExam
        linkLable.numberOfLines = 2
        linkLable.textAlignment = .left
        linkLable.sizeToFit()
  
        textLabel = UILabel(frame: CGRect(x: 10, y: 70, width: self.frame.width, height: 100))
        textLabel.text = textExam
        textLabel.numberOfLines = 100
        textLabel.textAlignment = .left
        textLabel.sizeToFit()
        
        self.addSubview(titleLable)
        self.addSubview(linkLable)
        self.addSubview(textLabel)
        
        self.sizeToFit()
        self.contentSize = CGSize(width: self.frame.width, height: titleLable.frame.height + linkLable.frame.height + textLabel.frame.height)
    }
}
