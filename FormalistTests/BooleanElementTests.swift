//
//  BooleanElementTests.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Formalist

class BooleanElementTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRenderWithoutIcon() {
        let element = BooleanElement(title: "Test Boolean Element", value: FormValue(false))
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }

    func testRenderWithIcon() {
        let icon = imageWithName("circle").withRenderingMode(.alwaysTemplate)
        let element = BooleanElement(title: "Test Boolean Element", value: FormValue(false), icon: icon)
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testUpdateViewByUpdatingValue() {
        let value = FormValue(false)
        let element = BooleanElement(title: "Test Boolean Element", value: value)
        let elementView = element.render() as! BooleanElementView
        value.value = true
        XCTAssertTrue(elementView.toggle.isOn)
    }
}
