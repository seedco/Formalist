//
//  FloatLabelElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-13.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

/// An element that implements the float label pattern:
/// http://bradfrost.com/blog/post/float-label-pattern/
public final class FloatLabelElement: FormElement, Validatable {
    public typealias ViewConfigurator = FloatLabel -> Void
    
    private let name: String
    private let value: FormValue<String>
    private let validationRules: [ValidationRule<String>]
    private let viewConfigurator: ViewConfigurator?
    
    private let textViewDelegate: TextViewDelegate
    
    /**
     Designated initializer
     
     - parameter name:                         The name of the field, to 
     display over the editable field
     - parameter value:                        The value to bind to this element
     - parameter continuous:                   If this is `true`, the value 
     will be continuously updated as text is typed into the view. If this is 
     `false`, the value will only be updated when the text view has finished 
     editing. Defaults to `false`
     - parameter maximumLength:                Restricts the length of the text 
     entered into the field, such that a user cannot enter any more text after 
     the limit has been reached.
     - parameter resignFirstResponderOnReturn: Whether the text view should
     resign first responder status and activate the next first responder
     upon the user pressing the "Return" key on the keyboard. Defaults to
     `true`.
     - parameter validationRules:              Rules used for validating the
     input
     - parameter viewConfigurator:             An optional block used to
     configure the appearance of the float label
     
     - returns: An initialized instance of the receiver
     */
    public init(name: String, value: FormValue<String>, continuous: Bool = false, maximumLength: Int? = nil, resignFirstResponderOnReturn: Bool = true, validationRules: [ValidationRule<String>] = [], viewConfigurator: ViewConfigurator? = nil) {
        self.name = name
        self.value = value
        self.validationRules = validationRules
        self.viewConfigurator = viewConfigurator
        self.textViewDelegate = TextViewDelegate(resignFirstResponderOnReturn: resignFirstResponderOnReturn, continuous: continuous, maximumLength: maximumLength) {
            value.value = $0
        }
    }
    
    public func render() -> UIView {
        let floatLabel = FloatLabel(name: name)
        floatLabel.bodyTextView.text = value.value
        floatLabel.bodyTextView.delegate = textViewDelegate
        viewConfigurator?(floatLabel)
        floatLabel.recomputeMinimumHeight()
        return floatLabel
    }

    // MARK: Validatable
    
    public func validate(completionHandler: ValidationResult -> Void) {
        ValidationRule.validateRules(validationRules, forValue: value.value,  completionHandler: completionHandler)
    }
}
