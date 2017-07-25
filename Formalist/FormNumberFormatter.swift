//
//  FormNumberFormatter.swift
//  Formalist
//
//  Created by Viktor Radchenko on 7/21/17.
//  Copyright © 2017 Seed Platform, Inc. All rights reserved.
//

public struct FormNumberFormatter: Formattable {

    let pattern: String
    let replaceCharacter: Character

    public init(
        pattern: String,
        replaceCharacter: Character
    ) {
        self.pattern = pattern
        self.replaceCharacter = replaceCharacter
    }

    public func from(input: String) -> String {
        let newValue = input.digits
        var result = ""
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
