//
//  SlideOutMenuManager.swift
//  SFView
//
//  Created by David on 21/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

public class SlideOutMenuManager: NSObject {

	// MARK: - Public Stored Properties
	
	public var interactiveTransition:SlideOutMenuInteractiveTransition? = nil
	public var menuWidth:				CGFloat	= 0.8		// Defines the width of the slide-out menu
	public var percentThreshold:		CGFloat = 0.3		// Defines how far the user must pan before the menu changes state
	
	
	// MARK: - Initializers
	
	public required init(interactiveTransition:SlideOutMenuInteractiveTransition) {
		
		self.interactiveTransition = interactiveTransition
	}
	
	// MARK: - Public Methods
	
	/// Presents the slide out menu
	///
	/// - Parameters:
	///   - gestureRecognizer: The gesture recognizer
	///   - view: the view
	///   - triggerSegue: the trigger segue closure
	public func presentMenu(forGesture gestureRecognizer: UIPanGestureRecognizer, view: UIView, triggerSegue: @escaping () -> Void) {

		// Get the pan gesture coordinates
		let translation = gestureRecognizer.translation(in: view)
		
		// Convert the coordinates into progress in a specific direction
		let progress	= SlideOutMenuHelper.calculateProgress(
			translationInView:		translation,
			viewBounds:				view.bounds,
			direction:				.Right)
		
		SlideOutMenuHelper.mapGestureStateToInteractor(
			gestureState:			gestureRecognizer.state,
			percentThreshold:		percentThreshold,
			progress:				progress,
			interactiveTransition:	interactiveTransition,
			triggerSegue:			triggerSegue)
	}
	
	/// Dismisses the slide out menu
	///
	/// - Parameters:
	///   - gestureRecognizer: The gesture recognizer
	///   - view: the view
	///   - triggerSegue: the trigger segue closure
	public func dismissMenu(forGesture gestureRecognizer: UIPanGestureRecognizer, view: UIView, triggerSegue: @escaping () -> Void) {

		// Get the pan gesture coordinates
		let translation = gestureRecognizer.translation(in: view)
		
		// Convert the coordinates into progress in a specific direction
		let progress	= SlideOutMenuHelper.calculateProgress(
			translationInView:		translation,
			viewBounds:				view.bounds,
			direction:				.Left
		)
		
		SlideOutMenuHelper.mapGestureStateToInteractor(
			gestureState:			gestureRecognizer.state,
			percentThreshold:		percentThreshold,
			progress:				progress,
			interactiveTransition:	interactiveTransition,
			triggerSegue:			triggerSegue)
		
	}
}

// MARK: - Extension UIViewControllerTransitioningDelegate

extension SlideOutMenuManager: UIViewControllerTransitioningDelegate {
	
	// MARK: - Public Methods
	
	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		// Override the default animation with a custom one. In this case, supply the SlideOutMenuPresentAnimator for the presenting transition
		return SlideOutMenuPresentAnimator(menuWidth: menuWidth)
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		// Override the default animation with a custom one. In this case, supply the SlideOutMenuDismissAnimator for the dismissing transition
		return SlideOutMenuDismissAnimator(menuWidth: menuWidth)
	}
	
	public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		
		// Indicate that the dismiss transition is going to be interactive, but only if the user is panning. The hasStarted flag is set to true when the pan gesture begins.
		return interactiveTransition!.hasStarted ? interactiveTransition! : nil
	}
	
	public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		
		// Indicate that the dismiss transition is going to be interactive, but only if the user is panning. The hasStarted flag is set to true when the pan gesture begins.
		return interactiveTransition!.hasStarted ? interactiveTransition! : nil
	}
}
