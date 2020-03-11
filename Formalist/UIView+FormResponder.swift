//
//  UIView+FormResponder.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-02.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import ObjectiveC

private var ObjCNextFormResponderKey: UInt8 = 0

internal extension UIResponder {
    /// The next responder in the parent form that this view belongs to.
    ///
    /// This is useful for implementing tabbing behaviour between text
    /// fields, for example. Calling `nextFormResponder?.becomeFirstResponder()`
    /// from a form view will make the view resign first responder and make
    /// the next form view the first responder (if it exists).
    ///
    /// - Note: Most of the time you will want to use `resolvedNextFormResponder` when calling
    /// `becomeFirstResponder()`.
    ///
    /// - SeeAlso: resolvedNextFormResponder
    @objc var nextFormResponder: UIView? {
        get {
            if let box = objc_getAssociatedObject(self, &ObjCNextFormResponderKey) as? WeakBox<UIView> {
                return box.value
            } else {
                return nil
            }
        }
        set {
            let box: WeakBox<UIView>?
            if let responder = newValue {
                box = WeakBox(responder)
            } else {
                box = nil
            }
            objc_setAssociatedObject(self, &ObjCNextFormResponderKey, box, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The next `nextFormResponder` in this view's responder chain.
    ///
    /// This provides convenient access to the next form responder when the current view doesn't have
    /// a value provided but one of it's parents in the responder chain (eg. a superview) does have a
    /// `nextFormResponder`.
    var resolvedNextFormResponder: UIView? {
        var nextResponder: UIResponder? = self

        while let currentResponder = nextResponder {
            if let formResponder = currentResponder.nextFormResponder {
                return formResponder
            }

            nextResponder = currentResponder.next
        }

        return nil
    }
}
