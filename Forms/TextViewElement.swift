//
//  TextViewElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-04.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

public final class TextViewElement: FormElement, Validatable {
    public typealias ViewConfigurator = PlaceholderTextView -> Void
    
    private let adapter: UITextViewTextEditorAdapter
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
        self.adapter = UITextViewTextEditorAdapter(configuration: configuration) { value.value = $0 }
        self.adapter.text = value.value
        self.validationRules = validationRules
        self.viewConfigurator = viewConfigurator
    }
    
    // MARK: FormElement
    
    public func render() -> UIView {
        let textView = adapter.textView
        viewConfigurator?(textView)
        return textView
    }
    
    // MARK: Validatable
    
    public func validate(completionHandler: ValidationResult -> Void) {
        ValidationRule.validateRules(validationRules, forValue: value.value,  completionHandler: completionHandler)
    }
}
