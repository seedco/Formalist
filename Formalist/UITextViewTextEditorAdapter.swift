//
//  UITextViewTextEditorAdapter.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import ObjectiveC

/// Adapts a `UITextView` to a generic interface used by
/// form elements that perform text editing.
public final class UITextViewTextEditorAdapter<TextViewType: UITextView>: TextEditorAdapter {
    public typealias ViewType = TextViewType
    
    private let configuration: TextEditorConfiguration
    
    public init(configuration: TextEditorConfiguration) {
        self.configuration = configuration
    }
    
    public func createViewWithCallbacks(callbacks: TextEditorAdapterCallbacks<UITextViewTextEditorAdapter<ViewType>>, textChangedObserver: TextChangedObserver) -> ViewType {
        let delegate = TextViewDelegate(
            adapter: self,
            configuration: configuration,
            callbacks: callbacks,
            textChangedObserver: textChangedObserver
        )
        let textView = TextViewType(frame: CGRectZero, textContainer: nil)
        (textView as UITextView).delegate = delegate
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textView.scrollEnabled = false
        textView.textContainerInset = UIEdgeInsetsZero
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .clearColor()
        objc_setAssociatedObject(textView, &ObjCTextViewDelegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return textView
    }

    public func getTextForView(view: ViewType) -> String {
        return view.text
    }

    public func setText(text: String, forView view: ViewType) {
        view.text = text
    }
}

private var ObjCTextViewDelegateKey: UInt8 = 0

private final class TextViewDelegate<TextViewType: UITextView>: NSObject, UITextViewDelegate {
    private typealias AdapterType = UITextViewTextEditorAdapter<TextViewType>
    
    private let adapter: AdapterType
    private let configuration: TextEditorConfiguration
    private let callbacks: TextEditorAdapterCallbacks<AdapterType>
    private let textChangedObserver: TextChangedObserver
    
    init(adapter: AdapterType, configuration: TextEditorConfiguration, callbacks: TextEditorAdapterCallbacks<AdapterType>, textChangedObserver: TextChangedObserver) {
        self.adapter = adapter
        self.configuration = configuration
        self.callbacks = callbacks
        self.textChangedObserver = textChangedObserver
    }
    
    // MARK: UITextViewDelegate
    
    @objc private func textViewDidBeginEditing(textView: UITextView) {
        guard let textView = textView as? TextViewType else {
            fatalError("Expected text view of type \(TextViewType.self)")
        }
        callbacks.textDidBeginEditing?(adapter, textView)
    }
    
    @objc private func textViewDidEndEditing(textView: UITextView) {
        guard let textView = textView as? TextViewType else {
            fatalError("Expected text view of type \(TextViewType.self)")
        }
        callbacks.textDidEndEditing?(adapter, textView)
        if !configuration.continuouslyUpdatesValue {
            textChangedObserver(textView.text)
        }
    }
    
    @objc private func textViewDidChange(textView: UITextView) {
        guard let textView = textView as? TextViewType else {
            fatalError("Expected text view of type \(TextViewType.self)")
        }
        callbacks.textDidChange?(adapter, textView)
        if configuration.continuouslyUpdatesValue {
            textChangedObserver(textView.text)
        }
    }
    
    @objc private func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // http://stackoverflow.com/a/23779209
        if let _ = text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet(), options: NSStringCompareOptions.BackwardsSearch) where text.characters.count == 1 {
            switch configuration.returnKeyAction {
            case .None: return true
            case .ActivateNextResponder:
                if !(textView.nextFormResponder?.becomeFirstResponder() ?? false) {
                    textView.resignFirstResponder()
                }
                return false
            case let .Custom(action):
                textView.resignFirstResponder()
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
