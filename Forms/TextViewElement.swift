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
    
    private let value: FormValue<String>
    private let continuous: Bool
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
     - parameter validationRules:  Rules used for validating the input
     - parameter viewConfigurator: An optional block used to configure the
     appearance of the text view
     
     - returns: An initialized instance of the receiver
     */
    public init(value: FormValue<String>, continuous: Bool = false, validationRules: [ValidationRule<String>] = [], viewConfigurator: ViewConfigurator? = nil) {
        self.value = value
        self.continuous = continuous
        self.validationRules = validationRules
        self.viewConfigurator = viewConfigurator
        self.textViewDelegate = TextViewDelegate(resignFirstResponderOnReturn: false)
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
        
        let notificationName = continuous ? UITextViewTextDidChangeNotification : UITextViewTextDidEndEditingNotification
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(TextViewElement.textChanged(_:)),
            name: notificationName,
            object: textView
        )
        viewConfigurator?(textView)
        return textView
    }
    
    // MARK: Actions
    
    @objc private func textChanged(notification: NSNotification) {
        guard let textView = notification.object as? UITextView else {
            fatalError("Unexpected notification object: \(notification.object)")
        }
        value.value = textView.text ?? ""
    }
    
    // MARK: Validatable
    
    public func validate(completionHandler: ValidationResult -> Void) {
        ValidationRule.validateRules(validationRules, forValue: value.value,  completionHandler: completionHandler)
    }
}
