//
//  PlaceholderTextView.swift
//  Forms
//
//  Created by Indragie Karunaratne on 1/15/16.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

/// A text view that can display a placeholder when there is no text in
/// the view and it isn't being edited (similar to how `UITextField.placeholder`
/// behaves)
public class PlaceholderTextView: UITextView {
    // MARK: Properties
    
    /// The color of the placeholder text
    public var placeholderColor: UIColor? {
        get { return _placeholderColor }
        set {
            _placeholderColor = newValue
            if let string = attributedPlaceholder?.string {
                attributedPlaceholder =
                    NSAttributedString(string: string, attributes: currentTextAttributes)
            }
        }
    }
    private var _placeholderColor: UIColor? = UIColor(white: 0.78, alpha: 1.0)
    
    /// The placeholder text to display when there is no text in the view and
    /// it isn't being edited.
    public var placeholder: String? {
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
    private var _placeholder: String?
    
    /// The attributed placeholder text to display when there is no text in the
    /// view and it isn't being edited.
    ///
    /// Setting this property will also automatically set the values of the
    /// `placeholder` and `placeholderColor` properties accordingly. The
    /// `placeholderColor` will be set based on the value of the
    /// `NSForegroundColorAttributeName` attribute at index 0 of the string if
    /// the string has a non-zero length. Otherwise it will be set to `nil`.
    public var attributedPlaceholder: NSAttributedString? {
        didSet {
            if showPlaceholder {
                super.attributedText = attributedPlaceholder
            }
            if let attributedPlaceholder = attributedPlaceholder {
                _placeholder = attributedPlaceholder.string
                if attributedPlaceholder.length > 0 {
                    let attributes = attributedPlaceholder.attributesAtIndex(0, effectiveRange: nil)
                    _placeholderColor = attributes[NSForegroundColorAttributeName] as? UIColor
                } else {
                    _placeholderColor = nil
                }
            } else {
                _placeholder = nil
                _placeholderColor = nil
            }
        }
    }
    
    private var defaultTextAttributes: [String: AnyObject] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = 8
        var attributes: [String: AnyObject] = [
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        if let textColor = super.textColor {
            attributes[NSForegroundColorAttributeName] = textColor
        }
        if let font = font {
            attributes[NSFontAttributeName] = font
        }
        return attributes
    }
    
    private var currentTextAttributes: [String: AnyObject] {
        var attributes: [String: AnyObject]
        if let attributedPlaceholder = attributedPlaceholder
            where attributedPlaceholder.length > 0 {
            attributes = attributedPlaceholder.attributesAtIndex(0, effectiveRange: nil)
        } else {
            attributes = defaultTextAttributes
        }
        attributes[NSForegroundColorAttributeName] = placeholderColor
        return attributes
    }
    
    private var originalTextAttributes: [String: AnyObject]?
    private var editing: Bool = false {
        didSet { showPlaceholder = !editing && text.isEmpty }
    }
    
    private var _showPlaceholder: Bool = true
    private var showPlaceholder: Bool {
        get { return _showPlaceholder }
        set {
            guard _showPlaceholder != newValue else { return }
            if newValue {
                originalTextAttributes = defaultTextAttributes
                super.attributedText = attributedPlaceholder
            } else {
                super.attributedText = NSAttributedString(string: "", attributes: originalTextAttributes ?? [:])
                originalTextAttributes = nil
            }
            _showPlaceholder = newValue
        }
    }
    
    override public var text: String! {
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
    
    override public var attributedText: NSAttributedString! {
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
    
    override public var textColor: UIColor? {
        get {
            if showPlaceholder {
                return originalTextAttributes?[NSForegroundColorAttributeName] as? UIColor
            } else {
                return super.textColor
            }
        }
        set {
            if showPlaceholder {
                originalTextAttributes?[NSForegroundColorAttributeName] = newValue
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
    
    private func commonInit() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(PlaceholderTextView.textDidBeginEditing(_:)), name: UITextViewTextDidBeginEditingNotification, object: self)
        nc.addObserver(self, selector: #selector(PlaceholderTextView.textDidEndEditing(_:)), name: UITextViewTextDidEndEditingNotification, object: self)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Actions
    
    @objc private func textDidBeginEditing(notification: NSNotification) {
        editing = true
    }
    
    @objc private func textDidEndEditing(notification: NSNotification) {
        editing = false
    }
}
