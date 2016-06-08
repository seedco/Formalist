//
//  TextFieldElementTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Forms

class TextFieldElementTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRender() {
        let element = TextFieldElement(value: FormValue("Text Field Element")) {
            $0.textColor = .redColor()
            $0.textAlignment = .Center
        }
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
}
