//
//  FloatLabelTextField.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-25.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// `UITextField` subclass that automatically hides the placeholder as soon
/// as editing begins. Intended to be used with the `FloatLabel` class.
public class FloatLabelTextField: UITextField {
    private var originalAttributedPlaceholder: NSAttributedString?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(FloatLabelTextField.textDidBeginEditing(_:)), name: UITextFieldTextDidBeginEditingNotification, object: self)
        nc.addObserver(self, selector: #selector(FloatLabelTextField.textDidEndEditing(_:)), name: UITextFieldTextDidEndEditingNotification, object: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Notifications
    
    @objc private func textDidBeginEditing(notification: NSNotification) {
        originalAttributedPlaceholder = attributedPlaceholder
        attributedPlaceholder = nil
    }
    
    @objc private func textDidEndEditing(notification: NSNotification) {
        attributedPlaceholder = originalAttributedPlaceholder
        originalAttributedPlaceholder = nil
    }
}
