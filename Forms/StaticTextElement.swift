//
//  StaticTextElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-04-26.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// An element used to display static text
public class StaticTextElement: FormElement {
    public typealias ViewConfigurator = UILabel -> Void
    
    private let text: String
    private let viewConfigurator: ViewConfigurator?
    
    /**
     Designated initializer
     
     - parameter text:             The text to display
     - parameter viewConfigurator: An optional block used to configure the label
     used to display the text
     
     - returns: An initialized instance of the receiver
     */
    public init(text: String, viewConfigurator: ViewConfigurator? = nil) {
        self.text = text
        self.viewConfigurator = viewConfigurator
    }
    
    public func render() -> UIView {
        let label = UILabel(frame: CGRectZero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        label.text = text
        return label
    }
}
