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

internal extension UIView {
    var _nextFormResponder: UIView? {
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
}

public extension UIView {
    /// The next responder in the parent form that this view belongs to.
    ///
    /// This is useful for implementing tabbing behaviour between text
    /// fields, for example. Calling `nextFormResponder?.becomeFirstResponder()`
    /// from a form view will make the view resign first responder and make
    /// the next form view the first responder (if it exists).
    var nextFormResponder: UIView? {
        return _nextFormResponder
    }
}
