//
//  SlideOutMenuDismissAnimator.swift
//  SFView
//
//  Created by David on 21/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// An animator for dismissing a slide out menu
public class SlideOutMenuDismissAnimator : NSObject {
	
	var menuWidth: CGFloat = 0.8		// Defines the width of the slide-out menu
	
	// MARK: - Initializers
	
	public required init(menuWidth: CGFloat) {
		
		self.menuWidth = menuWidth
	}
}

// MARK: - Extension UIViewControllerAnimatedTransitioning

extension SlideOutMenuDismissAnimator : UIViewControllerAnimatedTransitioning {
	
	// MARK: - Public Methods
	
	/// Get the transition duration
	///
	/// - Parameter transitionContext: The transition context
	/// - Returns: The duration
	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.6
	}
	
	/// Animate the transition
	///
	/// - Parameter transitionContext: The transition context
	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		// Check fromVC, toVC
		guard
			let fromVC		= transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
			let toVC		= transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)else {
			return
		}
		
		// Get containerView
		let containerView	= transitionContext.containerView
		
		
		// Retrieve snapshot
		let snapshot		= containerView.viewWithTag(SlideOutMenuHelper.snapshotNumber)
		
		// Animate the transition
		UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
			
			// Move the snapshot back to the center of the screen
			snapshot?.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
			
		}, completion: { _ in
			
			// Check whether the transition was completed
			let didTransitionComplete = !transitionContext.transitionWasCancelled
			
			if didTransitionComplete {
				// Insert toVC (ie. the main view) above the fromVC
				containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
				
				snapshot?.removeFromSuperview()
			}
			
			transitionContext.completeTransition(didTransitionComplete)
		})
	}
}
