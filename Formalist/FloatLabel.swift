//
//  FloatLabel.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-13.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

public protocol FloatLabelTextEntryView: AnyObject {
    var placeholder: String? { get set }
}

extension UITextField: FloatLabelTextEntryView {}
extension PlaceholderTextView: FloatLabelTextEntryView {}

/// Native UIKit implementation of the float label pattern:
/// http://bradfrost.com/blog/post/float-label-pattern/
open class FloatLabel<AdapterType: TextEditorAdapter>: UIView, CAAnimationDelegate
  where AdapterType.ViewType: FloatLabelTextEntryView {

    /// The label used to display the field name
    public let nameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.alpha = 0.0
        nameLabel.font = {
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.footnote)
            let boldDescriptor = descriptor.withSymbolicTraits(.traitBold)
            return UIFont(descriptor: boldDescriptor!, size: 0)
        }()
        return nameLabel
    }()
    
    /// The container view used for adding spacing to textEntryView.
    public let containerView: UIView =  {
        let containerView = UIView()
        return containerView
    }()

    /// The text view that contains the field's body text
    open fileprivate(set) lazy var textEntryView: AdapterType.ViewType = {
        var callbacks = TextEditorAdapterCallbacks<AdapterType>()
        callbacks.textDidBeginEditing = { [unowned self] (adapter, view) in
            self.editing = true
            self.transitionToState(.labelShown, animated: true)
            self.adapterCallbacks?.textDidBeginEditing?(adapter, view)
        }
        callbacks.textDidEndEditing = { [unowned self] (adapter, view) in
            self.editing = false
            if adapter.getTextForView(view).isEmpty {
                self.transitionToState(.labelHidden, animated: true)
            }
            self.adapterCallbacks?.textDidEndEditing?(adapter, view)
        }
        callbacks.textDidChange = { [unowned self] (adapter, view) in
            if !self.editing {
                self.updateCurrentState()
            }
            self.adapterCallbacks?.textDidChange?(adapter, view)
        }
        
        return adapter.createViewWithCallbacks(callbacks, textChangedObserver: { [weak self] (adapter, view) in
            self?.textChangedObserver?(adapter, view)
        })
    }()
    
    /// Callbacks to call when the adapter for the text entry view receives
    /// a text editing event.
    open var adapterCallbacks: TextEditorAdapterCallbacks<AdapterType>?

    public typealias TextChangedObserver = (AdapterType, AdapterType.ViewType) -> Void
    
    /// Callback to call when the text in the text entry view is changed
    /// See the documentation for `TextEditorAdapter` for details on
    /// the exact behaviour.
    open var textChangedObserver: TextChangedObserver?
    
    fileprivate lazy var labelShownConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.containerView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: self.textEntryView, attribute: .height, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.textEntryView, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1.0, constant: Layout.TextInputYSpacing + Layout.TextInputTopShownSpacing),
        NSLayoutConstraint(item: self.textEntryView, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1.0, constant: 0)
    ]
    
    fileprivate lazy var labelHiddenConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.containerView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: self.textEntryView, attribute: .height, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.textEntryView, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1.0, constant: Layout.TextInputYSpacing),
        NSLayoutConstraint(item: self.textEntryView, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1.0, constant: -Layout.TextInputYSpacing),
        NSLayoutConstraint(item: self.textEntryView, attribute: .centerY, relatedBy: .equal, toItem: self.containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
    ]
    
    fileprivate lazy var heightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
    
    fileprivate let adapter: AdapterType
    fileprivate var editing = false
    fileprivate var state: State?
    
    public init(adapter: AdapterType) {
        self.adapter = adapter
        
        super.init(frame: CGRect.zero)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.containerViewDidTap))
        containerView.addGestureRecognizer(tapGesture)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        textEntryView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(textEntryView)
        
        setupConstraints()
        transitionToState(.labelHidden, animated: false)
        
        // We don't want the height of the view to change between states.
        // When there is no text or a single line of text, this has to
        // be enforced manually using a constraint.
        recomputeMinimumHeight()
    }
    
    fileprivate func setupConstraints() {
        heightConstraint.isActive = true
        
        let views: [String: Any] = ["nameLabel": nameLabel, "textEntryView": textEntryView, "containerView": containerView]
        let nameLabelHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[nameLabel]", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(nameLabelHConstraints)
        
        let containerViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(containerViewHConstraints)
        
        let bodyTextViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[textEntryView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(bodyTextViewHConstraints)
        
        let nameLabelTopConstraint = NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0.0)
        nameLabelTopConstraint.isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets the field name displayed above the text editing area
     
     - parameter name: The field name to display
     */
    open func setFieldName(_ name: String) {
        nameLabel.text = name
        textEntryView.placeholder = name
    }
    
    /**
     This method must be called when any properties affecting the height
     of the view (including properties on `nameLabel` and `bodyTextView`)
     are modified, in order to recalculate the minimum height used to keep
     the height of the view constant between states.
     */
    open func recomputeMinimumHeight() {
        transitionToState(.labelShown, animated: false)
        heightConstraint.constant = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        updateCurrentState()
    }
    
    fileprivate func updateCurrentState() {
        let state: State = adapter.getTextForView(textEntryView).isEmpty ? .labelHidden : .labelShown
        self.transitionToState(state, animated: false)
    }

    @objc func containerViewDidTap() {
        self.textEntryView.becomeFirstResponder()
    }
    
    // MARK: UIResponder
    
    open override var canBecomeFirstResponder : Bool {
        return true
    }
    
    open override func becomeFirstResponder() -> Bool {
        textEntryView.becomeFirstResponder()
        return false
    }
    
    // MARK: Animation
    
    func transitionToState(_ state: State, animated: Bool) {
        guard state != self.state else { return }
        
        UIView.animate(
            withDuration: animated ? 0.2 : 0,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseInOut],
            animations: {
                self.nameLabel.alpha = state.labelOpacity
                self.nameLabel.transform = state.labelTransform(nameLabel: self.nameLabel)
            },
            completion: nil
        )
        
        switch state {
        case .labelShown:
            NSLayoutConstraint.deactivate(labelHiddenConstraints)
            NSLayoutConstraint.activate(labelShownConstraints)
        case .labelHidden:
            NSLayoutConstraint.deactivate(labelShownConstraints)
            NSLayoutConstraint.activate(labelHiddenConstraints)
        }
        
        self.state = state
    }
}

private struct Layout {
    static let TextInputYSpacing: CGFloat = 11
    static let TextInputTopShownSpacing: CGFloat = 10
}

enum State {
    case labelHidden
    case labelShown
    
    fileprivate var labelOpacity: CGFloat {
        switch self {
        case .labelHidden: return 0
        case .labelShown: return 1
        }
    }
    
    fileprivate func labelTransform(nameLabel: UILabel) -> CGAffineTransform {
        switch self {
        case .labelHidden: return CGAffineTransform(translationX: 0, y: nameLabel.frame.height / 2)
        case .labelShown: return .identity
        }
    }
}
