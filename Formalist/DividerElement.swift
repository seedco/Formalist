//
//  DividerElement.swift
//  Formalist
//
//  Created by Viktor Radchenko on 9/17/16.
//
//

import UIKit

/// An element used to show divider line
public final class DividerElement: FormElement {
    public typealias ViewConfigurator = (UIView) -> Void

    public var color: UIColor
    private var height: CGFloat
    private let viewConfigurator: ViewConfigurator?

    /**
     Designated initializer

     - parameter color:            Divider line color
     - parameter height:           Divider line height
     - parameter viewConfigurator: An optional block used to configure the view

     - returns: An initialized instance of the receiver
     */

    public init(color: UIColor, height: CGFloat = 1, viewConfigurator: ViewConfigurator? = nil) {
        self.color = color
        self.height = height
        self.viewConfigurator = viewConfigurator
    }

    public func render() -> UIView {
        let view = UIView()
        view.backgroundColor = color
        let heightConstraint = NSLayoutConstraint(
            item: view,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: height
        )
        view.addConstraint(heightConstraint)
        viewConfigurator?(view)
        return view
    }
}
