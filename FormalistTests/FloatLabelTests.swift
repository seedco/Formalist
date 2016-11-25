//
//  FloatLabelTests.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-13.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Formalist

class FloatLabelTests: FBSnapshotTestCase {
    fileprivate var floatLabel: FloatLabel<UITextFieldTextEditorAdapter<FloatLabelTextField>>!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        
        let adapter = UITextFieldTextEditorAdapter<FloatLabelTextField>(configuration: TextEditorConfiguration())
        floatLabel = FloatLabel(adapter: adapter)
        floatLabel.setFieldName("Test")
    }
    
    func testRenderWithLabelHidden() {
        floatLabel.transitionToState(.labelHidden, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
    
    func testRenderWithLabelShown() {
        floatLabel.transitionToState(.labelShown, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
    
    func testRenderWithSingleLineTextAndLabelShown() {
        floatLabel.textEntryView.text = "Dapibus Consectetur Aenean Ligula Vestibulum"
        floatLabel.transitionToState(.labelShown, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
    
    func testRenderWithMultiLineTextAndLabelShown() {
        let adapter = UITextViewTextEditorAdapter<PlaceholderTextView>(configuration: TextEditorConfiguration())
        let floatLabel = FloatLabel(adapter: adapter)
        floatLabel.textEntryView.text = "Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Nulla vitae elit libero, a pharetra augue."
        floatLabel.transitionToState(.labelShown, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
}
