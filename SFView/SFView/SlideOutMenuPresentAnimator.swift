//
//  SlideOutMenuPresentAnimator.swift
//  SFView
//
//  Created by David on 21/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// An animator for presenting a slide out menu
public class SlideOutMenuPresentAnimator : NSObject {

	var menuWidth: CGFloat	= 0.8		// Defines the width of the slide-out menu
	
	// MARK: - Initializers
	
	public required init(menuWidth: CGFloat) {
		
		self.menuWidth = menuWidth
	}
	
}

// MARK: - Extension UIViewControllerAnimatedTransitioning

extension SlideOutMenuPresentAnimator : UIViewControllerAnimatedTransitioning {
	
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
			let fromVC	= transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
			let toVC	= transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
			return
		}
		
		// Get containerView
		let containerView = transitionContext.containerView
		
		// Insert toVC (ie. the menu) behind the fromVC
		containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
		
		// Create the snapshot. Since the fromVC automatically gets removed after the transition, the snapshot gives the illusion that it’s still on the screen
		guard let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) else {
			return
		}
		
		snapshot.tag						= SlideOutMenuHelper.snapshotNumber
		snapshot.isUserInteractionEnabled	= false
		snapshot.layer.shadowOpacity		= 0.7
		
		// Insert the snapshot
		containerView.insertSubview(snapshot, aboveSubview: toVC.view)
		
		// Hide fromVC
		fromVC.view.isHidden				= true
		
		// Animate the transition
		UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
			
			// Move the snapshot to the right by specified % of the screen’s width
			snapshot.center.x				+= UIScreen.main.bounds.width * self.menuWidth
			
		}, completion: { _ in
			
			// Set fromVC hidden state back to normal, so that it’s ready for next time
			fromVC.view.isHidden			= false
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})
		
	}
}
