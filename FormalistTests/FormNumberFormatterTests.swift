//
//  FormNumberFormatterTests.swift
//  Formalist
//
//  Created by Viktor Radchenko on 7/21/17.
//  Copyright © 2017 Seed Platform, Inc. All rights reserved.
//

import XCTest
@testable import Formalist

class FormNumberFormatterTests: XCTestCase {

    func testFormatting1() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "XXX-XXX-XXXX",
                replaceCharacter: "X"
            )
        )
        let value = ""

        XCTAssertEqual("", formatter.from(input: value))
    }

    func testFormatting2() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "XXX-XXX-XXXX",
                replaceCharacter: "X"
            )
        )
        let value = "11"

        XCTAssertEqual("11", formatter.from(input: value))
    }

    func testFormatting3() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "XXX-XXX-XXXX",
                replaceCharacter: "X"
            )
        )
        let value = "1234567890"

        XCTAssertEqual("123-456-7890", formatter.from(input: value))
    }

    func testFormatting4() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "XXX-XXX-XXXX",
                replaceCharacter: "X"
            )
        )
        let value = "1234"

        XCTAssertEqual("123-4", formatter.from(input: value))
    }

    func testFormatting5() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "XXX-XXX-XXXX",
                replaceCharacter: "X"
            )
        )
        let value = "123456"

        XCTAssertEqual("123-456", formatter.from(input: value))
    }

    func testFormatting6() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "XXX-XXX-XXXX",
                replaceCharacter: "X"
            )
        )
        let value = "12345678901111"

        XCTAssertEqual("123-456-7890", formatter.from(input: value))
    }

    func testFormatting7() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "XXX-XXX-XXXX",
                replaceCharacter: "X"
            )
        )
        let value = "123456789"

        XCTAssertEqual("123-456-789", formatter.from(input: value))
    }

    func testFormatting8() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "",
                replaceCharacter: "X"
            )
        )
        let value = "123"

        XCTAssertEqual("", formatter.from(input: value))
    }

    func testFormatting9() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "X",
                replaceCharacter: "X"
            )
        )
        let value = "123"

        XCTAssertEqual("1", formatter.from(input: value))
    }

    func testFormatting10() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "SSS",
                replaceCharacter: "X"
            )
        )
        let value = "123"

        XCTAssertEqual("SSS", formatter.from(input: value))
    }

    func testFormatting11() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "XXX--XXX--XXXX",
                replaceCharacter: "X"
            )
        )
        let value = "123456"

        XCTAssertEqual("123--456", formatter.from(input: value))
    }

    func testFormatting12() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "!XXX-!-XXX-!-XXXX",
                replaceCharacter: "X"
            )
        )
        let value = "123456"

        XCTAssertEqual("!123-!-456", formatter.from(input: value))
    }

    func testFormattingPhoneNumber1() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "XXX-XXX-XXXX",
                replaceCharacter: "X"
            )
        )
        let value = "1234567890"

        XCTAssertEqual("123-456-7890", formatter.from(input: value))
    }

    func testFormattingPhoneNumber2() {
        let formatter = FormNumberFormatter(
            type: .custom(
                pattern: "(XXX)-XXX-XXXX",
                replaceCharacter: "X"
            )
        )
        let value = "1234567890"

        XCTAssertEqual("(123)-456-7890", formatter.from(input: value))
    }

    func testFormattingSocialSecurity() {
        let formatter = FormNumberFormatter(type: .SSN)
        let value = "123456789"

        XCTAssertEqual("123-45-6789", formatter.from(input: value))
    }

    func testFormattingEIN() {
        let formatter = FormNumberFormatter(type: .EIN)
        let value = "123456789"

        XCTAssertEqual("12-3456789", formatter.from(input: value))
    }

    func testFormattingCreditCard() {
        let formatter = FormNumberFormatter(type: .creditCard)
        let value = "1234123412341234"

        XCTAssertEqual("1234 1234 1234 1234", formatter.from(input: value))
    }
}

extension FormNumberFormatter {
    static func make(
        pattern: String = "XXX-XXX-XXXX",
        replaceCharacter: Character = "X"
    ) -> FormNumberFormatter {
        return FormNumberFormatter(
            type: .custom(
                pattern: pattern,
                replaceCharacter: replaceCharacter
            )
        )
    }
}
