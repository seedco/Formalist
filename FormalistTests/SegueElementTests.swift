//
//  SegueElementTests.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Formalist

class SegueElementTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRenderWithoutIcon() {
        let element = SegueElement(icon: nil, title: "Segue Element",viewConfigurator: {
            $0.label.textAlignment = .Center
            $0.label.textColor = .redColor()
        }, action: {})
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
    
    func testRenderWithIcon() {
        let icon = imageWithName("circle").withRenderingMode(.alwaysTemplate)
        let element = SegueElement(icon: icon, title: "Segue Element", viewConfigurator: {
            $0.imageView.tintColor = .orangeColor()
        }, action: {})
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
}
