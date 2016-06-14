//
//  FloatLabelTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-13.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Forms

class FloatLabelTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRenderWithLabelHidden() {
        let floatLabel = FloatLabel(name: "Test")
        floatLabel.transitionToState(.LabelHidden, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
    
    func testRenderWithLabelShown() {
        let floatLabel = FloatLabel(name: "Test")
        floatLabel.transitionToState(.LabelShown, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
    
    func testRenderWithTextAndLabelShown() {
        let floatLabel = FloatLabel(name: "Test")
        floatLabel.bodyTextView.text = "This is some text"
        floatLabel.transitionToState(.LabelShown, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
}
