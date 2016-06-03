//
//  TextFieldElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-05-31.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// An element that displays an editable text field
public final class TextFieldElement: FormElement, Validatable {
    public typealias ViewConfigurator = UITextField -> Void
    
    private let value: FormValue<String>
    private let continuous: Bool
    private let validationRules: [ValidationRule<String>]
    private let viewConfigurator: ViewConfigurator?
    
    /**
     Designated initializer
     
     - parameter value:            The value to bind to this element
     - parameter continuous:       If this is `true`, the value will be
     continuously updated as text is typed into the field. If this is `false`, 
     the value will only be updated when the text field has finished editing.
     Defaults to `false`
     - parameter viewConfigurator: An optional block used to configure the
     appearance of the text field
     
     - returns: An initialized instance of the receiver
     */
    public init(value: FormValue<String>, continuous: Bool = false, validationRules: [ValidationRule<String>] = [], viewConfigurator: ViewConfigurator? = nil) {
        self.value = value
        self.continuous = continuous
        self.validationRules = validationRules
        self.viewConfigurator = viewConfigurator
    }
    
    public func render() -> UIView {
        let textField = UITextField(frame: CGRectZero)
        textField.text = value.value
        let notificationName = continuous ? UITextFieldTextDidChangeNotification : UITextFieldTextDidEndEditingNotification
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(TextFieldElement.textChanged(_:)),
            name: notificationName,
            object: textField
        )
        viewConfigurator?(textField)
        return textField
    }
    
    // MARK: Actions
    
    @objc private func textChanged(notification: NSNotification) {
        guard let textField = notification.object as? UITextField else {
            fatalError("Unexpected notification object: \(notification.object)")
        }
        value.value = textField.text ?? ""
    }
    
    // MARK: Validatable
    
    public func validate(completionHandler: ValidationResult -> Void) {
        ValidationRule.validateRules(validationRules, forValue: value.value,  completionHandler: completionHandler)
    }
}
