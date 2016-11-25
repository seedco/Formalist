//
//  BooleanElementView.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 3/4/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

/// The view used to render a `BooleanElement`
open class BooleanElementView: UIView {
    fileprivate struct Layout {
        static let MinimumTextSwitchSpacing: CGFloat = 10.0
    }
    
    /// The label used to display the title
    open let titleLabel: UILabel
    
    /// The toggle used to change the boolean value
    open let toggle: UISwitch
    
    init(title: String) {
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        titleLabel.text = title
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
        toggle = UISwitch(frame: CGRect.zero)
        
        super.init(frame: CGRect.zero)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, toggle])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Layout.MinimumTextSwitchSpacing
        
        addSubview(stackView)
        stackView.activateSuperviewHuggingConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
