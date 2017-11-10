//
//  ValidationRule.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-03-10.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import Foundation

/// The result from validating a form value
public enum ValidationResult: Equatable {
    /// The value is valid
    case valid

    /// The value is invalid for a reason specified by `message`
    case invalid(message: String)

    /// The user cancelled the validation action. For example, this can occur
    /// if a validator presents a user interface to accept a necessary change
    /// to the form value that the user rejects.
    case cancelled
}

public func ==(lhs: ValidationResult, rhs: ValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.valid, .valid), (.cancelled, .cancelled):
        return true
    case let (.invalid(lhsMessage), .invalid(rhsMessage)):
        return lhsMessage == rhsMessage
    default:
        return false
    }
}

private let EmailRegex: NSRegularExpression = {
    // Same regular expression used by Mail.app
    // From: http://stackoverflow.com/a/8863823
    let pattern = "^[[:alnum:]!#$%&'*+/=?^_`{|}~-]+((\\.?)[[:alnum:]!#$%&'*+/=?^_`{|}~-]+)*@[[:alnum:]-]+(\\.[[:alnum:]-]+)*(\\.[[:alpha:]]+)+$"
    return try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
}()

extension ValidationRule: Equatable {}

public func ==<T>(lhs: ValidationRule<T>, rhs: ValidationRule<T>) -> Bool {
    return lhs.identifier == rhs.identifier
}

/// A validation rule for a value of type `ValueType`. This type is used to
/// wrap the validator because typealiases do not currently support
/// generics.
public struct ValidationRule<ValueType> {
    /// A string validation rule to check for the existence of
    /// required value

    public let identifier: String

    public static var required: ValidationRule<String> {
        return ValidationRule<String> ({ str, completion in
            if str.isEmpty {
                completion(.invalid(message: NSLocalizedString("This field is required", comment: "Required field error message")))
            } else {
                completion(.valid)
            }
        }, identifier: "required")
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
    public static func regex(_ regex: NSRegularExpression, matchingOptions: NSRegularExpression.MatchingOptions = .anchored, failureMessage: String) -> ValidationRule<String> {
        return ValidationRule<String> ({ str, completion in
            guard !str.isEmpty else {
                completion(.valid)
                return
            }

            if regex.firstMatch(in: str, options: matchingOptions, range: NSMakeRange(0, str.count)) == nil {
                completion(.invalid(message: failureMessage))
            } else {
                completion(.valid)
            }
        }, identifier: regex.pattern)
    }

    /**
     A validation rule that verifies that a string only contains characters
     from a specified character set.

     - parameter characterSet: The whitelist character set. If the string
     contains any characters that are not in this set, the validation will
     fail.

     - returns: The validation rule
     */
    public static func characterSet(_ characterSet: CharacterSet) -> ValidationRule<String> {
        return ValidationRule<String> ({ str, completion in
            if let range = str.rangeOfCharacter(from: characterSet.inverted) {
                let errorFormat = NSLocalizedString("\"%@\" is not an allowed character", comment: "Invalid character error message")
                let message = String(format: errorFormat, String(str[range]))
                completion(.invalid(message: message))
            } else {
                completion(.valid)
            }
        }, identifier: "characterSet" + characterSet.description)
    }

    /**
     A validation rule that checks to make sure that a string length does
     not exceed a specified maximum length.

     - parameter length: The maximum length of the string

     - returns: The validation rule
     */
    public static func maximumLength(_ length: Int) -> ValidationRule<String> {
        return ValidationRule<String> ({ str, completion in
            if str.count <= length {
                completion(.valid)
            } else {
                let errorFormat = NSLocalizedString("Cannot exceed %d characters", comment: "Maximum length error message")
                completion(.invalid(message: String(format: errorFormat, length)))
            }
        }, identifier: "maximumLength" + String(length))
    }

    /**
     A validation rule that checks to make sure that a string length is
     at least a specified minimum length.

     - parameter length: The minimum length of the string

     - returns: The validation rule
     */
    public static func minimumLength(_ length: Int) -> ValidationRule<String> {
        return ValidationRule<String> ({ str, completion in
            if str.count >= length {
                completion(.valid)
            } else {
                let errorFormat = NSLocalizedString("Must be at least %d characters long", comment: "Minimum length error message")
                completion(.invalid(message: String(format: errorFormat, length)))
            }
        }, identifier: "minimumLength" + String(length))
    }

    /**
     A validation rule that used to validate credit card numbers.

     - returns: The validation rule
     */

    public static var luhnCheck: ValidationRule<String> {
        // https://gist.github.com/cwagdev/635ce973e8e86da0403a#gistcomment-1645026
        func luhnCheck(cardNumber: String) -> Bool {
            var sum = 0
            let reversedCharacters = cardNumber.reversed().map { String($0) }
            for (idx, element) in reversedCharacters.enumerated() {
                guard let digit = Int(element) else { return false }
                switch ((idx % 2 == 1), digit) {
                case (true, 9): sum += 9
                case (true, 0...8): sum += (digit * 2) % 9
                default: sum += digit
                }
            }
            return sum % 10 == 0
        }
        return ValidationRule<String> ({ str, completion in
            if luhnCheck(cardNumber: str) {
                completion(.valid)
            } else {
                let error = NSLocalizedString("Invalid card number", comment: "Invalid card number")
                completion(.invalid(message: String(format: error)))
            }
        }, identifier: "luhnCheck")
    }

    /// A validator for `ValueType`. The first parameter is the value to be
    /// validated, and the second parameter is a closure that the validator should
    /// call upon completion with the result of the validation.
    public typealias Validator = (ValueType, (@escaping (ValidationResult) -> Void)) -> Void

    private let validator: Validator

    /**
     Designated initializer

     - parameter validator: The validator to wrap

     - returns: An initialized instance of the receiver
     */
    public init(_ validator: @escaping Validator, identifier: String) {
        self.validator = validator
        self.identifier = identifier
    }

    /**
     Invokes the validator on a value.

     - parameter value:             The value to validate
     - parameter completionHandler: A completion handler that is called once
     the validation completes asynchronously
     */
    public func validate(_ value: ValueType, completionHandler: @escaping (ValidationResult) -> Void) {
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
    public static func validateRules(_ rules: [ValidationRule], forValue value: ValueType, queue: DispatchQueue = .main, completionHandler: @escaping (ValidationResult) -> Void) {
        var remainingRules = rules
        var validateNext: () -> Void = {}
        validateNext = {
            queue.async {
                guard let nextRule = remainingRules.first else {
                    completionHandler(.valid)
                    return
                }
                remainingRules.removeFirst()
                nextRule.validate(value) { result in
                    switch result {
                    case .valid:
                        validateNext()
                    case .invalid, .cancelled:
                        DispatchQueue.main.async {
                            completionHandler(result)
                        }
                    }
                }
            }
        }
        validateNext()
    }
}
