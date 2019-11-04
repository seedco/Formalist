//
//  ValidationErrorView.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-04.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// A view that displays a validation error message
open class ValidationErrorView: UIView {
    fileprivate struct Appearance {
        static let TextColor = UIColor(red: 0.945, green: 0.333, blue: 0.361, alpha: 1.0)
        static let BackgroundColor = UIColor(red: 1.0, green: 0.973, blue: 0.969, alpha: 1.0)
    }
    
    /// The label used to display the message
    public let label: UILabel
    
    public override init(frame: CGRect) {
        label = UILabel(frame: CGRect.zero)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        label.textColor = Appearance.TextColor
        
        super.init(frame: frame)
        
        backgroundColor = Appearance.BackgroundColor
        addSubview(label)
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: ["label": label])
        constraints.append(NSLayoutConstraint(
            item: label,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0
        ))
        NSLayoutConstraint.activate(constraints)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
