//
//  TextEditorConfiguration.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

public struct TextEditorConfiguration {
    public enum ReturnKeyAction {
        case None
        case ActivateNextResponder
        case Custom(String -> Void)
    }
    
    public let returnKeyAction: ReturnKeyAction
    public let continuouslyUpdatesValue: Bool
    public let maximumLength: Int?
    
    public init(returnKeyAction: ReturnKeyAction = .ActivateNextResponder, continuouslyUpdatesValue: Bool = false, maximumLength: Int? = nil) {
        self.returnKeyAction = returnKeyAction
        self.continuouslyUpdatesValue = continuouslyUpdatesValue
        self.maximumLength = maximumLength
    }
}
