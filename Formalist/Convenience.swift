//
//  Convenience.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-07.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

/**
 Creates a form element that displays a control to toggle a boolean value
 Convenience function for initializing a `BooleanElement`
 
 - parameter title:            The title to display to the toggle
 - parameter value:            The form value to bind to the toggle
 - parameter icon:             An optional image to add beside the toggle
 - parameter viewConfigurator: An optional closure that can configure the
 element view, including the title `UILabel` and toggle `UISwitch`
 
 - returns: A boolean element
 */
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func toggle(title: String, value: FormValue<Bool>, icon: UIImage? = nil, viewConfigurator: BooleanElement.ViewConfigurator? = nil) -> BooleanElement {
    return BooleanElement(title: title, value: value, icon: icon, viewConfigurator: viewConfigurator)
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
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func segments<ValueType>(title: String,
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
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func staticText(_ text: String, viewConfigurator: StaticTextElement.ViewConfigurator? = nil) -> StaticTextElement {
    return StaticTextElement(text: text, viewConfigurator: viewConfigurator)
}

/**
 Creates a form element that displays static text.
 Convenience function for initializing a `StaticTextElement`
 
 - parameter value:            The text value to bind to the label
 - parameter viewConfigurator: An optional block used to configure the appearance
 of the view
 
 - returns: A static text form element
 */
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func staticText(_ value: FormValue<String>, viewConfigurator: StaticTextElement.ViewConfigurator? = nil) -> StaticTextElement {
    return StaticTextElement(value: value, viewConfigurator: viewConfigurator)
}

/**
 Creates a form element that displays a cell that invokes an action when tapped
 Convenience function for initializing a `SegueElement`
 
 - parameter icon:             An optional icon to display
 - parameter title:            The title to display
 - parameter accessoryIcon:        An optional icon to display in the accessory view
 - parameter viewConfigurator: An optional block used to configure the appearance
 of the view
 - parameter action:           The action to invoke when the view is tapped
 
 - returns: A segue element
 */
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func segue(
    icon: UIImage?,
    title: String,
    accessoryIcon: UIImage? = nil,
    viewConfigurator: SegueElement.ViewConfigurator? = nil,
    action: @escaping () -> Void
) -> SegueElement {
    return SegueElement(
        icon: icon,
        title: title,
        accessoryIcon: accessoryIcon,
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
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func spacer(height: CGFloat, viewConfigurator: SpacerElement.ViewConfigurator? = nil) -> SpacerElement {
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
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func customView<ValueType>(
  value: FormValue<ValueType>,
  viewConfigurator: @escaping ViewElement<ValueType>.ViewConfigurator
) -> ViewElement<ValueType> {
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
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func group(configuration: GroupElement.Configuration = GroupElement.Configuration(), elements: [FormElement]) -> GroupElement {
    return GroupElement(configuration: configuration, elements: elements)
}

/**
 Creates a form element that groups child elements
 Convenience function for initializing a `GroupElement`
 
 - parameter configurator: Block used to set up configuration properties
 - parameter elements:     The elements to group
 
 - returns: A group element
 */
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func group(configurator: (inout GroupElement.Configuration) -> Void, elements: [FormElement]) -> GroupElement {
    return GroupElement(configurator: configurator, elements: elements)
}

/**
 Creates a group element that insets the specified child elements
 
 - parameter insets:   The insets to apply to the child elements
 - parameter elements: The child elements to inset
 
 - returns: A group element
 */
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func inset(_ insets: UIEdgeInsets, elements: [FormElement]) -> GroupElement {
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
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func textField(value: FormValue<String>,
                            configuration: TextEditorConfiguration = TextEditorConfiguration(),
                            validationRules: [ValidationRule<String>] = [],
                            viewConfigurator: ((UITextField) -> Void)? = nil)
    -> EditableTextElement<UITextFieldTextEditorAdapter<UITextField>> {
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
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func textView(value: FormValue<String>,
                           configuration: TextEditorConfiguration = TextEditorConfiguration(returnKeyAction: .none),
                           validationRules: [ValidationRule<String>] = [],
                           viewConfigurator: ((PlaceholderTextView) -> Void)? = nil)
    -> EditableTextElement<UITextViewTextEditorAdapter<PlaceholderTextView>> {
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
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func floatLabel
    <InnerAdapterType>
    (name: String,
          value: FormValue<String>,
          configuration: TextEditorConfiguration = TextEditorConfiguration(),
          validationRules: [ValidationRule<String>] = [],
          viewConfigurator: ((FloatLabel<InnerAdapterType>) -> Void)? = nil)
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
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func singleLineFloatLabel(name: String,
                                      value: FormValue<String>,
                                      configuration: TextEditorConfiguration = TextEditorConfiguration(),
                                      validationRules: [ValidationRule<String>] = [],
                                      viewConfigurator: ((FloatLabel<UITextFieldTextEditorAdapter<FloatLabelTextField>>) -> Void)? = nil)
    -> EditableTextElement<FloatLabelTextEditorAdapter<UITextFieldTextEditorAdapter<FloatLabelTextField>>> {
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
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func multiLineFloatLabel(name: String,
                                     value: FormValue<String>,
                                     configuration: TextEditorConfiguration = TextEditorConfiguration(returnKeyAction: .none),
                                     validationRules: [ValidationRule<String>] = [],
                                     viewConfigurator: ((FloatLabel<UITextViewTextEditorAdapter<PlaceholderTextView>>) -> Void)? = nil)
    -> EditableTextElement<FloatLabelTextEditorAdapter<UITextViewTextEditorAdapter<PlaceholderTextView>>> {
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
 that uses a `UIPickerView` as its editor view
 
 - parameter name:             The field name to display on the float label
 - parameter value:            The string value to bind to the text view
 - parameter items:            The items to display in the picker view
 - parameter configuration:    Configuration options for the text field
 - parameter validationRules:  Rules used to validate the string value
 - parameter viewConfigurator: An optional block used to perform additional
 customization of the float label
 
 - returns: An editable text element
 */
@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func pickerField<ValueType>(name: String, value: FormValue<ValueType>, items: [PickerValue<ValueType>],
                                configuration: TextEditorConfiguration = TextEditorConfiguration(),
                                validationRules: [ValidationRule<String>] = [],
                                viewConfigurator: ((FloatLabel<UITextFieldTextEditorAdapter<PickerField<ValueType>>>) -> Void)? = nil)
    -> EditableTextElement<FloatLabelTextEditorAdapter<UITextFieldTextEditorAdapter<PickerField<ValueType>>>> {
        let valueString = FormValue("")
        return floatLabel(name: name,
                          value: valueString,
                          configuration: configuration,
                          validationRules: validationRules) {
                            $0.textEntryView.items = items
                            let textEntryView = $0.textEntryView
                            textEntryView?.didSelectPickerValue = { pickerValue in
                                valueString.value = pickerValue.title
                                value.value = pickerValue.value
                            }
                            textEntryView?.items = items
                            textEntryView?.selectValue(value.value)
                            $0.adapterCallbacks?.textDidBeginEditing = { adapterType, viewType in
                                viewType.updateSelectedValue()
                            }
                            $0.adapterCallbacks?.textDidEndEditing = { adapterType, viewType in
                                viewType.updateSelectedValue()
                            }
                            viewConfigurator?($0)
        }
}

@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func infoField(title: NSMutableAttributedString, subTitle: NSMutableAttributedString, viewConfigurator: ((UILabel, UILabel) -> Void)? = nil) -> InfoFieldElement {
    return InfoFieldElement(title: title, subTitle: subTitle, viewConfigurator: viewConfigurator)
}

@available(*, deprecated, message: "The free functions have been deprecated. Use the static functions on FormElement instead.")
public func divider(color: UIColor = .black, height: CGFloat = 1, viewConfigurator: ((UIView) -> Void)? = nil) -> DividerElement {
    return DividerElement(color: color, height: height, viewConfigurator:  viewConfigurator)
}
