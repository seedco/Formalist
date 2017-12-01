//
//  SegmentElement.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 3/4/16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// An element used to display a segmented control with configurable segments
/// and a title displayed above it.
public final class SegmentElement<ValueType: Equatable>: FormElement {
    public typealias ViewConfigurator = (SegmentElementView) -> Void
    
    fileprivate let title: String
    fileprivate let segments: [Segment<ValueType>]
    fileprivate let selectedValue: FormValue<ValueType>
    fileprivate let viewConfigurator: ViewConfigurator?
    
    /**
     Designated initializer
     
     - parameter title:            The title to display above the segmented control
     - parameter segments:         The segments to display in the segmented control
     - parameter selectedValue:    The value to bind to the value of the selected
     segment
     - parameter viewConfigurator: An optional closure for configuring the appearance
     of the view, including the title label and segmented control
     
     - returns: An initialized instance of the receiver
     */
    public init(title: String, segments: [Segment<ValueType>], selectedValue: FormValue<ValueType>, viewConfigurator: ViewConfigurator? = nil) {
        self.title = title
        self.segments = segments
        self.selectedValue = selectedValue
        self.viewConfigurator = viewConfigurator
    }
    
    public override func render() -> UIView {
        let items = segments.map { $0.content }
        let segmentView = SegmentElementView(title: title, items: items)
        segmentView.segmentedControl.addTarget(
            self,
            action: #selector(SegmentElement.selectedSegmentChanged(_:)),
            for: .valueChanged
        )
        let updateView: (ValueType) -> Void = { [weak segmentView, weak self] selectedValue in
            guard let segmentView = segmentView, let segments = self?.segments else { return }
            if !segmentView.shouldIgnoreFormValueChanges {
                segmentView.segmentedControl.selectedSegmentIndex = {
                    for (index, value) in segments.map({ $0.value }).enumerated() {
                        if (value == selectedValue) {
                            return index
                        }
                    }
                    fatalError("\(selectedValue) does not exist in \(segments)")
                }()
            }
        }
        updateView(selectedValue.value)
        let _ = selectedValue.addObserver(updateView)
        viewConfigurator?(segmentView)
        return segmentView
    }
    
    @objc fileprivate func selectedSegmentChanged(_ sender: UISegmentedControl) {
        selectedValue.value = segments[sender.selectedSegmentIndex].value
    }
}
