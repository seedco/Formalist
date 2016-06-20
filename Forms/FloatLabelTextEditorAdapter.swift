//
//  FloatLabelTextEditorAdapter.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

/// Adapts a `FloatLabel` to a generic interface used by
/// form elements that perform text editing.
public final class FloatLabelTextEditorAdapter<InnerAdapterType: TextEditorAdapter where InnerAdapterType.ViewType: FloatLabelTextEntryView>: TextEditorAdapter {
    public typealias ViewType = FloatLabel<InnerAdapterType>
    
    private let configuration: TextEditorConfiguration
    private lazy var innerAdapter: InnerAdapterType = InnerAdapterType(configuration: self.configuration)
    
    public init(configuration: TextEditorConfiguration) {
        self.configuration = configuration
    }
    
    public func createViewWithCallbacks(callbacks: TextEditorAdapterCallbacks<FloatLabelTextEditorAdapter<InnerAdapterType>>?, textChangedObserver: TextChangedObserver) -> ViewType {
        var innerCallbacks = TextEditorAdapterCallbacks<InnerAdapterType>()
        var floatLabel: FloatLabel<InnerAdapterType>?
        if let callbacks = callbacks {
            innerCallbacks.textDidBeginEditing = { [weak floatLabel] _ in
                guard let floatLabel = floatLabel else { return }
                callbacks.textDidBeginEditing?(self, floatLabel)
            }
            innerCallbacks.textDidEndEditing = { [weak floatLabel] _ in
                guard let floatLabel = floatLabel else { return }
                callbacks.textDidEndEditing?(self, floatLabel)
            }
            innerCallbacks.textDidChange = { [weak floatLabel] _ in
                guard let floatLabel = floatLabel else { return }
                callbacks.textDidChange?(self, floatLabel)
            }
        }
        floatLabel = FloatLabel(adapter: innerAdapter, adapterCallbacks: innerCallbacks, textChangedObserver: textChangedObserver)
        return floatLabel!
    }
    
    public func getTextForView(view: ViewType) -> String {
        return innerAdapter.getTextForView(view.textEntryView)
    }
    
    public func setText(text: String, forView view: ViewType) {
        innerAdapter.setText(text, forView: view.textEntryView)
    }
}
