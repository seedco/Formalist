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

    /// The button used to display the right icon
    open let accessoryButton: UIButton

    init(icon: UIImage?, title: String, accessoryIcon: UIImage?) {
        imageView = UIImageView(image: icon)
        imageView.isHidden = (icon == nil)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        label.text = title
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)

        let labelView = UIView()
        labelView.addSubview(label)
        
        imageView = UIImageView(image: icon)
        imageView.isHidden = (icon == nil)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        accessoryButton = UIButton(type: .custom)
        accessoryButton.setImage(accessoryIcon, for: .normal)
        accessoryButton.isHidden = (accessoryIcon == nil)
        accessoryButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        super.init(frame: CGRect.zero)

        let stackView = UIStackView(arrangedSubviews: [imageView, labelView, accessoryButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Layout.IconLabelSpacing

        let _ = label.activateSuperviewHuggingConstraints()

        addSubview(stackView)
        let _ = stackView.activateSuperviewHuggingConstraints()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
