//
//  ExplainView.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 2. 4..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

open class ContentView: UIView {
    public var info: Any?
    public var identifier = String()
    public var delegate: ContentViewDelegate!
    
    public convenience init(identifier: String) {
        self.init(frame: .zero)
        self.identifier = identifier
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
