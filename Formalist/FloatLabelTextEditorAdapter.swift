//
//  FloatLabelTextEditorAdapter.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

/// Adapts a `FloatLabel` to a generic interface used by
/// form elements that perform text editing.
public final class FloatLabelTextEditorAdapter<InnerAdapterType: TextEditorAdapter>: TextEditorAdapter where InnerAdapterType.ViewType: FloatLabelTextEntryView {
    public typealias ViewType = FloatLabel<InnerAdapterType>
    public typealias TextChangedObserver = (FloatLabelTextEditorAdapter<InnerAdapterType>, ViewType) -> Void
    
    fileprivate let configuration: TextEditorConfiguration
    fileprivate lazy var innerAdapter: InnerAdapterType = InnerAdapterType(configuration: self.configuration)
    
    public init(configuration: TextEditorConfiguration) {
        self.configuration = configuration
    }

    public func createViewWithCallbacks(
      _ callbacks: TextEditorAdapterCallbacks<FloatLabelTextEditorAdapter<InnerAdapterType>>,
      textChangedObserver: @escaping (FloatLabelTextEditorAdapter<InnerAdapterType>, FloatLabel<InnerAdapterType>) -> Void
    ) -> FloatLabel<InnerAdapterType> {
        let floatLabel = FloatLabel(adapter: innerAdapter)

        floatLabel.textChangedObserver = { [unowned floatLabel] (adapter, view) in
            textChangedObserver(self, floatLabel)
        }

        floatLabel.adapterCallbacks = { [unowned floatLabel] in
            var innerCallbacks = TextEditorAdapterCallbacks<InnerAdapterType>()
            innerCallbacks.textDidBeginEditing = { [unowned floatLabel] _ in
                callbacks.textDidBeginEditing?(self, floatLabel)
            }
            innerCallbacks.textDidEndEditing = { [unowned floatLabel] _ in
                callbacks.textDidEndEditing?(self, floatLabel)
            }
            innerCallbacks.textDidChange = { [unowned floatLabel] _ in
                callbacks.textDidChange?(self, floatLabel)
            }
            return innerCallbacks
        }()
        
        return floatLabel
    }

    public func getTextForView(_ view: ViewType) -> String {
        return innerAdapter.getTextForView(view.textEntryView)
    }
    
    public func setText(_ text: String, forView view: ViewType) {
        innerAdapter.setText(text, forView: view.textEntryView)
    }
}
