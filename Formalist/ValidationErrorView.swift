//
//  ValidationErrorView.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-04.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// A view that displays a validation error message
public class ValidationErrorView: UIView {
    private struct Appearance {
        static let TextColor = UIColor(red: 0.945, green: 0.333, blue: 0.361, alpha: 1.0)
        static let BackgroundColor = UIColor(red: 1.0, green: 0.973, blue: 0.969, alpha: 1.0)
    }
    
    /// The label used to display the message
    public let label: UILabel
    
    public override init(frame: CGRect) {
        label = UILabel(frame: CGRectZero)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        label.textColor = Appearance.TextColor
        
        super.init(frame: frame)
        
        backgroundColor = Appearance.BackgroundColor
        addSubview(label)
        
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: ["label": label])
        constraints.append(NSLayoutConstraint(
            item: label,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0.0
        ))
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
