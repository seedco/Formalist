//
//  ValidationRuleTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-10.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import XCTest
@testable import Forms

class ValidationRuleTests: XCTestCase {
    func testValidateWithAllValidRules() {
        var evaluated1 = false, evaluated2 = false
        let rule1 = ValidationRule<String> { _, completion in
            evaluated1 = true
            completion(.Valid)
        }
        let rule2 = ValidationRule<String> { _, completion in
            evaluated2 = true
            completion(.Valid)
        }
        
        let expectation = expectationWithDescription("validate rules")
        ValidationRule.validateRules([rule1, rule2], forValue: "") { result in
            XCTAssert(evaluated1)
            XCTAssert(evaluated2)
            XCTAssert(result == .Valid)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func testValidateWithOneInvalidRule() {
        var evaluated1 = false, evaluated2 = false
        let invalidResult = ValidationResult.Invalid(message: "Validation failed")
        let rule1 = ValidationRule<String> { _, completion in
            evaluated1 = true
            completion(invalidResult)
        }
        let rule2 = ValidationRule<String> { _, completion in
            evaluated2 = true
            completion(.Valid)
        }
        
        let expectation = expectationWithDescription("validate rules")
        ValidationRule.validateRules([rule1, rule2], forValue: "") { result in
            XCTAssert(evaluated1)
            XCTAssertFalse(evaluated2)
            XCTAssert(result == invalidResult)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func testValidateWithOneCancelledRule() {
        var evaluated1 = false, evaluated2 = false
        let rule1 = ValidationRule<String> { _, completion in
            evaluated1 = true
            completion(.Cancelled)
        }
        let rule2 = ValidationRule<String> { _, completion in
            evaluated2 = true
            completion(.Valid)
        }
        
        let expectation = expectationWithDescription("validate rules")
        ValidationRule.validateRules([rule1, rule2], forValue: "") { result in
            XCTAssert(evaluated1)
            XCTAssertFalse(evaluated2)
            XCTAssert(result == .Cancelled)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func testRequiredRuleWithValidInput() {
        let expectation = expectationWithDescription("validate rule")
        ValidationRule<String>.Required.validate("foo") { result in
            XCTAssert(result == .Valid)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func testRequiredRuleWithInvalidInput() {
        let expectation = expectationWithDescription("validate rule")
        ValidationRule<String>.Required.validate("") { result in
            if case .Invalid = result {
            } else {
                XCTFail("Expected validation result to be invalid")
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    private let TestRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "\\d\\d\\d", options: [])
    }()
    
    func testRegexRuleWithValidInput() {
        let expectation = expectationWithDescription("validate rule")
        let rule = ValidationRule<String>.fromRegex(TestRegex, failureMessage: "Regex validation failed")
        rule.validate("012") { result in
            XCTAssert(result == .Valid)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func testRegexRuleWithInvalidInput() {
        let expectation = expectationWithDescription("validate rule")
        let rule = ValidationRule<String>.fromRegex(TestRegex, failureMessage: "Regex validation failed")
        rule.validate("") { result in
            if case .Invalid = result {
            } else {
                XCTFail("Expected validation result to be invalid")
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
}
