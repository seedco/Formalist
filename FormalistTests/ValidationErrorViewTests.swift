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
        
        let heightConstraint = NSLayoutConstraint(
            item: view,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: 30.0
        )
        heightConstraint.active = true
        
        sizeViewForTesting(view)
        FBSnapshotVerifyView(view)
    }
}
