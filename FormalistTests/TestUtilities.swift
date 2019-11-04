//
//  TestUtilities.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import Formalist

private class DummyClass {}

func renderElementForTesting(_ element: FormElement) -> UIView {
    let view = element.render()
    sizeViewForTesting(view)
    return view
}

func sizeViewForTesting(_ view: UIView) {
    let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 320.0)
    widthConstraint.isActive = true
    
    view.layoutIfNeeded()
    let fittingSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    view.frame = CGRect(origin: CGPoint.zero, size: fittingSize).integral
}

func imageWithName(_ name: String) -> UIImage {
    let bundle = Bundle(for: DummyClass.self)
    if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
        return image
    } else {
        fatalError("Image with name \(name) not found in asset catalog")
    }
}
