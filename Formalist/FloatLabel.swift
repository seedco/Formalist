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
public class FloatLabel<AdapterType: TextEditorAdapter where AdapterType.ViewType: FloatLabelTextEntryView>: UIView {
    /// The label used to display the field name
    public let nameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRectZero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.alpha = 0.0
        nameLabel.font = {
            let descriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleFootnote)
            let boldDescriptor = descriptor.fontDescriptorWithSymbolicTraits(.TraitBold)
            return UIFont(descriptor: boldDescriptor, size: 0)
        }()
        return nameLabel
    }()
    
    /// The text view that contains the field's body text
    public private(set) var textEntryView: AdapterType.ViewType!
    
    /// Callbacks to call when the adapter for the text entry view receives
    /// a text editing event.
    public var adapterCallbacks: TextEditorAdapterCallbacks<AdapterType>?
    
    public override var nextFormResponder: UIView? {
        didSet {
            textEntryView.nextFormResponder = nextFormResponder
        }
    }
    
    public typealias TextChangedObserver = (AdapterType, AdapterType.ViewType) -> Void
    
    /// Callback to call when the text in the text entry view is changed
    /// See the documentation for `TextEditorAdapter` for details on
    /// the exact behaviour.
    public var textChangedObserver: TextChangedObserver?
    
    private lazy var labelShownConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.textEntryView, attribute: .Top, relatedBy: .Equal, toItem: self.nameLabel, attribute: .Bottom, multiplier: 1.0, constant: Layout.LabelTextViewSpacing),
        NSLayoutConstraint(item: self.textEntryView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
    ]
    
    private lazy var labelHiddenConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.textEntryView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.textEntryView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.textEntryView, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
    ]
    
    private lazy var heightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
    
    private let adapter: AdapterType
    private var editing = false
    private var state: State?
    
    public init(adapter: AdapterType) {
        self.adapter = adapter
        
        super.init(frame: CGRectZero)
        
        textEntryView = createTextEntryView()
        textEntryView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        addSubview(textEntryView)
        
        setupConstraints()
        transitionToState(.LabelHidden, animated: false)
        
        // We don't want the height of the view to change between states.
        // When there is no text or a single line of text, this has to
        // be enforced manually using a constraint.
        recomputeMinimumHeight()
    }
    
    private func createTextEntryView() -> AdapterType.ViewType {
        var callbacks = TextEditorAdapterCallbacks<AdapterType>()
        callbacks.textDidBeginEditing = { [unowned self] (adapter, view) in
            self.editing = true
            self.transitionToState(.LabelShown, animated: true)
            self.adapterCallbacks?.textDidBeginEditing?(adapter, view)
        }
        callbacks.textDidEndEditing = { [unowned self] (adapter, view) in
            self.editing = false
            if adapter.getTextForView(view).isEmpty {
                self.transitionToState(.LabelHidden, animated: true)
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
    }
    
    private func setupConstraints() {
        heightConstraint.active = true
        
        let views = ["nameLabel": nameLabel, "textEntryView": textEntryView]
        let nameLabelHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[nameLabel]", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(nameLabelHConstraints)
        
        let bodyTextViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[textEntryView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(bodyTextViewHConstraints)
        
        let nameLabelTopConstraint = NSLayoutConstraint(item: nameLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
        nameLabelTopConstraint.active = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets the field name displayed above the text editing area
     
     - parameter name: The field name to display
     */
    public func setFieldName(name: String) {
        nameLabel.text = name
        textEntryView.placeholder = name
    }
    
    /**
     This method must be called when any properties affecting the height
     of the view (including properties on `nameLabel` and `bodyTextView`)
     are modified, in order to recalculate the minimum height used to keep
     the height of the view constant between states.
     */
    public func recomputeMinimumHeight() {
        transitionToState(.LabelShown, animated: false)
        heightConstraint.constant = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        updateCurrentState()
    }
    
    private func updateCurrentState() {
        let state: State = adapter.getTextForView(textEntryView).isEmpty ? .LabelHidden : .LabelShown
        self.transitionToState(state, animated: false)
    }

    // MARK: UIResponder
    
    public override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    public override func becomeFirstResponder() -> Bool {
        textEntryView.becomeFirstResponder()
        return false
    }
    
    // MARK: Animation
    
    func transitionToState(state: State, animated: Bool) {
        guard state != self.state else { return }
        
        let animation = Animation(state: state)
        if animated {
            animateLabel(animation)
        } else {
            nameLabel.layer.removeAllAnimations()
            nameLabel.alpha = animation.labelOpacity
        }
        switch state {
        case .LabelShown:
            NSLayoutConstraint.deactivateConstraints(labelHiddenConstraints)
            NSLayoutConstraint.activateConstraints(labelShownConstraints)
        case .LabelHidden:
            NSLayoutConstraint.deactivateConstraints(labelShownConstraints)
            NSLayoutConstraint.activateConstraints(labelHiddenConstraints)
        }
        self.state = state
    }
    
    private func createLabelAnimation(animation: Animation) -> CAAnimation {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.0
        opacityAnimation.toValue = 1.0
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        var startingPosition = nameLabel.layer.position
        startingPosition.y += floor(nameLabel.bounds.height / 2.0)
        positionAnimation.fromValue = NSValue(CGPoint: startingPosition)
        positionAnimation.toValue = NSValue(CGPoint: nameLabel.layer.position)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [opacityAnimation, positionAnimation]
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animationGroup.duration = 0.2
        animationGroup.removedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.speed = animation.speed
        animationGroup.delegate = self
        return animationGroup
    }
    
    private func animateLabel(animation: Animation) {
        guard nameLabel.alpha != animation.labelOpacity else { return }
        nameLabel.layer.addAnimation(createLabelAnimation(animation), forKey: animation.key)
    }
    
    // MARK: CAAnimationDelegate
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let presentationLayer = nameLabel.layer.presentationLayer() as? CALayer where flag {
            nameLabel.layer.opacity = presentationLayer.opacity
        }
        nameLabel.layer.removeAllAnimations()
    }
}

private struct Layout {
    static let LabelTextViewSpacing: CGFloat = 4.0
}

enum State {
    case LabelHidden
    case LabelShown
}

private enum Animation {
    case Forward
    case Reverse
    
    init(state: State) {
        switch state {
        case .LabelShown:
            self = Forward
        case .LabelHidden:
            self = Reverse
        }
    }
    
    var speed: Float {
        switch self {
        case .Forward: return 1.0
        case .Reverse: return -1.0
        }
    }
    
    var labelOpacity: CGFloat {
        switch self {
        case .Forward: return 1.0
        case .Reverse: return 0.0
        }
    }
    
    var key: String {
        switch self {
        case .Forward: return "ForwardLabelAnimation"
        case .Reverse: return "ReverseLabelAnimation"
        }
    }
}
