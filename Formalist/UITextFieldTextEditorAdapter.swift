//
//  UITextFieldTextEditorAdapter.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// Adapts a `UITextField` to a generic interface used by
/// form elements that perform text editing.
public final class UITextFieldTextEditorAdapter<TextFieldType: UITextField>: TextEditorAdapter {
    public typealias ViewType = TextFieldType
    
    private let configuration: TextEditorConfiguration
    
    public init(configuration: TextEditorConfiguration) {
        self.configuration = configuration
    }
    
    public func createViewWithCallbacks(callbacks: TextEditorAdapterCallbacks<UITextFieldTextEditorAdapter<ViewType>>, textChangedObserver: TextChangedObserver) -> ViewType {
        let textField = TextFieldType(frame: CGRectZero)
        let delegate = TextFieldDelegate(
            textField: textField,
            adapter: self,
            configuration: configuration,
            callbacks: callbacks,
            textChangedObserver: textChangedObserver
        )
        
        (textField as UITextField).delegate = delegate
        textField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        objc_setAssociatedObject(textField, &ObjCTextFieldDelegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return textField
    }
    
    public func getTextForView(view: ViewType) -> String {
        return view.text ?? ""
    }
    
    public func setText(text: String, forView view: ViewType) {
        view.text = text
    }
}

private var ObjCTextFieldDelegateKey: UInt8 = 0

private final class TextFieldDelegate<TextFieldType: UITextField>: NSObject, UITextFieldDelegate {
    private typealias AdapterType = UITextFieldTextEditorAdapter<TextFieldType>
    
    private let adapter: AdapterType
    private let configuration: TextEditorConfiguration
    private let callbacks: TextEditorAdapterCallbacks<AdapterType>
    private let textChangedObserver: TextChangedObserver
    
    init(textField: TextFieldType, adapter: AdapterType, configuration: TextEditorConfiguration, callbacks: TextEditorAdapterCallbacks<AdapterType>, textChangedObserver: TextChangedObserver) {
        self.adapter = adapter
        self.configuration = configuration
        self.callbacks = callbacks
        self.textChangedObserver = textChangedObserver
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(TextFieldDelegate.textFieldTextDidChange(_:)),
            name: UITextFieldTextDidChangeNotification,
            object: textField
        )
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: UITextFieldDelegate
    
    @objc private func textFieldDidBeginEditing(textField: UITextField) {
        guard let textField = textField as? TextFieldType else {
            fatalError("Expected text field of type \(TextFieldType.self)")
        }
        callbacks.textDidBeginEditing?(adapter, textField)
    }
    
    @objc private func textFieldDidEndEditing(textField: UITextField) {
        guard let textField = textField as? TextFieldType else {
            fatalError("Expected text field of type \(TextFieldType.self)")
        }
        callbacks.textDidEndEditing?(adapter, textField)
        if !configuration.continuouslyUpdatesValue {
            textChangedObserver(textField.text ?? "")
        }
    }
    
    @objc private func textFieldTextDidChange(notification: NSNotification) {
        guard let textField = notification.object as? TextFieldType else {
            fatalError("Expected text field of type \(TextFieldType.self)")
        }
        callbacks.textDidChange?(adapter, textField)
        if configuration.continuouslyUpdatesValue {
            textChangedObserver(textField.text ?? "")
        }
    }
    
    @objc private func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let maximumLength = configuration.maximumLength, text = textField.text {
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= maximumLength
        } else {
            return true
        }
    }
    
    @objc private func textFieldShouldReturn(textField: UITextField) -> Bool {
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
