//
//  ValidationRuleTests.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-10.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
@testable import Formalist

class ValidationRuleTests: XCTestCase {
    func testValidateWithNoRules() {
        let expectation = self.expectation(description: "validate rules")
        ValidationRule.validateRules([], forValue: "") { result in
            XCTAssert(result == .valid)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testValidateWithAllValidRules() {
        var evaluated1 = false, evaluated2 = false
        let rule1 = ValidationRule<String> { _, completion in
            evaluated1 = true
            completion(.valid)
        }
        let rule2 = ValidationRule<String> { _, completion in
            evaluated2 = true
            completion(.valid)
        }
        
        let expectation = self.expectation(description: "validate rules")
        ValidationRule.validateRules([rule1, rule2], forValue: "") { result in
            XCTAssert(evaluated1)
            XCTAssert(evaluated2)
            XCTAssert(result == .valid)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testValidateWithOneInvalidRule() {
        var evaluated1 = false, evaluated2 = false
        let invalidResult = ValidationResult.invalid(message: "Validation failed")
        let rule1 = ValidationRule<String> { _, completion in
            evaluated1 = true
            completion(invalidResult)
        }
        let rule2 = ValidationRule<String> { _, completion in
            evaluated2 = true
            completion(.valid)
        }
        
        let expectation = self.expectation(description: "validate rules")
        ValidationRule.validateRules([rule1, rule2], forValue: "") { result in
            XCTAssert(evaluated1)
            XCTAssertFalse(evaluated2)
            XCTAssert(result == invalidResult)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testValidateWithOneCancelledRule() {
        var evaluated1 = false, evaluated2 = false
        let rule1 = ValidationRule<String> { _, completion in
            evaluated1 = true
            completion(.cancelled)
        }
        let rule2 = ValidationRule<String> { _, completion in
            evaluated2 = true
            completion(.valid)
        }
        
        let expectation = self.expectation(description: "validate rules")
        ValidationRule.validateRules([rule1, rule2], forValue: "") { result in
            XCTAssert(evaluated1)
            XCTAssertFalse(evaluated2)
            XCTAssert(result == .cancelled)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testRequiredRuleWithValidInput() {
        let expectation = self.expectation(description: "validate rule")
        ValidationRule<String>.required.validate("foo") { result in
            XCTAssert(result == .valid)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testRequiredRuleWithInvalidInput() {
        let expectation = self.expectation(description: "validate rule")
        ValidationRule<String>.required.validate("") { result in
            if case .invalid = result {
            } else {
                XCTFail("Expected validation result to be invalid")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    fileprivate let TestRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "\\d\\d\\d", options: [])
    }()
    
    func testRegexRuleWithValidInput() {
        let expectation = self.expectation(description: "validate rule")
        let rule = ValidationRule<String>.regex(TestRegex, failureMessage: "Regex validation failed")
        rule.validate("012") { result in
            XCTAssert(result == .valid)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testRegexRuleWithInvalidInput() {
        let expectation = self.expectation(description: "validate rule")
        let rule = ValidationRule<String>.regex(TestRegex, failureMessage: "Regex validation failed")
        rule.validate("01") { result in
            if case .invalid = result {
            } else {
                XCTFail("Expected validation result to be invalid")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testRegexRuleWithEmptyInput() {
        let expectation = self.expectation(description: "validate rule")
        let rule = ValidationRule<String>.regex(TestRegex, failureMessage: "Regex validation failed")
        rule.validate("") { result in
            XCTAssert(result == .valid)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testCharacterSetRuleWithValidInput() {
        let expectation = self.expectation(description: "validate rule")
        let rule = ValidationRule<String>.characterSet(.alphanumerics)
        rule.validate("abc123") { result in
            XCTAssert(result == .valid)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testCharacterSetRuleWithInvalidInput() {
        let expectation = self.expectation(description: "validate rule")
        let rule = ValidationRule<String>.characterSet(.alphanumerics)
        rule.validate("$$$") { result in
            if case .invalid = result {
            } else {
                XCTFail("Expected validation result to be invalid")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testMaximumLengthRuleWithValidInput() {
        let expectation = self.expectation(description: "validate rule")
        let rule = ValidationRule<String>.maximumLength(5)
        rule.validate("foo") { result in
            XCTAssert(result == .valid)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testMaximumLengthRuleWithInvalidInput() {
        let expectation = self.expectation(description: "validate rule")
        let rule = ValidationRule<String>.maximumLength(5)
        rule.validate("foobar") { result in
            if case .invalid = result {
            } else {
                XCTFail("Expected validation result to be invalid")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testMinimumLengthRuleWithValidInput() {
        let expectation = self.expectation(description: "validate rule")
        let rule = ValidationRule<String>.minimumLength(3)
        rule.validate("foo") { result in
            XCTAssert(result == .valid)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testMinimumLengthRuleWithInvalidInput() {
        let expectation = self.expectation(description: "validate rule")
        let rule = ValidationRule<String>.minimumLength(3)
        rule.validate("o") { result in
            if case .invalid = result {
            } else {
                XCTFail("Expected validation result to be invalid")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
