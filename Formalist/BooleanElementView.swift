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
        static let MinimumIconSwitchSpacing: CGFloat = 25.0
    }

    /// The label used to display the title
    open let titleLabel: UILabel

    /// The button used to display the icon
    open let accessoryButton: UIButton

    /// The toggle used to change the boolean value
    open let toggle: UISwitch
    
    init(title: String, icon: UIImage? = nil) {
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        titleLabel.text = title
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)

        accessoryButton = UIButton(type: .custom)
        accessoryButton.setImage(icon, for: .normal)
        accessoryButton.isHidden = (icon == nil)
        accessoryButton.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)

        toggle = UISwitch(frame: CGRect.zero)
        
        super.init(frame: CGRect.zero)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, accessoryButton, toggle])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = (icon == nil) ?
            Layout.MinimumTextSwitchSpacing : Layout.MinimumIconSwitchSpacing
        
        addSubview(stackView)
        let _ = stackView.activateSuperviewHuggingConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
