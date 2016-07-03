//
//  StaticTextElementTests.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Formalist

class StaticTextElementTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRender() {
        let element = staticText("Static Text Element") {
            $0.textAlignment = .Center
            $0.textColor = .redColor()
        }
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testUpdateViewByUpdatingValue() {
        let value = FormValue("foo")
        let element = staticText(value)
        let elementView = element.render() as! UILabel
        
        value.value = "bar"
        XCTAssertEqual("bar", elementView.text)
    }
}
