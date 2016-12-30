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

    lazy var doneButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }()

    var callbacks: AccessoryViewToolbarCallbacks?

    override init(frame: CGRect) {
        super.init(frame: frame)

        items = [
            nextButtonItem,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneButtonItem
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
