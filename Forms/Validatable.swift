//
//  Validatable.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-05-31.
//  Copyright © 2016 Seed.co. All rights reserved.
//

/// The protocol that is implemented by all form elements that
/// support validation of their values.
public protocol Validatable: AnyObject {
    func validate(completionHandler: ValidationResult -> Void)
}

public extension Validatable {
    /// The result of the last validation, or `nil` if the object has
    /// never been validated before.
    var validationResult: ValidationResult? {
        return _validationResult
    }
}

private var ObjCValidationResultKey: UInt8 = 0

private extension Validatable {
    // "All Swift classes, even non-NSObject-derived ones, are minimally ObjC-
    //  compatible enough to support associated objects"
    // https://devforums.apple.com/message/986325#986325
    var _validationResult: ValidationResult? {
        get {
            if let box = objc_getAssociatedObject(self, &ObjCValidationResultKey) as? Box<ValidationResult> {
                return box.value
            }
            return nil
        }
        set {
            let box: Box<ValidationResult>?
            if let validationResult = newValue {
                box = Box(validationResult)
            } else {
                box = nil
            }
            objc_setAssociatedObject(self, &ObjCValidationResultKey, box, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension Validatable {
    func validateAndStoreResult(completionHandler: ValidationResult -> Void) {
        validate { result in
            self._validationResult = result
            completionHandler(result)
        }
    }
}
