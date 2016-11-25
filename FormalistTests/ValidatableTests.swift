//
//  ValidatableTests.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-10.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
@testable import Formalist

private class TestValidatable: Validatable {
    fileprivate let result: ValidationResult
    
    init(result: ValidationResult) {
        self.result = result
    }
    
    fileprivate func validate(_ completionHandler: @escaping (ValidationResult) -> Void) {
        completionHandler(result)
    }
}

class ValidatableTests: XCTestCase {
    func testValidateAndStoreResult() {
        let validatable = TestValidatable(result: .valid)
        XCTAssertNil(validatable.validationResult)
        
        let expectation = self.expectation(description: "validation")
        validatable.validateAndStoreResult { result in
            XCTAssert(result == .valid)
            XCTAssert(validatable.validationResult == result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testValidateObjectsWithNoObjects() {
        let expectation = self.expectation(description: "validate objects")
        validateObjects([]) { result in
            XCTAssert(result == .valid)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testValidateObjectsWithAllValid() {
        let validatable1 = TestValidatable(result: .valid)
        let validatable2 = TestValidatable(result: .valid)
        
        let expectation = self.expectation(description: "validate objects")
        validateObjects([validatable1, validatable2]) { result in
            XCTAssert(result == .valid)
            XCTAssert(validatable1.validationResult == result)
            XCTAssert(validatable2.validationResult == result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testValidateObjectsWithOneInvalidObject() {
        let invalidResult = ValidationResult.invalid(message: "Validation failed")
        let validatable1 = TestValidatable(result: invalidResult)
        let validatable2 = TestValidatable(result: .valid)
        
        let expectation = self.expectation(description: "validate objects")
        validateObjects([validatable1, validatable2]) { result in
            XCTAssert(result == invalidResult)
            XCTAssert(validatable1.validationResult == result)
            XCTAssertNil(validatable2.validationResult)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testValidateObjectsWithOneCancelledObject() {
        let validatable1 = TestValidatable(result: .cancelled)
        let validatable2 = TestValidatable(result: .valid)
        
        let expectation = self.expectation(description: "validate objects")
        validateObjects([validatable1, validatable2]) { result in
            XCTAssert(result == .cancelled)
            XCTAssert(validatable1.validationResult == result)
            XCTAssertNil(validatable2.validationResult)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
