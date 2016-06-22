//
//  ValidationErrorViewTests.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Formalist

class ValidationErrorViewTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRender() {
        let view = ValidationErrorView(frame: CGRectZero)
        view.label.text = "Error message"
        
        sizeViewForTesting(view)
        FBSnapshotVerifyView(view)
    }
}
