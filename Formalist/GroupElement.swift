//
//  GroupElement.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-01.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

public final class GroupElement: FormElement, Validatable {
    /// Stores configuration parameters
    public struct Configuration {
        /// The style used to display the grouped elements
        public enum Style {
            /// Does not draw a background color behind the elements
            ///
            /// The default `separatorViewFactory` also does not create separators
            /// for this style, but separators can be added by setting a custom
            /// `separatorViewFactory`
            case plain
            
            /// Draws a background color behind the elements, specified by
            /// `backgroundColor`
            ///
            /// The default `separatorViewFactory` creates instances of
            /// `SeparatorView` with a predefined default separator colors
            /// and separator thickness. These can be customized by specifying a
            /// custom `separatorViewFactory`
            case grouped(backgroundColor: UIColor)
        }
        
        /// Describes how each element in the group is laid out
        public struct Layout {
            public enum Mode {
                /// Each element is fixed to a constant height
                case constantHeight(CGFloat)
                
                /// The intrinsic content size of each element is used
                case intrinsicSize
            }
            
            /// The layout mode used to determine the height to display the
            /// element view at
            public var mode: Mode
            
            /// Edge insets to use for padding the element view
            public var edgeInsets: UIEdgeInsets
            
            public init(mode: Mode = .intrinsicSize, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) {
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
        public typealias SeparatorViewFactory = (_ style: Style, _ isBorder: Bool) -> UIView?
        
        fileprivate struct SeparatorDefaults {
            static let Inset: CGFloat = 15.0
            static let SeparatorColor = UIColor(white: 0.78, alpha: 1.0)
            static let Thickness: CGFloat = 1.0
        }
        
        fileprivate struct ValidationErrorViewDefaults {
            static let Height: CGFloat = 30.0
        }
        
        /// A block that creates a view to display validation errors
        ///
        /// `message` specifies the message text to display in the view. The default
        /// `validationErrorViewFactory` implementation provides a simple view
        /// that uses a label to display the message text.
        public typealias ValidationErrorViewFactory = (_ message: String) -> UIView?
        
        /// The grouping style to use. See the documentation for the `Style`
        /// enum for more information.
        public var style = Style.plain
        
        /// The block that creates separator views. See the documentation for
        /// the `SeparatorViewFactory` type for more information.
        public var separatorViewFactory: SeparatorViewFactory = { (style, isBorder) in
            guard case let .grouped(backgroundColor) = style else { return nil }
            let separatorView = SeparatorView(axis: .horizontal)
            separatorView.backgroundColor = backgroundColor
            separatorView.separatorInset = isBorder ? 0 : SeparatorDefaults.Inset
            separatorView.separatorColor = SeparatorDefaults.SeparatorColor
            separatorView.separatorThickness = SeparatorDefaults.Thickness
            return separatorView
        }
        
        /// The block that creates validation error views. See the documentation
        /// for the `ValidationErrorViewFactory` type for more information.
        public var validationErrorViewFactory: ValidationErrorViewFactory = { message in
            let errorView = ValidationErrorView(frame: CGRect.zero)
            errorView.label.text = message
            let heightConstraint = NSLayoutConstraint(
                item: errorView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: ValidationErrorViewDefaults.Height
            )
            heightConstraint.isActive = true
            return errorView
        }
        
        /// Describes how each element in the group is laid out
        public var layout = Layout()
        
        public init() {}
        
        fileprivate func createSeparatorWithBorder(_ hasBorder: Bool) -> UIView? {
            return separatorViewFactory(style, hasBorder)
        }
        
        fileprivate func createValidationErrorViewWithMessage(_ message: String) -> UIView? {
            return validationErrorViewFactory(message)
        }
        
        fileprivate func arrangedSubviewForElementView(_ elementView: UIView) -> UIView {
            switch layout.mode {
            case .intrinsicSize: break
            case let .constantHeight(height):
                let heightConstraint = NSLayoutConstraint(item: elementView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
                heightConstraint.isActive = true
            }
            
            if layout.edgeInsets == UIEdgeInsets.zero {
                return elementView
            } else {
                let containerView = UIView(frame: CGRect.zero)
                if case let .grouped(backgroundColor) = style {
                    containerView.backgroundColor = backgroundColor
                }
                containerView.addSubview(elementView)
                let _ = elementView.activateSuperviewHuggingConstraints(insets: layout.edgeInsets)
                return containerView
            }
        }
    }
    
    fileprivate let configuration: Configuration

    /**
     The elements that make up the group.
    */
    public let elements: [FormElement]
    
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
    
    /**
     Convenience initializer for configuring the element using a block.
     
     - parameter configurator: Block used to set up configuration properties
     - parameter elements:     The elements to group
     
     - returns: An initialized instance of the receiver
     */
    public convenience init(configurator: (inout Configuration) -> Void, elements: [FormElement]) {
        var configuration = Configuration()
        configurator(&configuration)
        self.init(configuration: configuration, elements: elements)
    }

    // MARK: FormElement
    
    public func render() -> UIView {
        var subviews = [UIView]()
        var responderViews = [UIView]()
        
        func addSeparator(isBorder: Bool) {
            if let separatorView = configuration.createSeparatorWithBorder(isBorder) {
                subviews.append(separatorView)
            }
        }
        
        func addChildElement(_ element: FormElement) -> Bool {
            let elementView = element.render()
            subviews.append(configuration.arrangedSubviewForElementView(elementView))

            if elementView.canBecomeFirstResponder {
                if let lastResponderView = responderViews.last {
                    lastResponderView.nextFormResponder = elementView
                }
                responderViews.append(elementView)
            }
            
            if !(element is GroupElement),
               let validationResult = (element as? Validatable)?.validationResult,
               case let .invalid(message) = validationResult,
               let errorView = configuration.createValidationErrorViewWithMessage(message) {
                
                addSeparator(isBorder: true)
                subviews.append(errorView)
                return false
            }
            
            return true
        }
        
        addSeparator(isBorder: true)
        for element in elements.dropLast() {
            let showingErrorView = addChildElement(element)
            addSeparator(isBorder: !showingErrorView)
        }
        if let lastElement = elements.last {
            let _ = addChildElement(lastElement)
            addSeparator(isBorder: true)
        }
        
        return createContainerWithSubviews(subviews, responderViews: responderViews)
    }
    
    fileprivate func createContainerWithSubviews(_ subviews: [UIView], responderViews: [UIView]) -> UIView {
        let containerView =
            ContainerView(initialFormResponderView: responderViews.first)
        if case let .grouped(backgroundColor) = configuration.style {
            containerView.backgroundColor = backgroundColor
        }
        
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .vertical
        containerView.addSubview(stackView)
        let _ = stackView.activateSuperviewHuggingConstraints()
        
        return containerView
    }
    
    // MARK: Validatable
    
    public func validate(_ completionHandler: @escaping (ValidationResult) -> Void) {
        let validatables = elements.flatMap { $0 as? Validatable }
        validateObjects(validatables, completionHandler: completionHandler)
    }
    
    // MARK: ContainerView
    
    fileprivate class ContainerView: UIView {
        fileprivate let initialFormResponderView: UIView?
        
        init(initialFormResponderView: UIView?) {
            self.initialFormResponderView = initialFormResponderView
            super.init(frame: CGRect.zero)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        fileprivate override var canBecomeFirstResponder : Bool {
            return true
        }
        
        fileprivate override func becomeFirstResponder() -> Bool {
            var responderView = nextFormResponder
            while let containerView = responderView as? ContainerView {
                responderView = containerView.initialFormResponderView
            }
            responderView?.becomeFirstResponder()
            return false
        }
    }
}
