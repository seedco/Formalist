//
//  SegmentElementView.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 3/4/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import StackViewController

/// The view used to render a `SegmentElement`
open class SegmentElementView: UIView {
    public struct Layout {
        public let titleSegmentedControlSpacing: CGFloat

        public init(titleSegmentedControlSpacing: CGFloat = 12) {
            self.titleSegmentedControlSpacing = titleSegmentedControlSpacing
        }
    }

    /// The label that displays the title above the segmented control
    open let titleLabel: UILabel

    /// The segmented control that displays the segments
    open let segmentedControl: UISegmentedControl

    open var layout: Layout {
        didSet {
            applyLayout(layout)
        }
    }

    fileprivate let stackView: UIStackView

    init(title: String, items: [SegmentContent], layout: Layout = Layout()) {
        self.layout = layout

        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        titleLabel.text = title

        segmentedControl = UISegmentedControl(items: items.map { $0.objectValue })

        stackView = UIStackView(arrangedSubviews: [titleLabel, segmentedControl])

        super.init(frame: CGRect.zero)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        addSubview(stackView)
        stackView.activateSuperviewHuggingConstraints()
        applyLayout(layout)
    }

    func applyLayout(_ layout: Layout) {
        stackView.spacing = layout.titleSegmentedControlSpacing
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
