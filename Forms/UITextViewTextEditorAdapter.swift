//
//  UITextViewTextEditorAdapter.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

@objc final class UITextViewTextEditorAdapter: NSObject, TextEditorAdapter, UITextViewDelegate {
    typealias TextChangedObserver = String -> Void
    
    private lazy var textView: UITextView = {
        let textView = PlaceholderTextView(frame: CGRectZero)
        textView.delegate = self
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textView.scrollEnabled = false
        textView.textContainerInset = UIEdgeInsetsZero
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .clearColor()
        return textView
    }()
    
    var view: UIView { return textView }
    
    var text: String {
        get { return textView.text }
        set { textView.text = newValue }
    }
    
    weak var delegate: TextEditorAdapterDelegate?
    
    private let configuration: TextEditorConfiguration
    private let textChangedObserver: TextChangedObserver
    
    init(configuration: TextEditorConfiguration, textChangedObserver: TextChangedObserver) {
        self.configuration = configuration
        self.textChangedObserver = textChangedObserver
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        delegate?.textEditorAdapterTextDidBeginEditing(self)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        delegate?.textEditorAdapterTextDidEndEditing(self)
        if !configuration.continuouslyUpdatesValue {
            textChangedObserver(textView.text)
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        delegate?.textEditorAdapterTextDidChange(self)
        if configuration.continuouslyUpdatesValue {
            textChangedObserver(textView.text)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
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
