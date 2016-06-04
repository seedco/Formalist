//
//  FormViewController.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-03-09.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit
import StackViewController

public class FormViewController: UIViewController {
    private let rootElement: FormElement
    private lazy var autoscrollView = AutoScrollView(frame: CGRectZero)
    
    public init(rootElement: FormElement) {
        self.rootElement = rootElement
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(@noescape _ rootElementProvider: Void -> FormElement) {
        self.init(rootElement: rootElementProvider())
    }
    
    public convenience init(@noescape _ elementsProvider: Void -> [FormElement]) {
        self.init(rootElement: GroupElement(style: .Plain, elements: elementsProvider()))
    }
    
    public convenience init(_ elements: [FormElement]) {
        self.init(rootElement: GroupElement(style: .Plain, elements: elements))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = autoscrollView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        reloadElementViews()
    }
    
    private func reloadElementViews() {
        let rootElementView = rootElement.render()
        autoscrollView.contentView = rootElementView
        let widthConstraint = NSLayoutConstraint(item: autoscrollView, attribute: .Width, relatedBy: .Equal, toItem: rootElementView, attribute: .Width, multiplier: 1.0, constant: 0.0)
        widthConstraint.active = true
    }
}
