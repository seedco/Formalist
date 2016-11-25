//
//  EditableTextElementTests.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Formalist

class EditableTextElementTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRenderTextFieldElement() {
        let element = textField(value: FormValue("Text Field Element")) {
            $0.textColor = .red
            $0.textAlignment = .center
        }
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderTextViewElement() {
        let element = textView(value: FormValue("Text View Element")) {
            $0.textColor = .red
            $0.textAlignment = .center
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
    
    func testUpdateTextFieldByUpdatingValue() {
        let value = FormValue("foo")
        let element = textField(value: value)
        let elementView = element.render() as! UITextField
        
        value.value = "bar"
        XCTAssertEqual("bar", elementView.text)
    }
    
    func testUpdateTextViewByUpdatingValue() {
        let value = FormValue("foo")
        let element = textView(value: value)
        let elementView = element.render() as! UITextView
        
        value.value = "bar"
        XCTAssertEqual("bar", elementView.text)
    }
    
    func testUpdateSingleLineFloatLabelByUpdatingValue() {
        let value = FormValue("foo")
        let element = singleLineFloatLabel(name: "Float Label", value: value)
        let elementView = element.render() as! FloatLabel<UITextFieldTextEditorAdapter<FloatLabelTextField>>
        
        value.value = "bar"
        XCTAssertEqual("bar", elementView.textEntryView.text)
    }
    
    func testUpdateMultiLineFloatLabelByUpdatingValue() {
        let value = FormValue("foo")
        let element = multiLineFloatLabel(name: "Float Label", value: value)
        let elementView = element.render() as! FloatLabel<UITextViewTextEditorAdapter<PlaceholderTextView>>
        
        value.value = "bar"
        XCTAssertEqual("bar", elementView.textEntryView.text)
    }
}
