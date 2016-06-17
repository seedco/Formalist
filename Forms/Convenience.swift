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
 
 - returns: An editable text element
 */
public func textField(value value: FormValue<String>,
                            configuration: TextEditorConfiguration = TextEditorConfiguration(),
                            validationRules: [ValidationRule<String>] = [],
                            viewConfigurator: (UITextField -> Void)? = nil)
    -> EditableTextElement<UITextFieldTextEditorAdapter> {
    return EditableTextElement(
        value: value,
        configuration: configuration,
        validationRules: validationRules,
        viewConfigurator: viewConfigurator
    )
}

/**
 Creates an editable text element that renders a `UITextView`
 
 - parameter value:            The string value to bind to the text view
 - parameter configuration:    Configuration options for the text view
 - parameter validationRules:  Rules used to validate the string value
 - parameter viewConfigurator: An optional block used to perform additional
 customization of the text view.
 
 - returns: An editable text element
 */
public func textView(value value: FormValue<String>,
                           configuration: TextEditorConfiguration = TextEditorConfiguration(returnKeyAction: .None),
                           validationRules: [ValidationRule<String>] = [],
                           viewConfigurator: (PlaceholderTextView -> Void)? = nil)
    -> EditableTextElement<UITextViewTextEditorAdapter> {
    return EditableTextElement(
        value: value,
        configuration: configuration,
        validationRules: validationRules,
        viewConfigurator: viewConfigurator
    )
}

/**
 Creates a "float label" (http://bradfrost.com/blog/post/float-label-pattern/)
 that uses an adapter typed by `InnerAdapterType` to render the editor view.
 
 - parameter name:             The field name to display on the float label
 - parameter configuration:    Configuration options for the text field
 - parameter validationRules:  Rules used to validate the string value
 - parameter viewConfigurator: An optional block used to perform additional
 customization of the float label
 
 - returns: An editable text elemen
 */
public func floatLabel
    <InnerAdapterType: TextEditorAdapter where InnerAdapterType.ViewType: FloatLabelTextEntryView>
    (name name: String,
          value: FormValue<String>,
          configuration: TextEditorConfiguration = TextEditorConfiguration(),
          validationRules: [ValidationRule<String>] = [],
          viewConfigurator: (FloatLabel<InnerAdapterType> -> Void)? = nil)
    -> EditableTextElement<FloatLabelTextEditorAdapter<InnerAdapterType>> {
    return EditableTextElement(value: value,
                               configuration: configuration,
                               validationRules: validationRules) {
        $0.setFieldName(name)
        viewConfigurator?($0)
        $0.recomputeMinimumHeight()
    }
}

/**
 Creates a "float label" (http://bradfrost.com/blog/post/float-label-pattern/)
 that uses a `UITextField` as its editor view for a single editable line of text.
 
 - parameter name:             The field name to display on the float label
 - parameter configuration:    Configuration options for the text field
 - parameter validationRules:  Rules used to validate the string value
 - parameter viewConfigurator: An optional block used to perform additional
 customization of the float label
 
 - returns: An editable text elemen
 */
public func singleLineFloatLabel(name name: String,
                                      value: FormValue<String>,
                                      configuration: TextEditorConfiguration = TextEditorConfiguration(),
                                      validationRules: [ValidationRule<String>] = [],
                                      viewConfigurator: (FloatLabel<UITextFieldTextEditorAdapter> -> Void)? = nil)
    -> EditableTextElement<FloatLabelTextEditorAdapter<UITextFieldTextEditorAdapter>> {
    return floatLabel(
        name: name,
        value: value,
        configuration: configuration,
        validationRules: validationRules,
        viewConfigurator: viewConfigurator
    )
}

/**
 Creates a "float label" (http://bradfrost.com/blog/post/float-label-pattern/)
 that uses a `UITextView` as its editor view for multiple editable lines
 of text
 
 - parameter name:             The field name to display on the float label
 - parameter configuration:    Configuration options for the text field
 - parameter validationRules:  Rules used to validate the string value
 - parameter viewConfigurator: An optional block used to perform additional
 customization of the float label
 
 - returns: An editable text elemen
 */
public func multiLineFloatLabel(name name: String,
                                     value: FormValue<String>,
                                     configuration: TextEditorConfiguration = TextEditorConfiguration(returnKeyAction: .None),
                                     validationRules: [ValidationRule<String>] = [],
                                     viewConfigurator: (FloatLabel<UITextViewTextEditorAdapter> -> Void)? = nil)
    -> EditableTextElement<FloatLabelTextEditorAdapter<UITextViewTextEditorAdapter>> {
    return floatLabel(
        name: name,
        value: value,
        configuration: configuration,
        validationRules: validationRules,
        viewConfigurator: viewConfigurator
    )
}
