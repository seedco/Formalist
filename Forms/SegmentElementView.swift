//
//  SegmentElementView.swift
//  Forms
//
//  Created by Indragie Karunaratne on 3/4/16.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit
import StackViewController

/// The view used to render a `SegmentElement`
public class SegmentElementView: UIView {
    private struct Layout {
        static let TitleSegmentedControlSpacing: CGFloat = 12
    }
    
    /// The label that displays the title above the segmented control
    public let titleLabel: UILabel
    
    /// The segmented control that displays the segments
    public let segmentedControl: UISegmentedControl
    
    init(title: String, items: [SegmentContent], selectedIndex: Int) {
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        titleLabel.text = title
        
        segmentedControl = UISegmentedControl(items: items.map { $0.objectValue })
        segmentedControl.selectedSegmentIndex = selectedIndex
        
        super.init(frame: CGRectZero)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, segmentedControl])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical
        stackView.spacing = Layout.TitleSegmentedControlSpacing
        
        addSubview(stackView)
        stackView.activateSuperviewHuggingConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
