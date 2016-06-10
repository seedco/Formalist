//
//  FormsUITests.swift
//  FormsUITests
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import XCTest

class FormsUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testBooleanElement() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let switch2 = elementsQuery.switches["0"]
        switch2.tap()
        
        let alert = app.alerts["Boolean Element"]
        let dismissButton = alert.buttons["Dismiss"]
        
        XCTAssert(alert.staticTexts["The value changed to true."].exists)
        dismissButton.tap()
        
        elementsQuery.switches["1"].tap()
        XCTAssert(alert.staticTexts["The value changed to false."].exists)
        dismissButton.tap()
    }
    
    func testTextViewElement() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let textView = elementsQuery.textViews["textView"]
        
        textView.tap()
        app.typeText("Hello World")
        app.buttons["Return"].tap()
        app.alerts["Text View Element"].collectionViews.buttons["Dismiss"].tap()
    }
    
    func testSegmentElement() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Segment 2"].tap()
        
        let alert = app.alerts["Segment Element"]
        let dismissButton = alert.buttons["Dismiss"]
        
        XCTAssert(alert.staticTexts["The selected value changed to \"Segment 2\"."].exists)
        dismissButton.tap()
        
        elementsQuery.buttons["Segment 1"].tap()
        XCTAssert(alert.staticTexts["The selected value changed to \"Segment 1\"."].exists)
        dismissButton.tap()
    }
    
    func testTextFieldElement() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let textField = elementsQuery.textFields["Text Field Element (Email)"]
            
        textField.tap()
        app.typeText("test@test.com")
        app.buttons["Return"].tap()
        
        XCTAssert(app.staticTexts["test@test.com"].exists)
    }
    
    func testSegueElement() {
        let app = XCUIApplication()
        app.scrollViews.otherElements.staticTexts["Segue Element"].tap()
        app.alerts["Segue Element"].collectionViews.buttons["Dismiss"].tap()
    }
}
