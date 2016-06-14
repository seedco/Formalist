//
//  SpacerElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-04.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

/// An element that displays a spacer of a fixed height
public final class SpacerElement: FormElement {
    public typealias ViewConfigurator = UIView -> Void
    
    private let height: CGFloat
    private let viewConfigurator: ViewConfigurator?
    
    /**
     Designated initializer
     
     - parameter height:           The height of the spacer
     - parameter viewConfigurator: An optional block used to configure the
     appearance of the spacer view
     
     - returns: An initialized instance of the receiver
     */
    public init(height: CGFloat, viewConfigurator: ViewConfigurator? = nil) {
        self.height = height
        self.viewConfigurator = viewConfigurator
    }
    
    // MARK: FormElement
    
    public func render() -> UIView {
        let view = UIView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
        heightConstraint.active = true
        
        viewConfigurator?(view)
        return view
    }
}
