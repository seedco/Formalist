//
//  StaticTextElement.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-04-26.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

public class StaticTextElement: FormElement {
    public typealias ViewConfigurator = UILabel -> Void
    
    private let text: String
    private let viewConfigurator: ViewConfigurator?
    
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
