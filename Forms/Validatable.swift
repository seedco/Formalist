//
//  Validatable.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-05-31.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import ObjectiveC

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
    
    /**
     Validates an array of validatable objects. If one of the validations
     fails, the `completionHandler` is called with the failing validation
     result and the remaining objects are not validated.
     
     - parameter objects:           The objects to validate
     - parameter queue:             The queue to call the completion handler on
     - parameter completionHandler: The completion handler to call when
     validation completes (success or failure)
     */
    static func validate(objects: [Validatable], queue: dispatch_queue_t = dispatch_get_main_queue(), completionHandler: ValidationResult -> Void) {
        var remainingObjects = objects
        var validateNext: Void -> Void = {}
        validateNext = {
            dispatch_async(queue) {
                guard let nextObject = remainingObjects.first else {
                    completionHandler(.Valid)
                    return
                }
                remainingObjects.removeFirst()
                nextObject.validate { result in
                    switch result {
                    case .Valid:
                        validateNext()
                    case .Invalid, .Cancelled:
                        dispatch_async(queue) { completionHandler(result) }
                    }
                }
            }
        }
        validateNext()
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
    func validateAndStoreResult(queue queue: dispatch_queue_t, completionHandler: ValidationResult -> Void) {
        validate { result in
            self._validationResult = result
            completionHandler(result)
        }
    }
}
