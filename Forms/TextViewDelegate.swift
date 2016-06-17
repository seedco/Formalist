//
//  TextViewDelegate.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-13.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

@objc final class TextViewDelegate: NSObject, UITextViewDelegate {
    typealias TextChangedObserver = String -> Void
    
    private let resignFirstResponderOnReturn: Bool
    private let continuous: Bool
    private let maximumLength: Int?
    private let textChangedObserver: TextChangedObserver
    
    init(resignFirstResponderOnReturn: Bool, continuous: Bool = false, maximumLength: Int?, textChangedObserver: TextChangedObserver) {
        self.resignFirstResponderOnReturn = resignFirstResponderOnReturn
        self.continuous = continuous
        self.maximumLength = maximumLength
        self.textChangedObserver = textChangedObserver
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidEndEditing(textView: UITextView) {
        if !continuous {
            textChangedObserver(textView.text)
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        if continuous {
            textChangedObserver(textView.text)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // http://stackoverflow.com/a/23779209
        if resignFirstResponderOnReturn, let _ = text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet(), options: NSStringCompareOptions.BackwardsSearch) where text.characters.count == 1 {
            if let nextFormResponder = textView.nextFormResponder where nextFormResponder.becomeFirstResponder() {
                return false
            } else {
                textView.resignFirstResponder()
                return false
            }
        } else if let maximumLength = maximumLength {
            let newLength = textView.text.characters.count + text.characters.count - range.length
            return newLength <= maximumLength
        } else {
            return true
        }
    }
}
