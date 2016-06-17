//
//  UITextFieldTextEditorAdapter.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

@objc final class UITextFieldTextEditorAdapter: NSObject, TextEditorAdapter, UITextFieldDelegate {
    typealias TextChangedObserver = String -> Void
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRectZero)
        textField.delegate = self
        return textField
    }()
    
    var view: UIView { return textField }
    
    var text: String {
        get { return textField.text ?? "" }
        set { textField.text = newValue }
    }
    
    weak var delegate: TextEditorAdapterDelegate?
    
    private let configuration: TextEditorConfiguration
    private let textChangedObserver: TextChangedObserver
    
    init(configuration: TextEditorConfiguration, textChangedObserver: TextChangedObserver) {
        self.configuration = configuration
        self.textChangedObserver = textChangedObserver
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.textEditorAdapterTextDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.textEditorAdapterTextDidEndEditing(self)
        if !configuration.continuouslyUpdatesValue {
            textChangedObserver(textField.text ?? "")
        }
    }
    
    @objc private func textFieldTextDidChange(notification: NSNotification) {
        delegate?.textEditorAdapterTextDidChange(self)
        if configuration.continuouslyUpdatesValue {
            textChangedObserver(textField.text ?? "")
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let maximumLength = configuration.maximumLength, text = textField.text {
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= maximumLength
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch configuration.returnKeyAction {
        case .None: return true
        case .ActivateNextResponder:
            if let nextFormResponder = textField.nextFormResponder where nextFormResponder.becomeFirstResponder() {
                return false
            } else {
                textField.resignFirstResponder()
                return false
            }
        case let .Custom(action):
            action(textField.text ?? "")
            return false
        }
    }
}
