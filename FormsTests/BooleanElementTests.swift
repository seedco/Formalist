//
//  BooleanElementTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Forms

class BooleanElementTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRender() {
        let element = BooleanElement(title: "Test Boolean Element", value: FormValue(false))
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
}
