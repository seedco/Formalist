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
    fileprivate let viewConfigurator: ViewConfigurator?
    
    /**
     Designated initializer
     
     - parameter title:            The title to display to the toggle
     - parameter value:            The form value to bind to the toggle
     - parameter viewConfigurator: An optional closure that can configure the
     element view, including the title `UILabel` and toggle `UISwitch`
     
     - returns: An initialized instance of the receiver
     */
    public init(title: String, value: FormValue<Bool>, viewConfigurator: ViewConfigurator? = nil) {
        self.title = title
        self.value = value
        self.viewConfigurator = viewConfigurator
    }
    
    public func render() -> UIView {
        let booleanView = BooleanElementView(title: title)
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
        value.addObserver(updateView)
        viewConfigurator?(booleanView)
        return booleanView
    }
    
    @objc fileprivate func valueChanged(_ sender: UISwitch) {
        sender.shouldIgnoreFormValueChanges = true
        value.value = sender.isOn
        sender.shouldIgnoreFormValueChanges = false
    }
}
