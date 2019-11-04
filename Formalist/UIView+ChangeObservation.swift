//
//  UIView+ChangeObservation.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-30.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

private var ObjCShouldIgnoreFormValueChangesKey: UInt8 = 0

public extension UIView {
    /// This flag is set inside `FormElement` implementations in order to break
    /// a potential infinite loop when `FormValue.value` is set while there is
    /// an observer on that value that updates the value on the view.
    var shouldIgnoreFormValueChanges: Bool {
        get {
            if let box = objc_getAssociatedObject(self, &ObjCShouldIgnoreFormValueChangesKey) as? Box<Bool> {
                return box.value
            } else {
                return false
            }
        }
        set {
            objc_setAssociatedObject(self, &ObjCShouldIgnoreFormValueChangesKey, Box(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
