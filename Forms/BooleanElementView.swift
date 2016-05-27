//
//  BooleanElementView.swift
//  Forms
//
//  Created by Indragie Karunaratne on 3/4/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

/// The view used to render a `BooleanElement`
public class BooleanElementView: UIView {
    private struct Layout {
        static let MinimumTextSwitchSpacing: CGFloat = 10.0
    }
    
    /// The label used to display the title
    public let titleLabel: UILabel
    
    /// The toggle used to change the boolean value
    public let toggle: UISwitch
    
    init(title: String, value: Bool = false) {
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        titleLabel.text = title
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        
        toggle = UISwitch(frame: CGRectZero)
        toggle.on = value
        
        super.init(frame: CGRectZero)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, toggle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Horizontal
        stackView.alignment = .Center
        stackView.spacing = Layout.MinimumTextSwitchSpacing
        
        addSubview(stackView)
        stackView.activateSuperviewHuggingConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
