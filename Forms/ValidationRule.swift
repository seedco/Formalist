//
//  ValidationRule.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-03-10.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import Foundation

/// The result from validating a form value
public enum ValidationResult: Equatable {
    /// The value is valid
    case Valid
    
    /// The value is invalid for a reason specified by `message`
    case Invalid(message: String)
    
    /// The user cancelled the validation action. For example, this can occur
    /// if a validator presents a user interface to accept a necessary change
    /// to the form value that the user rejects.
    case Cancelled
}

public func ==(lhs: ValidationResult, rhs: ValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.Valid, .Valid), (.Cancelled, .Cancelled):
        return true
    case let (.Invalid(lhsMessage), .Invalid(rhsMessage)):
        return lhsMessage == rhsMessage
    default:
        return false
    }
}

private let EmailRegex: NSRegularExpression = {
    // Same regular expression used by Mail.app
    // From: http://stackoverflow.com/a/8863823
    let pattern = "^[[:alnum:]!#$%&'*+/=?^_`{|}~-]+((\\.?)[[:alnum:]!#$%&'*+/=?^_`{|}~-]+)*@[[:alnum:]-]+(\\.[[:alnum:]-]+)*(\\.[[:alpha:]]+)+$"
    return try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
}()

/// A validation rule for a value of type `ValueType`. This type is used to
/// wrap the validator because typealiases do not currently support
/// generics.
public struct ValidationRule<ValueType> {
    /// A string validation rule to check for the existence of
    /// required value
    public static var required: ValidationRule<String> {
        return ValidationRule<String> { str, completion in
            if str.isEmpty {
                completion(.Invalid(message: NSLocalizedString("This field is required", comment: "Required field error message")))
            } else {
                completion(.Valid)
            }
        }
    }
    
    /// A string validation rule to check whether the string is
    /// a valid email address
    public static var email: ValidationRule<String> {
        return regex(EmailRegex, failureMessage: NSLocalizedString("The email address is invalid", comment: "Invalid email error message"))
    }

    /**
     A validation rule that uses a regular expression to verify the
     validity of a string
     
     - parameter regex:          Regex used to find matches in the string
     - parameter failureMessage: The failure message to invoke the completion
     handler with if the validation fails.
     
     - returns: The validation rule
     */
    public static func regex(regex: NSRegularExpression, matchingOptions: NSMatchingOptions = .Anchored, failureMessage: String) -> ValidationRule<String> {
        return ValidationRule<String> { str, completion in
            guard !str.isEmpty else {
                completion(.Valid)
                return
            }
            
            if regex.firstMatchInString(str, options: matchingOptions, range: NSMakeRange(0, str.characters.count)) == nil {
                completion(.Invalid(message: failureMessage))
            } else {
                completion(.Valid)
            }
        }
    }
    
    /**
     A validation rule that verifies that a string only contains characters
     from a specified character set.
     
     - parameter characterSet: The whitelist character set. If the string
     contains any characters that are not in this set, the validation will
     fail.
     
     - returns: The validation rule
     */
    public static func characterSet(characterSet: NSCharacterSet) -> ValidationRule<String> {
        return ValidationRule<String> { str, completion in
            if let range = str.rangeOfCharacterFromSet(characterSet.invertedSet) {
                let errorFormat = NSLocalizedString("\"%@\" is not an allowed character", comment: "Invalid character error message")
                let message = String(format: errorFormat, str.substringWithRange(range))
                completion(.Invalid(message: message))
            } else {
                completion(.Valid)
            }
        }
    }
    
    /**
     A validation rule that checks to make sure that a string length does 
     not exceed a specified maximum length.
     
     - parameter length: The maximum length of the string
     
     - returns: The validation rule
     */
    public static func maximumLength(length: Int) -> ValidationRule<String> {
        return ValidationRule<String> { str, completion in
            if str.characters.count <= length {
                completion(.Valid)
            } else {
                let errorFormat = NSLocalizedString("Cannot exceed %d characters", comment: "Maximum length error message")
                completion(.Invalid(message: String(format: errorFormat, length)))
            }
        }
    }
    
    /**
     A validation rule that checks to make sure that a string length is
     at least a specified minimum length.
     
     - parameter length: The minimum length of the string
     
     - returns: The validation rule
     */
    public static func minimumLength(length: Int) -> ValidationRule<String> {
        return ValidationRule<String> { str, completion in
            if str.characters.count >= length {
                completion(.Valid)
            } else {
                let errorFormat = NSLocalizedString("Must be at least %d characters long", comment: "Minimum length error message")
                completion(.Invalid(message: String(format: errorFormat, length)))
            }
        }
    }
    
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
