//
//  FormValueTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-05-25.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
@testable import Forms

class FormValueTests: XCTestCase {
    func testAddObserver() {
        let value = FormValue("")
        var count = 0
        
        value.addObserver { _ in count += 1 }
        value.value = "foo"
        value.addObserver { _ in count += 1 }
        value.value = "bar"
        
        XCTAssertEqual(3, count)
    }
    
    func testRemoveObserver() {
        let value = FormValue("")
        var count = 0
        
        let token = value.addObserver { _ in count += 1 }
        value.addObserver { _ in count += 1 }
        value.value = "foo"
        value.removeObserverWithToken(token)
        value.value = "bar"
        
        XCTAssertEqual(3, count)
    }
}
