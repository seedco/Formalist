//
//  EditableTextElement.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import Foundation

/// An element that displays an editable text field
public final class EditableTextElement<AdapterType: TextEditorAdapter>: FormElement, Validatable {
    public typealias ViewConfigurator = (AdapterType.ViewType) -> Void
    
    fileprivate let adapter: AdapterType
    fileprivate let value: FormValue<String>
    fileprivate let validationRules: [ValidationRule<String>]
    fileprivate let viewConfigurator: ViewConfigurator?
    fileprivate let configuration: TextEditorConfiguration
    /**
     Designated initializer
     
     - parameter adaptor:          The adapter used to interact with the
     underlying text view. Custom adapters can add support for editable text
     view types other than the built-in support for `UITextField`, `UITextView`,
     and `FloatLabel`
     - parameter value:            The string value to bind to the text view
     - parameter configuration:    Configuration options for the text view
     - parameter validationRules:  Rules used to validate the string value
     - parameter viewConfigurator: An optional block used to perform additional
     customization of the text view
     
     - returns: An initialized instance of the receiver
     */
    public init(value: FormValue<String>, configuration: TextEditorConfiguration = TextEditorConfiguration(), validationRules: [ValidationRule<String>] = [], viewConfigurator: ViewConfigurator? = nil) {
        self.value = value
        self.adapter = AdapterType(configuration: configuration)
        self.validationRules = validationRules
        self.viewConfigurator = viewConfigurator
        self.configuration = configuration
    }
    
    // MARK: FormElement
    
    public func render() -> UIView {
        let view = adapter.createViewWithCallbacks(TextEditorAdapterCallbacks()) { [weak self] (adapter, view) in
            guard let `self` = self else { return }

            let text: String = {
                let oldValue = self.value.value
                let newValue = adapter.getTextForView(view)
                if let formatter = self.configuration.formatter {
                    return formatter.from(
                        input: newValue,
                        previousInput: oldValue
                    )
                } else {
                    return newValue
                }
            }()
            view.shouldIgnoreFormValueChanges = true
            self.value.value = text
            view.shouldIgnoreFormValueChanges = false
            adapter.setText(text, forView: view)
        }
        let updateView: (String) -> Void = { [weak view, weak self] in
            guard let view = view, let adapter = self?.adapter else { return }
            if !view.shouldIgnoreFormValueChanges {
                adapter.setText($0, forView: view)
            }
        }
        updateView(value.value)
        let _ = value.addObserver(updateView)
        viewConfigurator?(view)
        return view
    }
    
    // MARK: Validatable
    
    public func validate(_ completionHandler: @escaping (ValidationResult) -> Void) {
        ValidationRule.validateRules(validationRules, forValue: value.value,  completionHandler: completionHandler)
    }
}
