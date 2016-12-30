//
//  TextEditorConfiguration.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

/// Configuration options for text editors (`UITextField`,
/// `UITextView`, etc.)
public struct TextEditorConfiguration {
    /// An action to execute upon pressing the Return key on the
    /// iOS keyboard
    public enum ReturnKeyAction {
        /// Do nothing, i.e. trigger the normal return key behaviour,
        /// which is inserting a newline character
        case none

        /// Activate the next responder in the form
        case activateNextResponder
    }

    public enum TextEditorAction {
        case done
        case next
        case returnKey
    }

    public let returnKeyAction: ReturnKeyAction
    public let continuouslyUpdatesValue: Bool
    public let maximumLength: Int?
    public let shouldResignFirstResponderWhenFinished: Bool
    public let showAccessoryViewToolbar: Bool
    public let textEditorAction: ((TextEditorAction) -> Void)?

    /**
     Designated initializer

     - parameter returnKeyAction:          The action to execute
     upon pressing the Return key on the keyboard
     - parameter continuouslyUpdatesValue: Whether the text changed
     observer callback passed to the `TextEditorAdapter` should be
     invoked continuously as the text is edited, or only once when
     the text is finished editing
     - parameter maximumLength:            The maximum text length
     to restrict text input to

     - returns: An initialized instance of the receiver
     */
    public init(
        returnKeyAction: ReturnKeyAction = .activateNextResponder,
        continuouslyUpdatesValue: Bool = true,
        maximumLength: Int? = nil,
        shouldResignFirstResponderWhenFinished: Bool = true,
        showAccessoryViewToolbar: Bool = false,
        textEditorAction: ((TextEditorAction) -> Void)? = nil
    ) {
        self.returnKeyAction = returnKeyAction
        self.continuouslyUpdatesValue = continuouslyUpdatesValue
        self.maximumLength = maximumLength
        self.shouldResignFirstResponderWhenFinished = shouldResignFirstResponderWhenFinished
        self.showAccessoryViewToolbar = showAccessoryViewToolbar
        self.textEditorAction = textEditorAction
    }
}
