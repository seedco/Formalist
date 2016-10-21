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
public class SegmentElementView: UIView {
    public struct Layout {
        public let titleSegmentedControlSpacing: CGFloat

        public init(titleSegmentedControlSpacing: CGFloat = 12) {
            self.titleSegmentedControlSpacing = titleSegmentedControlSpacing
        }
    }

    /// The label that displays the title above the segmented control
    public let titleLabel: UILabel

    /// The segmented control that displays the segments
    public let segmentedControl: UISegmentedControl

    public var layout: Layout {
        didSet {
            applyLayout(layout)
        }
    }

    private let stackView: UIStackView

    init(title: String, items: [SegmentContent], layout: Layout = Layout()) {
        self.layout = layout

        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        titleLabel.text = title

        segmentedControl = UISegmentedControl(items: items.map { $0.objectValue })

        stackView = UIStackView(arrangedSubviews: [titleLabel, segmentedControl])

        super.init(frame: CGRectZero)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical

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
