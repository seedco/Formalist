//
//  TextFieldElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-05-31.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

/// An element that displays an editable text field
@objc public final class TextFieldElement: NSObject, FormElement, Validatable,  UITextFieldDelegate {
    public typealias ViewConfigurator = UITextField -> Void
    
    private let value: FormValue<String>
    private let continuous: Bool
    private let maximumLength: Int?
    private let validationRules: [ValidationRule<String>]
    private let viewConfigurator: ViewConfigurator?
    
    /**
     Designated initializer
     
     - parameter value:            The value to bind to this element
     - parameter continuous:       If this is `true`, the value will be
     continuously updated as text is typed into the field. If this is `false`, 
     the value will only be updated when the text field has finished editing.
     Defaults to `false`
     - parameter maximumLength:    Restricts the length of the text entered into
     the field, such that a user cannot enter any more text after the limit has
     been reached.
     - parameter viewConfigurator: An optional block used to configure the
     appearance of the text field
     
     - returns: An initialized instance of the receiver
     */
    public init(value: FormValue<String>, continuous: Bool = false, maximumLength: Int? = nil, validationRules: [ValidationRule<String>] = [], viewConfigurator: ViewConfigurator? = nil) {
        self.value = value
        self.continuous = continuous
        self.maximumLength = maximumLength
        self.validationRules = validationRules
        self.viewConfigurator = viewConfigurator
    }
    
    // MARK: FormElement
    
    public func render() -> UIView {
        let textField = UITextField(frame: CGRectZero)
        textField.text = value.value
        textField.delegate = self
        
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
    
    // MARK: UITextFieldDelegate
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let maximumLength = maximumLength, text = textField.text {
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= maximumLength
        } else {
            return true
        }
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let nextFormResponder = textField.nextFormResponder where nextFormResponder.becomeFirstResponder() {
            return false
        } else {
            textField.resignFirstResponder()
            return false
        }
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
