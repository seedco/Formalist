//
//  SegueElementView.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-05-01.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

/// The view used to render a `SegueElement`
open class SegueElementView: UIView {
    fileprivate struct Layout {
        static let IconLabelSpacing: CGFloat = 10.0
    }
    
    /// The label used to display the title
    open let label: UILabel
    
    /// The image view used to display the icon
    open let imageView: UIImageView
    
    init(icon: UIImage?, title: String) {
        label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        label.text = title
        
        imageView = UIImageView(image: icon)
        imageView.isHidden = (icon == nil)
        imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        
        super.init(frame: CGRect.zero)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Layout.IconLabelSpacing
        
        addSubview(stackView)
        stackView.activateSuperviewHuggingConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

