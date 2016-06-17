//
//  Convenience.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

public func inset(insets: UIEdgeInsets, elements: [FormElement]) -> GroupElement {
    return GroupElement(configurator: {
        $0.layout.edgeInsets = insets
    }, elements: elements)
}

/**
 Creates an editable text element that renders a `UITextField`
 
 - parameter value:            The string value to bind to the text field
 - parameter configuration:    Configuration options for the text field
 - parameter validationRules:  Rules used to validate the string value
 - parameter viewConfigurator: An optional block used to perform additional
 customization of the text field.
 
 - returns: An initialized instance of the receiver
 */
public func textField(value value: FormValue<String>, configuration: TextEditorConfiguration = TextEditorConfiguration(), validationRules: [ValidationRule<String>] = [], viewConfigurator: (UITextField -> Void)? = nil) -> EditableTextElement<UITextFieldTextEditorAdapter> {
    return EditableTextElement<UITextFieldTextEditorAdapter>(value: value, configuration: configuration, validationRules: validationRules, viewConfigurator: viewConfigurator)
}

/**
 Creates an editable text element that renders a `UITextView`
 
 - parameter value:            The string value to bind to the text view
 - parameter configuration:    Configuration options for the text view
 - parameter validationRules:  Rules used to validate the string value
 - parameter viewConfigurator: An optional block used to perform additional
 customization of the text view.
 
 - returns: An initialized instance of the receiver
 */
public func textView(configuration configuration: TextEditorConfiguration = TextEditorConfiguration(returnKeyAction: .None), value: FormValue<String>, validationRules: [ValidationRule<String>] = [], viewConfigurator: (PlaceholderTextView -> Void)? = nil) -> EditableTextElement<UITextViewTextEditorAdapter> {
    return EditableTextElement<UITextViewTextEditorAdapter>(value: value, configuration: configuration, validationRules: validationRules, viewConfigurator: viewConfigurator)
}
