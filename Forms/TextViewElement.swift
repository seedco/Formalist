//
//  TextViewElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-04.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import Foundation

@objc public final class TextViewElement: NSObject, FormElement, Validatable,  UITextViewDelegate {
    public typealias ViewConfigurator = PlaceholderTextView -> Void
    
    private let value: FormValue<String>
    private let continuous: Bool
    private let validationRules: [ValidationRule<String>]
    private let viewConfigurator: ViewConfigurator?
    
    /**
     Designated initializer
     
     - parameter value:            The value to bind to this element
     - parameter continuous:       If this is `true`, the value will be
     continuously updated as text is typed into the view. If this is `false`,
     the value will only be updated when the text view has finished editing.
     Defaults to `false`
     - parameter viewConfigurator: An optional block used to configure the
     appearance of the text view
     
     - returns: An initialized instance of the receiver
     */
    public init(value: FormValue<String>, continuous: Bool = false, validationRules: [ValidationRule<String>] = [], viewConfigurator: ViewConfigurator? = nil) {
        self.value = value
        self.continuous = continuous
        self.validationRules = validationRules
        self.viewConfigurator = viewConfigurator
    }
    
    // MARK: FormElement
    
    public func render() -> UIView {
        let textView = PlaceholderTextView(frame: CGRectZero)
        textView.delegate = self
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
    
    // MARK: UITextViewDelegate
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // http://stackoverflow.com/a/23779209
        if let _ = text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet(), options: NSStringCompareOptions.BackwardsSearch) where text.characters.count == 1 {
            if let nextFormResponder = textView.nextFormResponder where nextFormResponder.becomeFirstResponder() {
                return false
            } else {
                textView.resignFirstResponder()
                return false
            }
        } else {
            return true
        }
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
