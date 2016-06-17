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
    private var floatLabel: FloatLabel<UITextFieldTextEditorAdapter>!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        let adapter = UITextFieldTextEditorAdapter(configuration: TextEditorConfiguration(), textChangedObserver: { _ in })
        floatLabel = FloatLabel(adapter: adapter)
        floatLabel.setFieldName("Test")
    }
    
    func testRenderWithLabelHidden() {
        floatLabel.transitionToState(.LabelHidden, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
    
    func testRenderWithLabelShown() {
        floatLabel.transitionToState(.LabelShown, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
    
    func testRenderWithSingleLineTextAndLabelShown() {
        floatLabel.textEntryView.text = "This is some text"
        floatLabel.transitionToState(.LabelShown, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
}
