//
//  ValidationRule.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-03-10.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import Foundation

/// The result from validating a form value
public enum ValidationResult {
    /// The value is valid
    case Valid
    
    /// The value is invalid for a reason specified by `message`
    case Invalid(message: String)
    
    /// The user cancelled the validation action. For example, this can occur
    /// if a validator presents a user interface to accept a necessary change
    /// to the form value that the user rejects.
    case Cancelled
}

/// A validation rule for a value of type `ValueType`. This type is used to
/// wrap the validator because typealiases do not currently support
/// generics.
public struct ValidationRule<ValueType> {
    /// A validator for `ValueType`. The first parameter is the value to be
    /// validated, and the second parameter is a closure that the validator should
    /// call upon completion with the result of the validation.
    public typealias Validator = (ValueType, (ValidationResult -> Void)) -> Void
    
    private let validator: Validator
    
    /**
     Designated initializer
     
     - parameter validator: The validator to wrap
     
     - returns: An initialized instance of the receiver
     */
    public init(_ validator: Validator) {
        self.validator = validator
    }
    
    /**
     Invokes the validator on a value.
     
     - parameter value:             The value to validate
     - parameter completionHandler: A completion handler that is called once
     the validation completes asynchronously
     */
    public func validate(value: ValueType, completionHandler: ValidationResult -> Void) {
        validator(value, completionHandler)
    }
    
    /**
     Validates a single value using multiple rules. The rules are validated
     in serial order. If one of the rule validations fails, the `completionHandler`
     is called immediately with the failing validation result and the remaining
     rules are not evaluated.
     
     - parameter rules:             The rules to use for validation
     - parameter value:             The value to validate
     - parameter queue:             The queue to execute the completion handler on
     - parameter completionHandler: The completion handler to be called when
     validation ends (either by successfully validating all the rules, or
     encountering a failure or cancellation on one of the rules)
     */
    public static func validateRules(rules: [ValidationRule], forValue value: ValueType, queue: dispatch_queue_t = dispatch_get_main_queue(), completionHandler: ValidationResult -> Void) {
        var remainingRules = rules
        var validateNext: Void -> Void = {}
        validateNext = {
            dispatch_async(queue) {
                guard let nextRule = remainingRules.first else {
                    completionHandler(.Valid)
                    return
                }
                remainingRules.removeFirst()
                nextRule.validate(value) { result in
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
