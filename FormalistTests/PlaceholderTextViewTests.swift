//
//  PlaceholderTextViewTests.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Formalist

class PlaceholderTextViewTests: FBSnapshotTestCase {
    fileprivate var textView: PlaceholderTextView!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        textView = PlaceholderTextView(frame: CGRect.zero)
        textView.isScrollEnabled = false
    }
    
    func testShowsPlaceholderBySettingPlaceholder() {
        textView.placeholder = "Placeholder"
        textView.placeholderColor = .red
        
        sizeViewForTesting(textView)
        FBSnapshotVerifyView(textView)
    }
    
    func testShowsPlaceholderBySettingAttributedPlaceholder() {
        textView.attributedPlaceholder = NSAttributedString(string: "Placeholder", attributes: [
            .foregroundColor: UIColor.red,
            .foregroundColor: UIColor.lightGray
        ])
        
        sizeViewForTesting(textView)
        FBSnapshotVerifyView(textView)
    }
    
    func testHidesPlaceholderWhenTextExists() {
        textView.placeholder = "Placeholder"
        textView.placeholderColor = .red
        textView.text = "Text View Text"
        
        sizeViewForTesting(textView)
        FBSnapshotVerifyView(textView)
    }
}
