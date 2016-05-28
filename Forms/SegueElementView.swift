//
//  SegueElementView.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-05-01.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit
import StackViewController

/// The view used to render a `SegueElement`
public class SegueElementView: UIView {
    private struct Layout {
        static let IconLabelSpacing: CGFloat = 10.0
    }
    
    /// The label used to display the title
    public let label: UILabel
    
    /// The image view used to display the icon
    public let imageView: UIImageView
    
    init(icon: UIImage?, title: String) {
        label = UILabel(frame: CGRectZero)
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        label.text = title
        
        imageView = UIImageView(image: icon)
        imageView.hidden = (icon == nil)
        imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        
        super.init(frame: CGRectZero)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Horizontal
        stackView.alignment = .Center
        stackView.spacing = Layout.IconLabelSpacing
        
        addSubview(stackView)
        stackView.activateSuperviewHuggingConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

