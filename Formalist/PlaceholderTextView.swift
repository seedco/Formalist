//
//  PlaceholderTextView.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 1/15/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// A text view that can display a placeholder when there is no text in
/// the view and it isn't being edited (similar to how `UITextField.placeholder`
/// behaves)
open class PlaceholderTextView: UITextView {
    // MARK: Properties
    
    /// The color of the placeholder text
    open var placeholderColor: UIColor? {
        get { return _placeholderColor }
        set {
            _placeholderColor = newValue
            if let string = attributedPlaceholder?.string {
                attributedPlaceholder =
                    NSAttributedString(string: string, attributes: currentTextAttributes)
            }
        }
    }
    fileprivate var _placeholderColor: UIColor? = UIColor(white: 0.78, alpha: 1.0)
    
    /// The placeholder text to display when there is no text in the view and
    /// it isn't being edited.
    open var placeholder: String? {
        get { return _placeholder }
        set {
            _placeholder = newValue
            if let placeholder = newValue {
                attributedPlaceholder =
                    NSAttributedString(string: placeholder, attributes: currentTextAttributes)
            } else {
                attributedPlaceholder = nil
            }
        }
    }
    fileprivate var _placeholder: String?
    
    /// The attributed placeholder text to display when there is no text in the
    /// view and it isn't being edited.
    ///
    /// Setting this property will also automatically set the values of the
    /// `placeholder` and `placeholderColor` properties accordingly. The
    /// `placeholderColor` will be set based on the value of the
    /// `NSForegroundColorAttributeName` attribute at index 0 of the string if
    /// the string has a non-zero length. Otherwise it will be set to `nil`.
    open var attributedPlaceholder: NSAttributedString? {
        didSet {
            if showPlaceholder {
                super.attributedText = attributedPlaceholder
            }
            if let attributedPlaceholder = attributedPlaceholder {
                _placeholder = attributedPlaceholder.string
                if attributedPlaceholder.length > 0 {
                    let attributes = attributedPlaceholder.attributes(at: 0, effectiveRange: nil)
                    _placeholderColor = attributes[.foregroundColor] as? UIColor
                } else {
                    _placeholderColor = nil
                }
            } else {
                _placeholder = nil
                _placeholderColor = nil
            }
        }
    }
    
    fileprivate var defaultTextAttributes: [NSAttributedStringKey: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = 8
        var attributes: [NSAttributedStringKey: Any] = [.paragraphStyle: paragraphStyle]
        if let textColor = super.textColor {
            attributes[.foregroundColor] = textColor
        }
        if let font = font {
            attributes[.font] = font
        }
        return attributes
    }
    
    fileprivate var currentTextAttributes: [NSAttributedStringKey: Any] {
        var attributes: [NSAttributedStringKey: Any]
        if let attributedPlaceholder = attributedPlaceholder, attributedPlaceholder.length > 0 {
            attributes = attributedPlaceholder.attributes(at: 0, effectiveRange: nil)
        } else {
            attributes = defaultTextAttributes
        }
        attributes[.foregroundColor] = placeholderColor
        return attributes
    }
    
    fileprivate var originalTextAttributes: [NSAttributedStringKey: Any]?
    fileprivate var editing: Bool = false {
        didSet { showPlaceholder = !editing && text.isEmpty }
    }
    
    fileprivate var _showPlaceholder: Bool = false
    fileprivate var showPlaceholder: Bool {
        get { return _showPlaceholder }
        set {
            guard _showPlaceholder != newValue else { return }
            
            // Not sure why this property needs to be manually cleared, but
            // it appears that simply setting `attributedText` doesn't do it.
            // Might be a UIKit bug.
            super.textColor = nil
            
            if newValue {
                originalTextAttributes = defaultTextAttributes
                super.attributedText = attributedPlaceholder
            } else {
                super.textColor = originalTextAttributes?[.foregroundColor] as? UIColor
                super.attributedText = NSAttributedString(string: "", attributes: originalTextAttributes ?? [:])
                originalTextAttributes = nil
            }
            _showPlaceholder = newValue
        }
    }
    
    override open var text: String! {
        get {
            return showPlaceholder ? "" : super.text
        }
        set {
            showPlaceholder = !editing && newValue.isEmpty
            if !showPlaceholder {
                super.attributedText = NSAttributedString(string: newValue, attributes: defaultTextAttributes)
            }
        }
    }
    
    override open var attributedText: NSAttributedString! {
        get {
            return showPlaceholder ? NSAttributedString(string: "") : super.attributedText
        }
        set {
            showPlaceholder = !editing && (newValue.length == 0)
            if !showPlaceholder {
                super.attributedText = newValue
            }
        }
    }
    
    override open var textColor: UIColor? {
        get {
            if showPlaceholder {
                return originalTextAttributes?[.foregroundColor] as? UIColor
            } else {
                return super.textColor
            }
        }
        set {
            if showPlaceholder {
                originalTextAttributes?[.foregroundColor] = newValue
            } else {
                super.textColor = newValue
            }
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(PlaceholderTextView.textDidBeginEditing(_:)), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
        nc.addObserver(self, selector: #selector(PlaceholderTextView.textDidEndEditing(_:)), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)

        showPlaceholder = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Actions
    
    @objc fileprivate func textDidBeginEditing(_ notification: Notification) {
        editing = true
    }
    
    @objc fileprivate func textDidEndEditing(_ notification: Notification) {
        editing = false
    }
}
