//
//  FormViewController.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-03-09.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

/// A view controller that displays and manages a set of form elements
open class FormViewController: UIViewController {
    fileprivate let rootElement: FormElement
    fileprivate lazy var autoscrollView = AutoScrollView(frame: CGRect.zero)
    
    // MARK: Lifecycle
    
    /**
     Designated initializer
     
     - parameter rootElement: The root element of the form. This is typically
     an instance of `GroupElement`.
     
     - returns: An initialized instance of the receiver
     */
    public init(rootElement: FormElement) {
        self.rootElement = rootElement
        super.init(nibName: nil, bundle: nil)
    }

    public var isScrollEnabled: Bool {
        set { autoscrollView.isScrollEnabled = newValue }
        get { return autoscrollView.isScrollEnabled }
    }

    /**
     Convenience initializer for initializing using an array of elements,
     which automatically creates a `GroupElement` with the default
     configuration as the root element (parent of the specified elements)
     
     - parameter elements: Form elements
     
     - returns: An initialized instance of the receiver
     */
    public convenience init(elements: [FormElement]) {
        self.init(rootElement: GroupElement(elements: elements))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        view = autoscrollView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }
    
    // MARK: API
    
    /// Reloads the view by re-rendering the entire tree of form elements
    open func reload() {
        let rootElementView = rootElement.render()
        rootElementView.translatesAutoresizingMaskIntoConstraints = false
        
        autoscrollView.contentView = rootElementView
        let widthConstraint = NSLayoutConstraint(item: autoscrollView, attribute: .width, relatedBy: .equal, toItem: rootElementView, attribute: .width, multiplier: 1.0, constant: 0.0)
        widthConstraint.isActive = true
    }
    
    /**
     Validates the tree of form elements asynchronously and calls the
     specified completion handler with the validation result. If a validation
     error occurs, the validation will stop immediately with the element
     causing the error and the completion handler will be called.
     
     - parameter completionHandler: The completion handler to call when
     validation succeeds, fails, or is cancelled.
     */
    open func validate(_ completionHandler: @escaping (ValidationResult) -> Void) {
        if let validatableElement = rootElement as? Validatable {
            validatableElement.validateAndStoreResult { result in
                self.reload()
                completionHandler(result)
            }
        } else {
            completionHandler(.valid)
        }
    }
}
