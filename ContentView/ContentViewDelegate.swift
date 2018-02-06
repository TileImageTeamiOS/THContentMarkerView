//
//  ContentViewDelegate.swift
//  ScrollViewContent
//
//  Created by Seong ho Hong on 2018. 2. 5..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import Foundation

public protocol ContentViewDelegate: AnyObject {
    func setContentInfo()
    
    func setContentView()
}
