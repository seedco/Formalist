//
//  GroupElementTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Forms

class GroupElementTests: FBSnapshotTestCase {
    private var validatableElement: EditableTextElement<UITextFieldTextEditorAdapter>!
    private var childElements: [FormElement]!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        validatableElement = textField(value: FormValue(""), validationRules: [.email]) { textField in
            textField.placeholder = "Text Element 1"
        }
        childElements = [
            BooleanElement(title: "Boolean Element", value: FormValue(false)),
            validatableElement,
            SegmentElement(title: "Segment Element", segments: [
                Segment(content: .Title("Segment 1"), value: 0),
                Segment(content: .Title("Segment 2"), value: 1)
            ], selectedValue: FormValue(0)),
        ]
    }
    
    func testRenderPlainStyle() {
        var configuration = GroupElement.Configuration()
        configuration.style = .Plain
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderGroupedStyleWithSeparators() {
        var configuration = GroupElement.Configuration()
        configuration.style = .Grouped(backgroundColor: .whiteColor())
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderGroupedStyleWithoutSeparators() {
        var configuration = GroupElement.Configuration()
        configuration.style = .Grouped(backgroundColor: .whiteColor())
        configuration.separatorViewFactory = { _ in return nil }
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderWithConstantHeights() {
        var configuration = GroupElement.Configuration()
        configuration.layout.mode = .ConstantHeight(44)
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderWithConstantHeightsAndInsets() {
        var configuration = GroupElement.Configuration()
        configuration.layout.mode = .ConstantHeight(44)
        configuration.layout.edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderWithIntrinsicSizeAndInsets() {
        var configuration = GroupElement.Configuration()
        configuration.layout.mode = .IntrinsicSize
        configuration.layout.edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
        let element = GroupElement(configuration: configuration, elements: childElements)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderValidationErrorWithDefaultFactory() {
        let expectation = expectationWithDescription("Text field element validation")

        validatableElement.validateAndStoreResult { _ in
            let element = GroupElement(elements: self.childElements)
            let elementView = renderElementForTesting(element)
            self.FBSnapshotVerifyView(elementView)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func testRenderValidationErrorWithNoopFactory() {
        let expectation = expectationWithDescription("Text field element validation")
        
        validatableElement.validateAndStoreResult { _ in
            var configuration = GroupElement.Configuration()
            configuration.validationErrorViewFactory = { _ in return nil }
            
            let element = GroupElement(configuration: configuration, elements: self.childElements)
            let elementView = renderElementForTesting(element)
            self.FBSnapshotVerifyView(elementView)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
}
