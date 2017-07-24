//
//  FormNumberFormatter.swift
//  Formalist
//
//  Created by Viktor Radchenko on 7/21/17.
//  Copyright © 2017 Seed Platform, Inc. All rights reserved.
//

public enum FormNumberType {
    case EIN
    case SSN
    case creditCard
    case custom(pattern: String, replaceCharacter: Character)
}

public struct FormNumberFormatter: Formattable {

    let type: FormNumberType

    public init(
        type: FormNumberType
    ) {
        self.type = type
    }

    public func from(input: String) -> String {
        let newValue = input.digits
        var result = ""
        let pattern = type.pattern
        let replaceCharacter = type.replaceCharacter
        var newValueIndex = newValue.startIndex
        var patternIndex = pattern.startIndex

        while patternIndex < pattern.endIndex && newValueIndex < newValue.endIndex  {
            let value = pattern[patternIndex]
            if value == replaceCharacter {
                result.append(newValue[newValueIndex])
                newValueIndex = newValue.index(newValueIndex, offsetBy: 1)
            } else {
                result.append(value)
            }
            patternIndex = pattern.index(patternIndex, offsetBy: 1)
        }
        return result
    }
}

extension String {
    var digits: String {
        return components(
            separatedBy: CharacterSet.decimalDigits.inverted
        ).joined()
    }
}

private extension FormNumberType {
    var pattern: String {
        switch self {
        case .EIN:
            return "XX-XXXXXXX"
        case .SSN:
            return "XXX-XX-XXXX"
        case .creditCard:
            return "XXXX XXXX XXXX XXXX"
        case .custom(let pattern, _):
            return pattern
        }
    }

    var replaceCharacter: Character {
        switch self {
        case .EIN, .SSN, .creditCard:
            return "X"
        case .custom(_, let replaceCharacter):
            return replaceCharacter
        }
    }
}
