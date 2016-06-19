//
//  Convenience.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

/**
 Creates a form element that displays a control to toggle a boolean value
 Convenience function for initializing a `BooleanElement`
 
 - parameter title:            The title to display to the toggle
 - parameter value:            The form value to bind to the toggle
 - parameter viewConfigurator: An optional closure that can configure the
 element view, including the title `UILabel` and toggle `UISwitch`
 
 - returns: A boolean element
 */
public func toggle(title title: String, value: FormValue<Bool>, viewConfigurator: BooleanElement.ViewConfigurator? = nil) -> BooleanElement {
    return BooleanElement(title: title, value: value, viewConfigurator: viewConfigurator)
}

/**
 Creates a form element that displays a segmented control
 Convenience function for initializing a `SegmentElement`
 
 - parameter title:            The title to display above the segmented control
 - parameter segments:         The segments to display in the segmented control
 - parameter selectedValue:    The value to bind to the value of the selected
 segment
 - parameter viewConfigurator: An optional closure for configuring the appearance
 of the view, including the title label and segmented control
 
 - returns: A segment element
 */
public func segments<ValueType: Equatable>(title title: String,
                                                 segments: [Segment<ValueType>],
                                                 selectedValue: FormValue<ValueType>,
                                                 viewConfigurator: SegmentElement<ValueType>.ViewConfigurator? = nil)
    -> SegmentElement<ValueType> {
    return SegmentElement(
        title: title,
        segments: segments,
        selectedValue: selectedValue,
        viewConfigurator: viewConfigurator
    )
}

/**
 Creates a form element that displays static text.
 Convenience function for initializing a `StaticTextElement`
 
 - parameter text:             The text to display
 - parameter viewConfigurator: An optional block used to configure the appearance
 of the view
 
 - returns: A static text form element
 */
public func staticText(text: String, viewConfigurator: StaticTextElement.ViewConfigurator? = nil) -> StaticTextElement {
    return StaticTextElement(text: text, viewConfigurator: viewConfigurator)
}

/**
 Creates a form element that displays a cell that invokes an action when tapped
 Convenience function for initializing a `SegueElement`
 
 - parameter icon:             An optional icon to display
 - parameter title:            The title to display
 - parameter viewConfigurator: An optional block used to configure the appearance
 of the view
 - parameter action:           The action to invoke when the view is tapped
 
 - returns: A segue element
 */
public func segue(icon icon: UIImage?,
                       title: String,
                       viewConfigurator: SegueElement.ViewConfigurator? = nil,
                       action: Void -> Void) -> SegueElement {
    return SegueElement(
        icon: icon,
        title: title,
        viewConfigurator: viewConfigurator,
        action: action
    )
}

/**
 Creates a form element that displays a fixed height spacer
 Convenience function for initializing a `SpacerElement`
 
 - parameter height:           The height of the spacer
 - parameter viewConfigurator: An optional block used to configure the
 appearance of the spacer view
 
 - returns: A spacer element
 */
public func spacer(height height: CGFloat, viewConfigurator: SpacerElement.ViewConfigurator? = nil) -> SpacerElement {
    return SpacerElement(height: height, viewConfigurator: viewConfigurator)
}

/**
 Creates a form element that wraps an existing view
 Convenience function for initializing a `ViewElement`
 
 - parameter value:            The value to bind to the element
 - parameter viewConfigurator: A block that creates and configures
 a view associated with the element
 
 - returns: A view element
 */
public func customView<ValueType: Equatable>(value value: FormValue<ValueType>, viewConfigurator: ViewElement<ValueType>.ViewConfigurator) -> ViewElement<ValueType> {
    return ViewElement(value: value, viewConfigurator: viewConfigurator)
}

/**
 Creates a form element that groups child elements
 Convenience function for initializing a `GroupElement`
 
 - parameter configuration: The configuration parameters to use. See the
 documentation for the `Configuration` struct.
 - parameter elements:      The elements to group
 
 - returns: A group element
 */
public func group(configuration configuration: GroupElement.Configuration = GroupElement.Configuration(), elements: [FormElement]) -> GroupElement {
    return GroupElement(configuration: configuration, elements: elements)
}

/**
 Creates a form element that groups child elements
 Convenience function for initializing a `GroupElement`
 
 - parameter configurator: Block used to set up configuration properties
 - parameter elements:     The elements to group
 
 - returns: A group element
 */
public func group(configurator configurator: (inout GroupElement.Configuration) -> Void, elements: [FormElement]) -> GroupElement {
    return GroupElement(configurator: configurator, elements: elements)
}

/**
 Creates a group element that insets the specified child elements
 
 - parameter insets:   The insets to apply to the child elements
 - parameter elements: The child elements to inset
 
 - returns: A group element
 */
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
 
 - returns: An editable text element
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
