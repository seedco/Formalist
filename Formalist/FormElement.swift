//
//  FormElement.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 3/4/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// The protocol that all form element classes must conform to
public class FormElement {
    /// Renders the contents of the form as a `UIView`. This process typically
    /// involves the following steps:
    ///     1. Create the view
    ///     2. Configure default options
    ///     3. Set up target-action or another callback mechanism to be notified
    ///        when the value changes and update the `FormValue` instance bound
    ///        to the element.
    ///     4. Allow custom configuration using a block that can be optionally
    ///        passed in to the element initializer
    open func render() -> UIView {
        fatalError("FormElement must be subclassed and subclasses must override render.")
    }
}
