//
//  TextEditorAdapter.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// A text editor adapter adapts a text editing control (e.g. a `UITextView`,
/// `UITextField`, or a custom view) to a common interface that can be used
/// with classes like `EditableTextElement` and `FloatLabel`.
///
/// This framework includes implementations of this protocol for using
/// `UITextView`, `UITextField`, and `FloatLabel`.
public protocol TextEditorAdapter: AnyObject {
    associatedtype ViewType: UIView
    
    /**
     Initializes an adapter with configuration options.
     
     - parameter configuration: Configuration options
     
     - returns: An initialized adapter
     */
    init(configuration: TextEditorConfiguration)
    
    /**
     Creates a new text editing view
     
     - parameter callbacks:           Callback functions to call to be notified
     when a raw text editing event occurs (begin editing, end editing, or
     text changed)
     - parameter textChangedObserver: A block to be called when text in the
     text editing view is modified. The behaviour of when this is called varies
     based upon the options specified in `configuration`. Namely, if
     `continuouslyUpdatesValue` is `true`, this block will be called every
     time the text is changed, and if it is `false, it will be called only
     when text editing has ended.
     
     - returns: A new text editing view
     */
  func createViewWithCallbacks(
    _ callbacks: TextEditorAdapterCallbacks<Self>,
    textChangedObserver: @escaping TextChangedObserver
  ) -> ViewType
    
    /**
     Gets the text in the specified view
     
     - parameter view: The view to retrieve text from
     
     - returns: The text in the specified view
     */
    func getTextForView(_ view: ViewType) -> String
    
    /**
     Sets the text in the specified view
     
     - parameter text: The text to display in the view
     - parameter view: The view to set the text for
     */
    func setText(_ text: String, forView view: ViewType)
}

public extension TextEditorAdapter {
    public typealias TextChangedObserver = (Self, ViewType) -> Void
}

/// Contains callback functions that are executed when a text editing
/// event occurs.
public struct TextEditorAdapterCallbacks<AdapterType: TextEditorAdapter> {
    public typealias Callback = (AdapterType, AdapterType.ViewType) -> Void
    
    /// Called when text editing begins
    public var textDidBeginEditing: Callback?
    
    /// Called when text editing ends
    public var textDidEndEditing: Callback?
    
    /// Called when any change is made to the text
    public var textDidChange: Callback?
}
