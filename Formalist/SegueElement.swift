//
//  SegueElement.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-05-01.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import Foundation

/// An element containing an image view and a label that invokes an action
/// when tapped on.
public final class SegueElement: FormElement {
    public typealias ViewConfigurator = (SegueElementView) -> Void
    
    fileprivate let icon: UIImage?
    fileprivate let title: String
    fileprivate let accessoryIcon: UIImage?
    fileprivate let viewConfigurator: ViewConfigurator?
    fileprivate let action: (Void) -> Void
    
    /**
     Designated initializer
     
     - parameter icon:             An optional icon to display
     - parameter title:            The title to display
     - parameter accessoryIcon:        An optional icon to display in the accessory view
     - parameter viewConfigurator: An optional block used to configure the appearance
     of the view
     - parameter action:           The action to invoke when the view is tapped
     
     - returns: An initialized instance of the receiver
     */
    public init(icon: UIImage?, title: String, accessoryIcon: UIImage?, viewConfigurator: ViewConfigurator? = nil, action: @escaping (Void) -> Void) {
        self.icon = icon
        self.title = title
        self.accessoryIcon = accessoryIcon
        self.viewConfigurator = viewConfigurator
        self.action = action
    }
    
    public func render() -> UIView {
        let view = SegueElementView(icon: icon, title: title, accessoryIcon: accessoryIcon)
        viewConfigurator?(view)
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(SegueElement.performSegueAction(_:))
        )
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }
    
    @objc fileprivate func performSegueAction(_ sender: UITapGestureRecognizer) {
        action()
    }
}
