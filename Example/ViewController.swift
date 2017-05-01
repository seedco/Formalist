//
//  ViewController.swift
//  Example
//
//  Created by Indragie Karunaratne on 2016-05-25.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit
import Formalist
import StackViewController

class ViewController: UIViewController {
    fileprivate let segmentValue = FormValue("Segment 1")
    fileprivate let booleanValue = FormValue(false)
    fileprivate let textViewValue = FormValue("")
    fileprivate let floatLabelValue = FormValue("")
    fileprivate let multiLineFloatLabelValue = FormValue("")
    fileprivate let emailValue = FormValue("")
    fileprivate let stringValue3 = FormValue("")
    fileprivate let pickerFieldValue = FormValue("")
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Example"
        edgesForExtendedLayout = UIRectEdge()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var formViewController: FormViewController = {
        let edgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        var groupedConfiguration = GroupElement.Configuration()
        groupedConfiguration.style = .grouped(backgroundColor: .white)
        groupedConfiguration.layout.edgeInsets = edgeInsets
        
        return FormViewController(elements: [
            inset(edgeInsets, elements: [
                staticText("Welcome to the Formalist Catalog app. This text is an example of a StaticTextElement. Other kinds of elements are showcased below.") {
                    $0.textAlignment = .center
                    $0.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
                }
            ]),
            group(configuration: groupedConfiguration, elements: [
                toggle(title: "Boolean Element", value: self.booleanValue, icon: UIImage(named: "circle")!),
                textView(value: self.textViewValue) {
                    $0.placeholder = "Text View Element"
                    $0.accessibilityIdentifier = "textView"
                },
                singleLineFloatLabel(name: "Float Label Element", value: self.floatLabelValue) {
                    $0.textEntryView.accessibilityIdentifier = "floatLabel"
                },
                multiLineFloatLabel(name: "Float MultiLine Element", value: self.multiLineFloatLabelValue) {
                    $0.textEntryView.accessibilityIdentifier = "multiLineFloatLabel"
                },
                pickerField(name: "Picker Field Element", value: self.pickerFieldValue, items: [
                    PickerValue(title: "Value #1", value: "value1"),
                    PickerValue(title: "Value #2", value: "value2"),
                    PickerValue(title: "Value #3", value: "value3")
                ]) {
                    $0.textEntryView.accessibilityIdentifier = "pickerField"
                },
                segments(title: "Segment Element", segments: [
                    Segment(content: .title("Segment 1"), value: "Segment 1"),
                    Segment(content: .title("Segment 2"), value: "Segment 2")
                ], selectedValue: self.segmentValue),
            ]),
            spacer(height: 20.0),
            group(configuration: groupedConfiguration, elements: [
                textField(value: self.emailValue, configuration: TextEditorConfiguration(continuouslyUpdatesValue: true), validationRules: [.email]) {
                    $0.autocapitalizationType = .none
                    $0.autocorrectionType = .no
                    $0.spellCheckingType = .no
                    $0.placeholder = "Text Field Element (Email)"
                },
                segue(icon: UIImage(named: "circle")!, title: "Segue Element", viewConfigurator: {
                    $0.accessibilityIdentifier = "segueView"
                }) { [unowned self] in
                    self.displayAlertWithTitle("Segue Element", message: "Tapped the element.")
                },
            ]),
            inset(edgeInsets, elements: [
                StaticTextElement(text: "Views can be easily wrapped to create custom form elements without subclassing, which is how this activity indicator is implemented.") {
                    $0.textAlignment = .center
                    $0.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
                }
            ]),
            group(configuration: groupedConfiguration, elements: [
                customView(value: FormValue("")) { _ in
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    activityIndicator.startAnimating()
                    return activityIndicator
                }
            ])
        ])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground

        addChildViewController(formViewController)
        view.addSubview(formViewController.view)
        let _ = formViewController.view.activateSuperviewHuggingConstraints()
        formViewController.didMove(toParentViewController: self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Validate", style: .plain, target: self, action: #selector(ViewController.validateForm(_:)))
        
        addFormObservers()
    }
    
    fileprivate func addFormObservers() {
        let _ = booleanValue.addObserver { [unowned self] in
            self.displayAlertWithTitle("Boolean Element", message: "The value changed to \($0).")
        }
        
        let _ = segmentValue.addObserver { [unowned self] in
            self.displayAlertWithTitle("Segment Element", message: "The selected value changed to \"\($0)\".")
        }
        
        let _ = textViewValue.addObserver { [unowned self] in
            self.displayAlertWithTitle("Text View Element", message: "The value changed to \"\($0)\".")
        }
        
        let _ = floatLabelValue.addObserver { [unowned self] in
            self.displayAlertWithTitle("Float Label Element", message: "The value changed to \"\($0)\".")
        }
        
        let _ = emailValue.addObserver { [unowned self] in
            self.title = $0.isEmpty ? "Example" : $0
        }
    }
    
    fileprivate func displayAlertWithTitle(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { _ in })
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc fileprivate func validateForm(_ sender: UIBarButtonItem) {
        formViewController.validate { result in
            if case .valid = result {
                self.displayAlertWithTitle("Validation", message: "The form contents are valid.")
            }
            print("Validation result: \(result)")
        }
    }
}
