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
    public typealias TextChangedObserver = (UITextFieldTextEditorAdapter<ViewType>, ViewType) -> Void
    
    fileprivate let configuration: TextEditorConfiguration
    
    public init(configuration: TextEditorConfiguration) {
        self.configuration = configuration
    }
    
    public func createViewWithCallbacks(_ callbacks: TextEditorAdapterCallbacks<UITextFieldTextEditorAdapter<ViewType>>, textChangedObserver: @escaping TextChangedObserver) -> ViewType {
        let textField = TextFieldType(frame: CGRect.zero)
        let delegate = TextFieldDelegate(
            textField: textField,
            adapter: self,
            configuration: configuration,
            callbacks: callbacks,
            textChangedObserver: textChangedObserver
        )
        
        (textField as UITextField).delegate = delegate
        textField.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        objc_setAssociatedObject(textField, &ObjCTextFieldDelegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return textField
    }
    
    public func getTextForView(_ view: ViewType) -> String {
        return view.text ?? ""
    }
    
    public func setText(_ text: String, forView view: ViewType) {
        view.text = text
    }
}

private var ObjCTextFieldDelegateKey: UInt8 = 0

private final class TextFieldDelegate<TextFieldType: UITextField>: NSObject, UITextFieldDelegate {
    fileprivate typealias AdapterType = UITextFieldTextEditorAdapter<TextFieldType>
    fileprivate typealias TextChangedObserver = (AdapterType, TextFieldType) -> Void
    
    fileprivate let adapter: AdapterType
    fileprivate let configuration: TextEditorConfiguration
    fileprivate let callbacks: TextEditorAdapterCallbacks<AdapterType>
    fileprivate let textChangedObserver: TextChangedObserver
    
    init(textField: TextFieldType, adapter: AdapterType, configuration: TextEditorConfiguration, callbacks: TextEditorAdapterCallbacks<AdapterType>, textChangedObserver: @escaping TextChangedObserver) {
        self.adapter = adapter
        self.configuration = configuration
        self.callbacks = callbacks
        self.textChangedObserver = textChangedObserver
        
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(TextFieldDelegate.textFieldTextDidChange(_:)),
            name: NSNotification.Name.UITextFieldTextDidChange,
            object: textField
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: UITextFieldDelegate
    
    @objc fileprivate func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? TextFieldType else {
            fatalError("Expected text field of type \(TextFieldType.self)")
        }
        callbacks.textDidBeginEditing?(adapter, textField)

        if configuration.showAccessoryViewToolbar {
            appendToolbar(toTextField: textField)
        }
    }
    
    @objc fileprivate func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? TextFieldType else {
            fatalError("Expected text field of type \(TextFieldType.self)")
        }
        callbacks.textDidEndEditing?(adapter, textField)
        if !configuration.continuouslyUpdatesValue {
            textChangedObserver(adapter, textField)
        }
    }
    
    @objc fileprivate func textFieldTextDidChange(_ notification: Notification) {
        guard let textField = notification.object as? TextFieldType else {
            fatalError("Expected text field of type \(TextFieldType.self)")
        }
        callbacks.textDidChange?(adapter, textField)
        if configuration.continuouslyUpdatesValue {
            textChangedObserver(adapter, textField)
        }
    }
    
    fileprivate func notifyTextChangedObserverWithTextField(_ textField: UITextField) {
        textField.shouldIgnoreFormValueChanges = true
    }
    
    @objc fileprivate func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let maximumLength = configuration.maximumLength, let text = textField.text {
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= maximumLength
        } else {
            return true
        }
    }
    
    @objc fileprivate func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        defer {
            configuration.textEditorAction?(.returnKey)
        }
        switch configuration.returnKeyAction {
        case .none: return true
        case .activateNextResponder:
            if !(textField.nextFormResponder?.becomeFirstResponder() ?? false) {
                if configuration.shouldResignFirstResponderWhenFinished {
                    textField.resignFirstResponder()
                }
            }
            return false
        }
    }

    private func appendToolbar(toTextField textField: TextFieldType) {
        var callbacks = AccessoryViewToolbarCallbacks()
        callbacks.nextAction = { [weak self, weak textField] in
            textField?.nextFormResponder?.becomeFirstResponder()
            self?.configuration.textEditorAction?(.next)
        }
        callbacks.doneAction = { [weak self, weak textField] in
            textField?.resignFirstResponder()
            self?.configuration.textEditorAction?(.done)
        }
        let toolbar = AccessoryViewToolbar(frame: .zero)
        toolbar.sizeToFit()
        toolbar.callbacks = callbacks
        textField.inputAccessoryView = toolbar

        //Hide next button when nextFormResponder == nil.
        if textField.nextFormResponder == nil {
            toolbar.nextButtonItem.isEnabled = false
            toolbar.nextButtonItem.title = ""
        }
    }
}
