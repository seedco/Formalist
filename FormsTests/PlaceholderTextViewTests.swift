//
//  PlaceholderTextViewTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Forms

class PlaceholderTextViewTests: FBSnapshotTestCase {
    private var textView: PlaceholderTextView!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        textView = PlaceholderTextView(frame: CGRectZero)
        textView.scrollEnabled = false
    }
    
    func testShowsPlaceholderBySettingPlaceholder() {
        textView.placeholder = "Placeholder"
        textView.placeholderColor = .redColor()
        
        sizeViewForTesting(textView)
        FBSnapshotVerifyView(textView)
    }
    
    func testShowsPlaceholderBySettingAttributedPlaceholder() {
        textView.attributedPlaceholder = NSAttributedString(string: "Placeholder", attributes: [
            NSForegroundColorAttributeName: UIColor.redColor(),
            NSBackgroundColorAttributeName: UIColor.lightGrayColor()
        ])
        
        sizeViewForTesting(textView)
        FBSnapshotVerifyView(textView)
    }
    
    func testHidesPlaceholderWhenTextExists() {
        textView.placeholder = "Placeholder"
        textView.placeholderColor = .redColor()
        textView.text = "Text View Text"
        
        sizeViewForTesting(textView)
        FBSnapshotVerifyView(textView)
    }
}
