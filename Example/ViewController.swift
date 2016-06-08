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
    private let stringValue1 = FormValue("")
    private let stringValue2 = FormValue("")
    private let stringValue3 = FormValue("")
    private let segmentValue = FormValue("Segment 1")
    private let booleanValue = FormValue(false)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Example"
        edgesForExtendedLayout = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var formViewController: FormViewController = {
        var configuration = GroupElement.Configuration()
        configuration.style = .Grouped(backgroundColor: .whiteColor())
        configuration.layout.mode = .IntrinsicSize
        configuration.layout.edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
        return FormViewController([
            GroupElement(configuration: configuration, elements: [
                BooleanElement(title: "Boolean Element", value: self.booleanValue),
                TextFieldElement(value: self.stringValue1) {
                    $0.placeholder = "Text Element 1"
                },
                SegmentElement(title: "Test Segment", segments: [
                    Segment(content: .Title("Segment 1"), value: "Segment 1"),
                    Segment(content: .Title("Segment 2"), value: "Segment 2")
                ], selectedValue: self.segmentValue),
            ]),
            StaticTextElement(text: "This is a static text element with some text in it"),
            SpacerElement(height: 50.0) {
                $0.backgroundColor = .redColor()
            },
            GroupElement(configuration: configuration, elements: [
                TextFieldElement(value: self.stringValue2) {
                    $0.placeholder = "Text Element 2"
                },
                TextViewElement(value: self.stringValue3, validationRules: [.Email]) {
                    $0.placeholder = "Text View Element"
                }
            ])
        ])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

        addChildViewController(formViewController)
        view.addSubview(formViewController.view)
        formViewController.view.activateSuperviewHuggingConstraints()
        formViewController.didMoveToParentViewController(self)
    }
}
