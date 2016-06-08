//
//  ViewElementTests.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Forms

class ViewElementTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func testRenderActivityIndicator() {
        let element = ViewElement(value: FormValue("")) { _ in
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator.color = .blueColor()
            activityIndicator.hidesWhenStopped = false
            return activityIndicator
        }
        let elementView = renderElementForTesting(element)
        FBSnapshotVerifyView(elementView)
    }
}
