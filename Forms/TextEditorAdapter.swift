//
//  TextEditorAdapter.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

public typealias TextChangedObserver = String -> Void

public protocol TextEditorAdapterDelegate: AnyObject {
    func textEditorAdapterTextDidBeginEditing(adapter: _TextEditorAdapter)
    func textEditorAdapterTextDidEndEditing(adapter: _TextEditorAdapter)
    func textEditorAdapterTextDidChange(adapter: _TextEditorAdapter)
}

public protocol TextEditorAdapter: _TextEditorAdapter {
    associatedtype ViewType: UIView
    
    var view: ViewType { get }
}

public protocol _TextEditorAdapter: AnyObject {
    init(configuration: TextEditorConfiguration, textChangedObserver: TextChangedObserver)
    var text: String { get set }
    weak var delegate: TextEditorAdapterDelegate? { get set }
}
