//
//  TextEditorConfiguration.swift
//  Forms
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
        case None
        
        /// Activate the next responder in the form
        case ActivateNextResponder
        
        /// Perform a custom action. The `String` parameter passed
        /// into the block is the current text contents of the
        /// text editor.
        case Custom(String -> Void)
    }
    
    public let returnKeyAction: ReturnKeyAction
    public let continuouslyUpdatesValue: Bool
    public let maximumLength: Int?
    
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
    public init(returnKeyAction: ReturnKeyAction = .ActivateNextResponder, continuouslyUpdatesValue: Bool = false, maximumLength: Int? = nil) {
        self.returnKeyAction = returnKeyAction
        self.continuouslyUpdatesValue = continuouslyUpdatesValue
        self.maximumLength = maximumLength
    }
}
