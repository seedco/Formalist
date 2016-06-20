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
    private var floatLabel: FloatLabel<UITextFieldTextEditorAdapter<UITextField>>!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        let adapter = UITextFieldTextEditorAdapter(configuration: TextEditorConfiguration())
        floatLabel = FloatLabel(adapter: adapter, textChangedObserver: { _ in })
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
        floatLabel.textEntryView.text = "Dapibus Consectetur Aenean Ligula Vestibulum"
        floatLabel.transitionToState(.LabelShown, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
    
    func testRenderWithMultiLineTextAndLabelShown() {
        let adapter = UITextViewTextEditorAdapter<PlaceholderTextView>(configuration: TextEditorConfiguration())
        let floatLabel = FloatLabel(adapter: adapter, textChangedObserver: { _ in})
        floatLabel.textEntryView.text = "Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Nulla vitae elit libero, a pharetra augue."
        floatLabel.transitionToState(.LabelShown, animated: false)
        sizeViewForTesting(floatLabel)
        FBSnapshotVerifyView(floatLabel)
    }
}
