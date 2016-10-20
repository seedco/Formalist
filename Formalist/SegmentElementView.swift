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
        let titleSegmentedControlSpacing: CGFloat

        init(titleSegmentedControlSpacing: CGFloat = 12) {
            self.titleSegmentedControlSpacing = titleSegmentedControlSpacing
        }
    }
    
    /// The label that displays the title above the segmented control
    public let titleLabel: UILabel
    
    /// The segmented control that displays the segments
    public let segmentedControl: UISegmentedControl
    
    init(title: String, items: [SegmentContent], layout: Layout = Layout()) {
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        titleLabel.text = title
        
        segmentedControl = UISegmentedControl(items: items.map { $0.objectValue })
        
        super.init(frame: CGRectZero)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, segmentedControl])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical
        stackView.spacing = layout.titleSegmentedControlSpacing
        
        addSubview(stackView)
        stackView.activateSuperviewHuggingConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
