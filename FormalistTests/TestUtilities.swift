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

func renderElementForTesting(element: FormElement) -> UIView {
    let view = element.render()
    sizeViewForTesting(view)
    return view
}

func sizeViewForTesting(view: UIView) {
    let widthConstraint = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 320.0)
    widthConstraint.active = true
    
    view.layoutIfNeeded()
    let fittingSize = view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    view.frame = CGRect(origin: CGPointZero, size: fittingSize)
}

func imageWithName(name: String) -> UIImage {
    let bundle = NSBundle(forClass: DummyClass.self)
    if let image = UIImage(named: name, inBundle: bundle, compatibleWithTraitCollection: nil) {
        return image
    } else {
        fatalError("Image with name \(name) not found in asset catalog")
    }
}
