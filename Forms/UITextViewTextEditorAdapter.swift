//
//  UITextViewTextEditorAdapter.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

/// Adapts a `UITextView` to a generic interface used by
/// form elements that perform text editing.
@objc public final class UITextViewTextEditorAdapter: NSObject, TextEditorAdapter, UITextViewDelegate {
    public private(set) lazy var view: PlaceholderTextView = {
        let textView = PlaceholderTextView(frame: CGRectZero)
        textView.delegate = self
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textView.scrollEnabled = false
        textView.textContainerInset = UIEdgeInsetsZero
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .clearColor()
        return textView
    }()
    
    public var text: String {
        get { return view.text }
        set { view.text = newValue }
    }
    
    public weak var delegate: TextEditorAdapterDelegate?
    
    private let configuration: TextEditorConfiguration
    private let textChangedObserver: TextChangedObserver
    
    public init(configuration: TextEditorConfiguration, textChangedObserver: TextChangedObserver) {
        self.configuration = configuration
        self.textChangedObserver = textChangedObserver
    }
    
    // MARK: UITextViewDelegate
    
    public func textViewDidBeginEditing(textView: UITextView) {
        delegate?.textEditorAdapterTextDidBeginEditing(self)
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        delegate?.textEditorAdapterTextDidEndEditing(self)
        if !configuration.continuouslyUpdatesValue {
            textChangedObserver(textView.text)
        }
    }
    
    public func textViewDidChange(textView: UITextView) {
        delegate?.textEditorAdapterTextDidChange(self)
        if configuration.continuouslyUpdatesValue {
            textChangedObserver(textView.text)
        }
    }
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // http://stackoverflow.com/a/23779209
        if let _ = text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet(), options: NSStringCompareOptions.BackwardsSearch) where text.characters.count == 1 {
            switch configuration.returnKeyAction {
            case .None: return true
            case .ActivateNextResponder:
                if let nextFormResponder = textView.nextFormResponder where nextFormResponder.becomeFirstResponder() {
                    return false
                } else {
                    textView.resignFirstResponder()
                    return false
                }
            case let .Custom(action):
                action(textView.text)
                return false
            }
        } else if let maximumLength = configuration.maximumLength {
            let newLength = textView.text.characters.count + text.characters.count - range.length
            return newLength <= maximumLength
        } else {
            return true
        }
    }
}
