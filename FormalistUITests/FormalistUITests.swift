//
//  FormalistUITests.swift
//  FormalistUITests
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest

class FormalistUITests: XCTestCase {
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
        app.alerts.buttons["Dismiss"].tap()
    }
    
    func testFloatLabelElement() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let floatLabelTextField = elementsQuery.textFields["floatLabel"]
        
        floatLabelTextField.tap()
        app.typeText("Hello World")
        app.alerts.buttons["Dismiss"].tap()
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
    }
    
    func testPickerField() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let pickerField = elementsQuery.textFields["pickerField"]
        
        pickerField.tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: "Value #3")
        
        guard let value = pickerField.value as? String else {
            return XCTAssert(false)
        }
        XCTAssert(value == "Value #3")
    }
    
    func testSegueElement() {
        let app = XCUIApplication()
        app.scrollViews.otherElements.staticTexts["Segue Element"].tap()
        app.alerts.buttons["Dismiss"].tap()
    }
    
    func testFailedValidation() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let textField = elementsQuery.textFields["Text Field Element (Email)"]
        
        textField.tap()
        app.typeText("foo")
        app.buttons["Return"].tap()
        
        app.navigationBars["foo"].buttons["Validate"].tap()
        XCTAssert(app.staticTexts["The email address is invalid"].exists)
    }
    
    func testSuccessfulValidation() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let textField = elementsQuery.textFields["Text Field Element (Email)"]
        
        textField.tap()
        app.typeText("test@test.com")
        
        app.navigationBars["test@test.com"].buttons["Validate"].tap()
        app.alerts.buttons["Dismiss"].tap()
    }
}
