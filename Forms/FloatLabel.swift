//
//  FloatLabel.swift
//  Forms
//
//  Created by Indragie Karunaratne on 2016-06-13.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// Native UIKit implementation of the float label pattern:
/// http://bradfrost.com/blog/post/float-label-pattern/
public class FloatLabel: UIView {
    private struct Layout {
        static let LabelTextViewSpacing: CGFloat = 4.0
    }
    
    private enum State {
        case LabelHidden
        case LabelShown
    }
    
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
    public let bodyTextView: PlaceholderTextView = {
        let bodyTextView = PlaceholderTextView(frame: CGRectZero)
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        bodyTextView.scrollEnabled = false
        bodyTextView.textContainerInset = UIEdgeInsetsZero
        bodyTextView.textContainer.lineFragmentPadding = 0
        bodyTextView.backgroundColor = .clearColor()
        return bodyTextView
    }()
    
    private lazy var labelShownConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.bodyTextView, attribute: .Top, relatedBy: .Equal, toItem: self.nameLabel, attribute: .Bottom, multiplier: 1.0, constant: Layout.LabelTextViewSpacing),
        NSLayoutConstraint(item: self.bodyTextView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
    ]
    
    private lazy var labelHiddenConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.bodyTextView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.bodyTextView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: self.bodyTextView, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
    ]
    
    private lazy var heightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
    
    private var textViewEditing = false
    private var state: State?
    
    init(name: String) {
        super.init(frame: CGRectZero)
        translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = name
        bodyTextView.placeholder = name
        
        addSubview(nameLabel)
        addSubview(bodyTextView)
        
        heightConstraint.active = true
        
        let views = ["nameLabel": nameLabel, "bodyTextView": bodyTextView]
        let nameLabelHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[nameLabel]", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(nameLabelHConstraints)
        
        let bodyTextViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[bodyTextView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(bodyTextViewHConstraints)
        
        let nameLabelTopConstraint = NSLayoutConstraint(item: nameLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
        nameLabelTopConstraint.active = true
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(FloatLabel.textViewDidBeginEditing(_:)), name: UITextViewTextDidBeginEditingNotification, object: bodyTextView)
        nc.addObserver(self, selector: #selector(FloatLabel.textViewDidEndEditing(_:)), name: UITextViewTextDidEndEditingNotification, object: bodyTextView)
        nc.addObserver(self, selector: #selector(FloatLabel.textViewTextDidChange(_:)), name: UITextViewTextDidChangeNotification, object: bodyTextView)
        
        transitionToState(.LabelHidden, animated: false)
        
        // We don't want the height of the view to change between states.
        // When there is no text or a single line of text, this has to
        // be enforced manually using a constraint.
        recomputeMinimumHeight()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     This method must be called when any properties affecting the height
     of the view (including properties on `nameLabel` and `bodyTextView`)
     are modified, in order to recalculate the minimum height used to keep
     the height of the view constant between states.
     */
    public func recomputeMinimumHeight() {
        guard let previousState = state else {
            fatalError("Cannot call this method without a valid starting state")
        }
        transitionToState(.LabelShown, animated: false)
        heightConstraint.constant = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        transitionToState(previousState, animated: false)
    }
    
    // MARK: Notifications
    
    @objc private func textViewDidBeginEditing(notification: NSNotification) {
        textViewEditing = true
        transitionToState(.LabelShown, animated: true)
    }
    
    @objc private func textViewDidEndEditing(notification: NSNotification) {
        textViewEditing = false
        if bodyTextView.text.isEmpty {
            transitionToState(.LabelHidden, animated: true)
        }
    }
    
    @objc private func textViewTextDidChange(notification: NSNotification) {
        if !textViewEditing {
            transitionToState(bodyTextView.text.isEmpty ? .LabelHidden : .LabelShown, animated: false)
        }
    }
    
    // MARK: UIResponder
    
    public override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    public override func becomeFirstResponder() -> Bool {
        bodyTextView.becomeFirstResponder()
        return false
    }
    
    // MARK: Animation
    
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
    
    private func transitionToState(state: State, animated: Bool) {
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
