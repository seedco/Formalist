//
//  ViewController.swift
//  Example
//
//  Created by Indragie Karunaratne on 2016-05-25.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit
import Forms
import StackViewController

class ViewController: UIViewController {
    private let segmentValue = FormValue("Segment 1")
    private let booleanValue = FormValue(false)
    private let textViewValue = FormValue("")
    private let emailValue = FormValue("")
    private let stringValue3 = FormValue("")
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Example"
        edgesForExtendedLayout = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var formViewController: FormViewController = {
        let edgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        var groupedConfiguration = GroupElement.Configuration()
        groupedConfiguration.style = .Grouped(backgroundColor: .whiteColor())
        groupedConfiguration.layout.edgeInsets = edgeInsets
        
        return FormViewController([
            inset(edgeInsets, elements: [
                StaticTextElement(text: "Welcome to the Forms Catalog app. This text is an example of a StaticTextElement. Other kinds of elements are showcased below.") {
                    $0.textAlignment = .Center
                    $0.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
                }
            ]),
            GroupElement(configuration: groupedConfiguration, elements: [
                BooleanElement(title: "Boolean Element", value: self.booleanValue),
                TextViewElement(value: self.textViewValue) {
                    $0.placeholder = "Text View Element"
                    $0.accessibilityIdentifier = "textView"
                },
                SegmentElement(title: "Segment Element", segments: [
                    Segment(content: .Title("Segment 1"), value: "Segment 1"),
                    Segment(content: .Title("Segment 2"), value: "Segment 2")
                ], selectedValue: self.segmentValue),
            ]),
            SpacerElement(height: 20.0),
            GroupElement(configuration: groupedConfiguration, elements: [
                TextFieldElement(value: self.emailValue, continuous: true, validationRules: [.Email]) {
                    $0.autocapitalizationType = .None
                    $0.autocorrectionType = .No
                    $0.spellCheckingType = .No
                    $0.placeholder = "Text Field Element (Email)"
                },
                SegueElement(icon: UIImage(named: "circle")!, title: "Segue Element", viewConfigurator: {
                    $0.accessibilityIdentifier = "segueView"
                }) { [unowned self] in
                    self.displayAlertWithTitle("Segue Element", message: "Tapped the element.")
                },
            ]),
            inset(edgeInsets, elements: [
                StaticTextElement(text: "Views can be easily wrapped to create custom form elements without subclassing, which is how this activity indicator is implemented.") {
                    $0.textAlignment = .Center
                    $0.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
                }
            ]),
            GroupElement(configuration: groupedConfiguration, elements: [
                ViewElement(value: FormValue("")) { _ in
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                    activityIndicator.startAnimating()
                    return activityIndicator
                }
            ])
        ])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackgroundColor()

        addChildViewController(formViewController)
        view.addSubview(formViewController.view)
        formViewController.view.activateSuperviewHuggingConstraints()
        formViewController.didMoveToParentViewController(self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Validate", style: .Plain, target: self, action: #selector(ViewController.validateForm(_:)))
        
        addFormObservers()
    }
    
    private func addFormObservers() {
        booleanValue.addObserver { [unowned self] in
            self.displayAlertWithTitle("Boolean Element", message: "The value changed to \($0).")
        }
        
        segmentValue.addObserver { [unowned self] in
            self.displayAlertWithTitle("Segment Element", message: "The selected value changed to \"\($0)\".")
        }
        
        textViewValue.addObserver { [unowned self] in
            self.displayAlertWithTitle("Text View Element", message: "The value changed to \($0).")
        }
        
        emailValue.addObserver { [unowned self] in
            self.title = $0.isEmpty ? "Example" : $0
        }
    }
    
    private func displayAlertWithTitle(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: { _ in })
        alertController.addAction(dismissAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @objc private func validateForm(sender: UIBarButtonItem) {
        formViewController.validate { result in
            if case .Valid = result {
                self.displayAlertWithTitle("Validation", message: "The form contents are valid.")
            }
            print("Validation result: \(result)")
        }
    }
}
