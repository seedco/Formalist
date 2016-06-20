//
//  TextEditorAdapter.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

public typealias TextChangedObserver = String -> Void

public protocol TextEditorAdapter: AnyObject {
    associatedtype ViewType: UIView
    
    init(configuration: TextEditorConfiguration)
    func createViewWithCallbacks(callbacks: TextEditorAdapterCallbacks<Self>?, textChangedObserver: TextChangedObserver) -> ViewType
    func getTextForView(view: ViewType) -> String
    func setText(text: String, forView view: ViewType)
}

public struct TextEditorAdapterCallbacks<AdapterType: TextEditorAdapter> {
    public typealias Callback = (AdapterType, AdapterType.ViewType) -> Void
    public var textDidBeginEditing: Callback?
    public var textDidEndEditing: Callback?
    public var textDidChange: Callback?
}
