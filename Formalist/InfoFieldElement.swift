//
//  InfoFieldElement.swift
//  Formalist
//
//  Created by Viktor Radchenko on 9/16/16.
//
//

import UIKit

/// An element used to display title and subStitle text. Similar look to FloatLabel
/// http://bradfrost.com/blog/post/float-label-pattern/
public final class InfoFieldElement: FormElement {
    public typealias ViewConfigurator = (UILabel, UILabel) -> Void

    public var title: NSMutableAttributedString
    public var subTitle: NSMutableAttributedString
    private let viewConfigurator: ViewConfigurator?

    /**
     Designated initializer

     - parameter title:            Title value
     - parameter subTitle:         Subtitle value
     - parameter viewConfigurator: An optional block used to configure the label

     - returns: An initialized instance of the receiver
     */

    public init(title: String, subTitle: String, viewConfigurator: ViewConfigurator? = nil) {
        self.title = NSMutableAttributedString(string: title)
        self.subTitle = NSMutableAttributedString(string: subTitle)
        self.viewConfigurator = viewConfigurator
    }

    public init(title: NSMutableAttributedString, subTitle: NSMutableAttributedString, viewConfigurator: ViewConfigurator? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.viewConfigurator = viewConfigurator
    }

    public func render() -> UIView {
        let titleLabel = UILabel()
        titleLabel.attributedText = title

        let subTitleLabel = UILabel()
        subTitleLabel.attributedText = subTitle
        subTitleLabel.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 6

        viewConfigurator?(titleLabel, subTitleLabel)
        return stackView
    }
}
