//
//  GroupElementTests.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Formalist

class GroupElementTests: FBSnapshotTestCase {
    fileprivate var validatableElement: EditableTextElement<UITextFieldTextEditorAdapter<UITextField>>!
    fileprivate var childElements: [FormElement]!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        
        validatableElement = .textField(value: FormValue("<invalid>"), validationRules: [.email]) { textField in
            textField.placeholder = "Text Element 1"
        }
        childElements = [
            BooleanElement(title: "Boolean Element", value: FormValue(false)),
            validatableElement,
            SegmentElement(title: "Segment Element", segments: [
                Segment(content: .title("Segment 1"), value: 0),
                Segment(content: .title("Segment 2"), value: 1)
            ], selectedValue: FormValue(0)),
        ]
    }
    
    @objc func testRenderPlainStyle() {
        var configuration = GroupElement.Configuration()
        configuration.style = .plain
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    @objc func testRenderGroupedStyleWithSeparators() {
        var configuration = GroupElement.Configuration()
        configuration.style = .grouped(backgroundColor: .white)
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    @objc func testRenderGroupedStyleWithoutSeparators() {
        var configuration = GroupElement.Configuration()
        configuration.style = .grouped(backgroundColor: .white)
        configuration.separatorViewFactory = { _,_  in return nil }
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    @objc func testRenderWithConstantHeights() {
        var configuration = GroupElement.Configuration()
        configuration.layout.mode = .constantHeight(44)
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    @objc func testRenderWithConstantHeightsAndInsets() {
        var configuration = GroupElement.Configuration()
        configuration.layout.mode = .constantHeight(44)
        configuration.layout.edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    @objc func testRenderWithIntrinsicSizeAndInsets() {
        var configuration = GroupElement.Configuration()
        configuration.layout.mode = .intrinsicSize
        configuration.layout.edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    @objc func testRenderValidationErrorWithDefaultFactory() {
        let fieldExpectation = expectation(description: "Text field element validation")

        validatableElement.validateAndStoreResult { _ in
            let element = GroupElement(elements: self.childElements)
            let elementView = renderElementForTesting(element)
            self.FBSnapshotVerifyView(elementView)
            
            fieldExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    @objc func testRenderValidationErrorWithNoopFactory() {
        let fieldExpectation = expectation(description: "Text field element validation")
        
        validatableElement.validateAndStoreResult { _ in
            var configuration = GroupElement.Configuration()
            configuration.validationErrorViewFactory = { _ in return nil }
            
            let element = GroupElement(configuration: configuration, elements: self.childElements)
            let elementView = renderElementForTesting(element)
            self.FBSnapshotVerifyView(elementView)
            
            fieldExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
