//
//  FloatLabelTextEditorAdapter.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed.co. All rights reserved.
//

/// Adapts a `FloatLabel` to a generic interface used by
/// form elements that perform text editing.
public final class FloatLabelTextEditorAdapter<InnerAdapterType: TextEditorAdapter where InnerAdapterType.ViewType: FloatLabelTextEntryView>: TextEditorAdapter {
    
    public private(set) lazy var view: FloatLabel<InnerAdapterType> = FloatLabel(adapter: self.innerAdapter)
    
    public var text: String {
        get { return innerAdapter.text }
        set { innerAdapter.text = newValue }
    }
    
    public var delegate: TextEditorAdapterDelegate? {
        get { return innerAdapter.delegate }
        set { innerAdapter.delegate = newValue }
    }
    
    private let configuration: TextEditorConfiguration
    private let textChangedObserver: TextChangedObserver
    private lazy var innerAdapter: InnerAdapterType = InnerAdapterType(configuration: self.configuration, textChangedObserver: self.textChangedObserver)
    
    public init(configuration: TextEditorConfiguration, textChangedObserver: TextChangedObserver) {
        self.configuration = configuration
        self.textChangedObserver = textChangedObserver
    }
}
