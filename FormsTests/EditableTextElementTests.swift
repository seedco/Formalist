//
//  EditableTextElementTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Forms

class EditableTextElementTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRenderTextFieldElement() {
        let element = textField(value: FormValue("Text Field Element")) {
            $0.textColor = .redColor()
            $0.textAlignment = .Center
        }
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderTextViewElement() {
        let element = textView(value: FormValue("Text View Element")) {
            $0.textColor = .redColor()
            $0.textAlignment = .Center
        }
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderSingleLineFloatLabelElementWithEmptyValue() {
        let element = singleLineFloatLabel(name: "Test", value: FormValue(""))
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderSingleLineFloatLabelElementWithNonEmptyValue() {
        let element = singleLineFloatLabel(name: "Test", value: FormValue("Quam Amet Fringilla Purus Aenean"))
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderMultiLineFloatLabelElementWithEmptyValue() {
        let element = multiLineFloatLabel(name: "Test", value: FormValue(""))
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderMultiLineFloatLabelElementWithNonEmptyValue() {
        let element = multiLineFloatLabel(name: "Test", value: FormValue("Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Donec ullamcorper nulla non metus auctor fringilla."))
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
}
