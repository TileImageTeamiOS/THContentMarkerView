//
//  THContentSet .swift
//  THContentMarkerView
//
//  Created by Seong ho Hong on 2018. 2. 18..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

public struct THContentSet {
    // MARK: - Properties
    // The 'THContentView' identifier key
    public var contentKey: String
    // The 'THContentView' by contentKey
    public var contentView: THContentView
    public init(contentKey: String, contentView: THContentView){
        self.contentKey = contentKey
        self.contentView = contentView
    }
}

