//
//  ViewController.swift
//  Example
//
//  Created by Indragie Karunaratne on 2016-05-25.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import Forms
import StackViewController

class ViewController: UIViewController {
    private let field1Value = FormValue("")
    private let field2Value = FormValue("")
    private let boolValue = FormValue(false)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Example"
        edgesForExtendedLayout = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var formViewController: FormViewController = {
        let configuration = GroupElement.Configuration(style: .Grouped(backgroundColor: .whiteColor()), elementViewInset: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        return FormViewController(rootElement: GroupElement(configuration: configuration, elements: [
            BooleanElement(title: "Test Bool", value: self.boolValue),
            BooleanElement(title: "Test Bool 2", value: self.boolValue),
        ]))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(formViewController)
        view.addSubview(formViewController.view)
        formViewController.view.activateSuperviewHuggingConstraints()
        formViewController.didMoveToParentViewController(self)
    }
}

