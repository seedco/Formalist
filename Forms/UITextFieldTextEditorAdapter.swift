//
//  UITextFieldTextEditorAdapter.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

/// Adapts a `UITextField` to a generic interface used by
/// form elements that perform text editing.
@objc public final class UITextFieldTextEditorAdapter: NSObject, TextEditorAdapter, UITextFieldDelegate {
    public private(set) lazy var view: UITextField = {
        let textField = UITextField(frame: CGRectZero)
        textField.delegate = self
        return textField
    }()
    
    public var text: String {
        get { return view.text ?? "" }
        set { view.text = newValue }
    }
    
    public weak var delegate: TextEditorAdapterDelegate?
    
    private let configuration: TextEditorConfiguration
    private let textChangedObserver: TextChangedObserver
    
    public init(configuration: TextEditorConfiguration, textChangedObserver: TextChangedObserver) {
        self.configuration = configuration
        self.textChangedObserver = textChangedObserver
    }
    
    // MARK: UITextFieldDelegate
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.textEditorAdapterTextDidBeginEditing(self)
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        delegate?.textEditorAdapterTextDidEndEditing(self)
        if !configuration.continuouslyUpdatesValue {
            textChangedObserver(textField.text ?? "")
        }
    }
    
    @objc private func textFieldTextDidChange(notification: NSNotification) {
        delegate?.textEditorAdapterTextDidChange(self)
        if configuration.continuouslyUpdatesValue {
            textChangedObserver(view.text ?? "")
        }
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let maximumLength = configuration.maximumLength, text = textField.text {
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= maximumLength
        } else {
            return true
        }
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch configuration.returnKeyAction {
        case .None: return true
        case .ActivateNextResponder:
            if !(textField.nextFormResponder?.becomeFirstResponder() ?? false) {
                textField.resignFirstResponder()
            }
            return false
        case let .Custom(action):
            action(textField.text ?? "")
            return false
        }
    }
}
