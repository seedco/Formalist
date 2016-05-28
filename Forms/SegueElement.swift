//
//  SegueElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-05-01.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import Foundation

/// An element containing an image view and a label that invokes an action
/// when tapped on.
public class SegueElement: FormElement {
    public typealias ViewConfigurator = SegueElementView -> Void
    
    private let icon: UIImage?
    private let title: String
    private let viewConfigurator: ViewConfigurator?
    private let action: Void -> Void
    
    /**
     Designated initializer
     
     - parameter icon:             An optional icon to display
     - parameter title:            The title to display
     - parameter viewConfigurator: An optional block used to configure the appearance
     of the view
     - parameter action:           The action to invoke when the view is tapped
     
     - returns: An initialized instance of the receiver
     */
    public init(icon: UIImage?, title: String, viewConfigurator: ViewConfigurator? = nil, action: Void -> Void) {
        self.icon = icon
        self.title = title
        self.viewConfigurator = viewConfigurator
        self.action = action
    }
    
    public func render() -> UIView {
        let view = SegueElementView(icon: icon, title: title)
        viewConfigurator?(view)
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(SegueElement.performSegueAction(_:))
        )
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }
    
    @objc private func performSegueAction(sender: UITapGestureRecognizer) {
        action()
    }
}
