//
//  GroupElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-01.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

public final class GroupElement: FormElement, FormResponder {
    /// Stores configuration parameters
    public struct Configuration {
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
        
        /// Describes how each element in the group is laid out
        public struct Layout {
            public enum Mode {
                /// Each element is fixed to a constant height
                case ConstantHeight(CGFloat)
                
                /// The intrinsic content size of each element is used
                case IntrinsicSize
            }
            
            /// The layout mode used to determine the height to display the
            /// element view at
            public let mode: Mode
            
            /// Edge insets to use for padding the element view
            public let edgeInsets: UIEdgeInsets
            
            public init(mode: Mode = .IntrinsicSize, edgeInsets: UIEdgeInsets = UIEdgeInsetsZero) {
                self.mode = mode
                self.edgeInsets = edgeInsets
            }
        }
        
        /// A block that creates separator views.
        ///
        /// `style` specifies the grouping style and `isBorder` specifies whether
        /// the separator is being drawn at the top or the bottom of the group.
        /// The default `separatorViewFactory` implementation uses the `isBorder`
        /// parameter to determine whether the separator should be drawn with
        /// an inset or not.
        public typealias SeparatorViewFactory = (style: Style, isBorder: Bool) -> UIView?
        
        /// The grouping style to use. See the documentation for the `Style`
        /// enum for more information.
        public let style: Style
        
        /// The block that creates separator views. See the documentation for
        /// the `SeparatorViewFactory` type for more information.
        public let separatorViewFactory: SeparatorViewFactory
        
        /// Describes how each element in the group is laid out
        public let layout: Layout
        
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
        
        public init(style: Style = .Plain, separatorViewFactory: SeparatorViewFactory = Configuration.defaultSeparatorViewFactory, layout: Layout = Layout()) {
            self.style = style
            self.separatorViewFactory = separatorViewFactory
            self.layout = layout
        }
        
        private func createSeparatorWithBorder(hasBorder: Bool) -> UIView? {
            return separatorViewFactory(style: style, isBorder: hasBorder)
        }
        
        private func arrangedSubviewForElementView(elementView: UIView) -> UIView {
            switch layout.mode {
            case .IntrinsicSize: break
            case let .ConstantHeight(height):
                let heightConstraint = NSLayoutConstraint(item: elementView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
                heightConstraint.active = true
            }
            
            if layout.edgeInsets == UIEdgeInsetsZero {
                return elementView
            } else {
                let containerView = UIView(frame: CGRectZero)
                if case let .Grouped(backgroundColor) = style {
                    containerView.backgroundColor = backgroundColor
                }
                containerView.addSubview(elementView)
                elementView.activateSuperviewHuggingConstraints(insets: layout.edgeInsets)
                return containerView
            }
        }
    }
    
    private let configuration: Configuration
    private let elements: [FormElement]
    
    /**
     Designated initializer
     
     - parameter configuration: The configuration parameters to use. See the
     documentation for the `Configuration` struct.
     - parameter elements:      The elements to group
     
     - returns: An initialized instance of the receiver
     */
    public init(configuration: Configuration = Configuration(), elements: [FormElement]) {
        self.configuration = configuration
        self.elements = elements
    }

    // MARK: FormElement
    
    public func render() -> UIView {
        var subviews = [UIView]()
        var responderViews = [UIView]()
        
        func addSeparator(isBorder isBorder: Bool) {
            if let separatorView = configuration.createSeparatorWithBorder(isBorder) {
                subviews.append(separatorView)
            }
        }
        
        func addChildElement(element: FormElement) -> Bool {
            let elementView = element.render()
            subviews.append(configuration.arrangedSubviewForElementView(elementView))

            if element is FormResponder {
                if let lastResponderView = responderViews.last {
                    lastResponderView._nextFormResponder = elementView
                }
                responderViews.append(elementView)
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
        
        return createContainerWithSubviews(subviews, responderViews: responderViews)
    }
    
    private func createContainerWithSubviews(subviews: [UIView], responderViews: [UIView]) -> UIView {
        let containerView =
            ContainerView(initialFormResponderView: responderViews.first)
        if case let .Grouped(backgroundColor) = configuration.style {
            containerView.backgroundColor = backgroundColor
        }
        responderViews.last?._nextFormResponder = containerView
        
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .Vertical
        containerView.addSubview(stackView)
        stackView.activateSuperviewHuggingConstraints()
        
        return containerView
    }
    
    private class ContainerView: UIView {
        private let initialFormResponderView: UIView?
        
        init(initialFormResponderView: UIView?) {
            self.initialFormResponderView = initialFormResponderView
            super.init(frame: CGRectZero)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private override func becomeFirstResponder() -> Bool {
            var responderView = nextFormResponder
            while let containerView = responderView as? ContainerView {
                responderView = containerView.initialFormResponderView
            }
            responderView?.becomeFirstResponder()
            return false
        }
    }
}
