// Copyright Seed Platform, Inc. All rights reserved.

import UIKit

/// Contains callback functions that are executed when a toolbar
/// actions occurs.
public struct AccessoryViewToolbarCallbacks {
    public typealias Callback = () -> Void

    /// Called when next action pressed
    public var nextAction: Callback?

    /// Called when done action pressed
    public var doneAction: Callback?
}


class AccessoryViewToolbar: UIToolbar {

    lazy var nextButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction))
    }()

    private func doneButtonItem(customTitled title:String? = nil) -> UIBarButtonItem {
        if let title = title {
            return UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(done))
        } else {

            return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        }
    }

    var callbacks: AccessoryViewToolbarCallbacks?

    init(frame: CGRect, doneButtonCustomTitle: String? = nil) {
        super.init(frame: frame)

        items = [
            nextButtonItem,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneButtonItem(customTitled: doneButtonCustomTitle)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func nextAction() {
        callbacks?.nextAction?()
    }

    @objc func done() {
        callbacks?.doneAction?()
    }
}
