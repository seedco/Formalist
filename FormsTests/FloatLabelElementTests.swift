//
//  FloatLabelElementTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-13.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Forms

class FloatLabelElementTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRenderWithEmptyValue() {
        let element = FloatLabelElement(name: "Test", value: FormValue(""))
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderWithNonEmptyValue() {
        let element = FloatLabelElement(name: "Test", value: FormValue("This is some text"))
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
}
