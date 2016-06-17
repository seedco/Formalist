//
//  TextEditorAdapter.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed.co. All rights reserved.
//

import UIKit

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
    var text: String { get set }
    weak var delegate: TextEditorAdapterDelegate? { get set }
}
