//
//  TextViewDelegate.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-13.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

@objc final class TextViewDelegate: NSObject, UITextViewDelegate {
    private let resignFirstResponderOnReturn: Bool
    private let maximumLength: Int?
    
    init(resignFirstResponderOnReturn: Bool, maximumLength: Int?) {
        self.resignFirstResponderOnReturn = resignFirstResponderOnReturn
        self.maximumLength = maximumLength
    }
    
    // MARK: UITextViewDelegate
    
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
