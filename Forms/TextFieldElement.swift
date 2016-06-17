//
//  TextFieldElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-05-31.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

/// An element that displays an editable text field
public final class TextFieldElement: FormElement, Validatable {
    public typealias ViewConfigurator = UITextField -> Void
    
    private let adapter: UITextFieldTextEditorAdapter
    private let value: FormValue<String>
    private let validationRules: [ValidationRule<String>]
    private let viewConfigurator: ViewConfigurator?
    
    /**
     Designated initializer
     
     - parameter value:            The string value to bind to the text field
     - parameter configuration:    Configuration options for the text field
     - parameter validationRules:  Rules used to validate the string value
     - parameter viewConfigurator: An optional block used to perform additional
     customization of the text field
     
     - returns: An initialized instance of the receiver
     */
    public init(value: FormValue<String>, configuration: TextEditorConfiguration = TextEditorConfiguration(), validationRules: [ValidationRule<String>] = [], viewConfigurator: ViewConfigurator? = nil) {
        self.value = value
        self.adapter = UITextFieldTextEditorAdapter(configuration: configuration) { value.value = $0 }
        self.adapter.text = value.value
        self.validationRules = validationRules
        self.viewConfigurator = viewConfigurator
    }
    
    // MARK: FormElement
    
    public func render() -> UIView {
        let textField = adapter.textField
        viewConfigurator?(textField)
        return textField
    }

    // MARK: Validatable
    
    public func validate(completionHandler: ValidationResult -> Void) {
        ValidationRule.validateRules(validationRules, forValue: value.value,  completionHandler: completionHandler)
    }
}
