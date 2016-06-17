//
//  TextViewElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-04.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

public final class TextViewElement: FormElement, Validatable {
    public typealias ViewConfigurator = PlaceholderTextView -> Void
    
    private let value: FormValue<String>
    private let validationRules: [ValidationRule<String>]
    private let viewConfigurator: ViewConfigurator?
    
    private let textViewDelegate: TextViewDelegate
    
    /**
     Designated initializer
     
     - parameter value:            The value to bind to this element
     - parameter continuous:       If this is `true`, the value will be
     continuously updated as text is typed into the view. If this is `false`,
     the value will only be updated when the text view has finished editing.
     Defaults to `false`
     - parameter maximumLength:    Restricts the length of the text entered into
     the field, such that a user cannot enter any more text after the limit has
     been reached.
     - parameter validationRules:  Rules used for validating the input
     - parameter viewConfigurator: An optional block used to configure the
     appearance of the text view
     
     - returns: An initialized instance of the receiver
     */
    public init(value: FormValue<String>, continuous: Bool = false, maximumLength: Int? = nil, validationRules: [ValidationRule<String>] = [], viewConfigurator: ViewConfigurator? = nil) {
        self.value = value
        self.validationRules = validationRules
        self.viewConfigurator = viewConfigurator
        self.textViewDelegate = TextViewDelegate(resignFirstResponderOnReturn: false, continuous: continuous, maximumLength: maximumLength) {
            value.value = $0
        }
    }
    
    // MARK: FormElement
    
    public func render() -> UIView {
        let textView = PlaceholderTextView(frame: CGRectZero)
        textView.delegate = textViewDelegate
        textView.scrollEnabled = false
        textView.textContainerInset = UIEdgeInsetsZero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textView.backgroundColor = .clearColor()
        textView.text = value.value
        viewConfigurator?(textView)
        return textView
    }
    
    // MARK: Validatable
    
    public func validate(completionHandler: ValidationResult -> Void) {
        ValidationRule.validateRules(validationRules, forValue: value.value,  completionHandler: completionHandler)
    }
}
