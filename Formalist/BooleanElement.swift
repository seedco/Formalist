//
//  BooleanElement.swift
//  Seed
//
//  Created by Indragie Karunaratne on 3/4/16.
//
//

import UIKit

/// A form element that displays a toggle switch for setting a boolean value.
public final class BooleanElement: FormElement {
    public typealias ViewConfigurator = (BooleanElementView) -> Void
    
    fileprivate let title: String
    fileprivate let value: FormValue<Bool>
    fileprivate let icon: UIImage?
    fileprivate let viewConfigurator: ViewConfigurator?

    /**
     Designated initializer

     - parameter title:            The title to display
     - parameter value:            The form value to bind to the toggle
     - parameter icon:             An optional icon to display beside the toggle
     - parameter viewConfigurator: An optional block used to configure the appearance
     of the view

     - returns: An initialized instance of the receiver
     */
    public init(title: String, value: FormValue<Bool>, icon: UIImage? = nil, viewConfigurator: ViewConfigurator? = nil) {
        self.title = title
        self.value = value
        self.icon = icon
        self.viewConfigurator = viewConfigurator
    }
    
    public func render() -> UIView {
        let booleanView = BooleanElementView(title: title, icon: icon)
        booleanView.toggle.addTarget(
            self,
            action: #selector(BooleanElement.valueChanged(_:)),
            for: .valueChanged
        )
        let updateView: (Bool) -> Void = { [weak booleanView] in
            guard let booleanView = booleanView else { return }
            if !booleanView.shouldIgnoreFormValueChanges {
                booleanView.toggle.isOn = $0
            }
        }
        updateView(value.value)
        let _ = value.addObserver(updateView)
        viewConfigurator?(booleanView)
        return booleanView
    }
    
    @objc fileprivate func valueChanged(_ sender: UISwitch) {
        sender.shouldIgnoreFormValueChanges = true
        value.value = sender.isOn
        sender.shouldIgnoreFormValueChanges = false
    }
}
