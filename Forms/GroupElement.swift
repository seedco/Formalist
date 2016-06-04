//
//  GroupElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-01.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit
import StackViewController

public final class GroupElement: FormElement {
    /// The style used to display the grouped elements
    public enum Style {
        /// Does not draw a background color behind the elements
        ///
        /// The default `separatorViewFactory` also does not create separators
        /// for this style, but separators can be added by setting a custom
        /// `separatorViewFactory`
        case Plain
        
        /// Draws a background color behind the elements, specified by
        /// `backgroundColor`
        ///
        /// The default `separatorViewFactory` creates instances of
        /// `SeparatorView` with a predefined default separator colors
        /// and separator thickness. These can be customized by specifying a
        /// custom `separatorViewFactory`
        case Grouped(backgroundColor: UIColor)
    }
    
    /// A block that creates separator views.
    ///
    /// `style` specifies the grouping style and `isBorder` specifies whether
    /// the separator is being drawn at the top or the bottom of the group.
    /// The default `separatorViewFactory` implementation uses the `isBorder`
    /// parameter to determine whether the separator should be drawn with
    /// an inset or not.
    public typealias SeparatorViewFactory = (style: Style, isBorder: Bool) -> UIView?
    
    private struct SeparatorDefaults {
        static let Inset: CGFloat = 15.0
        static let BorderColor = UIColor(red: 0.83, green: 0.84, blue: 0.85, alpha: 1.0)
        static let SeparatorColor = UIColor(white: 0.9, alpha: 1.0)
        static let Thickness: CGFloat = 1.0
    }
    
    private static let defaultSeparatorViewFactory: SeparatorViewFactory = { (style, isBorder) in
        guard case let .Grouped(backgroundColor) = style else { return nil }
        let separatorView = SeparatorView(axis: .Vertical)
        separatorView.backgroundColor = backgroundColor
        separatorView.separatorInset = isBorder ? 0 : SeparatorDefaults.Inset
        separatorView.separatorColor = isBorder ? SeparatorDefaults.SeparatorColor : SeparatorDefaults.BorderColor
        separatorView.separatorThickness = SeparatorDefaults.Thickness
        return separatorView
    }
    
    private let style: Style
    private let separatorViewFactory: SeparatorViewFactory
    private let elements: [FormElement]
    
    /**
     Designated initializer
     
     - parameter style:                The grouping style to use. See the
     documentation for the `Style` enum for more information.
     - parameter separatorViewFactory: The block that creates separator views.
     See the documentation for the `SeparatorViewFactory` type for more
     information.
     - parameter elements:             The elements to group
     
     - returns: An initialized instance of the receiver
     */
    public init(style: Style = .Plain, separatorViewFactory: SeparatorViewFactory = GroupElement.defaultSeparatorViewFactory, elements: [FormElement]) {
        self.style = style
        self.separatorViewFactory = separatorViewFactory
        self.elements = elements
    }
    
    // MARK: FormElement
    
    public func render() -> UIView {
        var subviews = [UIView]()
        var responderViews = [UIView]()
        
        func addSeparator(isBorder isBorder: Bool) {
            if let separatorView = separatorViewFactory(style: style, isBorder: isBorder) {
                subviews.append(separatorView)
            }
        }
        
        func addChildElement(element: FormElement) -> Bool {
            let view = element.render()
            if case let .Grouped(backgroundColor) = style {
                view.backgroundColor = backgroundColor
            }
            subviews.append(view)
            
            if element is FormResponder {
                if let lastResponderView = responderViews.last {
                    lastResponderView._nextFormResponder = view
                }
                responderViews.append(view)
            }
            
            if let validatable = element as? Validatable, validationResult = validatable.validationResult {
                if case let .Invalid(message) = validationResult {
                    // TODO: Add error view
                    return false
                } else {
                    return true
                }
            }
            return true
        }
        
        addSeparator(isBorder: true)
        for element in elements.dropLast() {
            let valid = addChildElement(element)
            addSeparator(isBorder: !valid)
        }
        if let lastElement = elements.last {
            addChildElement(lastElement)
            addSeparator(isBorder: true)
        }
        
        return createContainerWithSubviews(subviews)
    }
    
    private func createContainerWithSubviews(subviews: [UIView]) -> UIView {
        let containerView = UIView(frame: CGRectZero)
        if case let .Grouped(backgroundColor) = style {
            containerView.backgroundColor = backgroundColor
        }
        
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .Vertical
        
        containerView.addSubview(stackView)
        stackView.activateSuperviewHuggingConstraints()
        
        return containerView
    }
}
