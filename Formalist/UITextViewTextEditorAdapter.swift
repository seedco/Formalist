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
    public typealias TextChangedObserver = (UITextViewTextEditorAdapter<ViewType>, ViewType) -> Void
    
    fileprivate let configuration: TextEditorConfiguration
    
    public init(configuration: TextEditorConfiguration) {
        self.configuration = configuration
    }
    
    public func createViewWithCallbacks(_ callbacks: TextEditorAdapterCallbacks<UITextViewTextEditorAdapter<ViewType>>, textChangedObserver: @escaping TextChangedObserver) -> ViewType {
        let delegate = TextViewDelegate(
            adapter: self,
            configuration: configuration,
            callbacks: callbacks,
            textChangedObserver: textChangedObserver
        )
        let textView = TextViewType(frame: CGRect.zero, textContainer: nil)
        (textView as UITextView).delegate = delegate
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .clear
        objc_setAssociatedObject(textView, &ObjCTextViewDelegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return textView
    }

    public func getTextForView(_ view: ViewType) -> String {
        return view.text
    }

    public func setText(_ text: String, forView view: ViewType) {
        view.text = text
    }
}

private var ObjCTextViewDelegateKey: UInt8 = 0

private final class TextViewDelegate<TextViewType: UITextView>: NSObject, UITextViewDelegate {
    fileprivate typealias AdapterType = UITextViewTextEditorAdapter<TextViewType>
    fileprivate typealias TextChangedObserver = (AdapterType, TextViewType) -> Void
    
    fileprivate let adapter: AdapterType
    fileprivate let configuration: TextEditorConfiguration
    fileprivate let callbacks: TextEditorAdapterCallbacks<AdapterType>
    fileprivate let textChangedObserver: TextChangedObserver
    
    init(adapter: AdapterType, configuration: TextEditorConfiguration, callbacks: TextEditorAdapterCallbacks<AdapterType>, textChangedObserver: @escaping TextChangedObserver) {
        self.adapter = adapter
        self.configuration = configuration
        self.callbacks = callbacks
        self.textChangedObserver = textChangedObserver
    }
    
    // MARK: UITextViewDelegate
    
    @objc fileprivate func textViewDidBeginEditing(_ textView: UITextView) {
        guard let textView = textView as? TextViewType else {
            fatalError("Expected text view of type \(TextViewType.self)")
        }
        callbacks.textDidBeginEditing?(adapter, textView)
    }
    
    @objc fileprivate func textViewDidEndEditing(_ textView: UITextView) {
        guard let textView = textView as? TextViewType else {
            fatalError("Expected text view of type \(TextViewType.self)")
        }
        callbacks.textDidEndEditing?(adapter, textView)
        if !configuration.continuouslyUpdatesValue {
            textChangedObserver(adapter, textView)
        }
    }
    
    @objc fileprivate func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? TextViewType else {
            fatalError("Expected text view of type \(TextViewType.self)")
        }
        callbacks.textDidChange?(adapter, textView)
        if configuration.continuouslyUpdatesValue {
            textChangedObserver(adapter, textView)
        }
    }
    
    @objc fileprivate func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // http://stackoverflow.com/a/23779209
        if let _ = text.rangeOfCharacter(from: CharacterSet.newlines, options: NSString.CompareOptions.backwards), text.count == 1 {
            switch configuration.returnKeyAction {
            case .none: return true
            case .activateNextResponder:
                if !(textView.nextFormResponder?.becomeFirstResponder() ?? false) {
                    if configuration.shouldResignFirstResponderWhenFinished {
                        textView.resignFirstResponder()
                    }
                }
                return false
            }
        } else if let maximumLength = configuration.maximumLength {
            let newLength = textView.text.count + text.count - range.length
            return newLength <= maximumLength
        } else {
            return true
        }
    }
}
