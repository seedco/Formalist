//
//  SpacerElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-04.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

/// An element that displays a spacer of a fixed height
public class SpacerElement: FormElement {
    private let height: CGFloat
    private let backgroundColor: UIColor
    
    /**
     Designated initializer
     
     - parameter height:          The height of the spacer
     - parameter backgroundColor: The background color of the spacer
     
     - returns: An initialized instance of the receiver
     */
    public init(height: CGFloat, backgroundColor: UIColor) {
        self.height = height
        self.backgroundColor = backgroundColor
    }
    
    // MARK: FormElement
    
    public func render() -> UIView {
        let view = UIView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
        heightConstraint.active = true
        
        return view
    }
}
