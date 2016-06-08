//
//  StaticTextElementTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Forms

class StaticTextElementTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRender() {
        let element = StaticTextElement(text: "Static Text Element") {
            $0.textAlignment = .Center
            $0.textColor = .redColor()
        }
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
}
