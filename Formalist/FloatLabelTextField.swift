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
open class FloatLabelTextField: UITextField {
    fileprivate var originalAttributedPlaceholder: NSAttributedString?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(FloatLabelTextField.textDidBeginEditing(_:)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        nc.addObserver(self, selector: #selector(FloatLabelTextField.textDidEndEditing(_:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Notifications
    
    @objc fileprivate func textDidBeginEditing(_ notification: Notification) {
        originalAttributedPlaceholder = attributedPlaceholder
        attributedPlaceholder = nil
    }
    
    @objc fileprivate func textDidEndEditing(_ notification: Notification) {
        attributedPlaceholder = originalAttributedPlaceholder
        originalAttributedPlaceholder = nil
    }
}
