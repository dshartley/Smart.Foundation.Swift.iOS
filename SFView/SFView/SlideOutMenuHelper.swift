//
//  SlideOutMenuHelper.swift
//  SFView
//
//  Created by David on 14/06/2017.
//  Copyright © 2017 f31. All rights reserved.
//

import Foundation
import UIKit

public enum SlideOutMenuDirection {
	case Up
	case Down
	case Left
	case Right
}

/// A helper for handling a slide out menu
public struct SlideOutMenuHelper {
	
	static let snapshotNumber				= 12345		// A constant used to tag a snapshot view for later retrieval
	
	// MARK: - Public Static Methods
	
	/// Calculates the progress in a particular direction
	///
	/// - Parameters:
	///   - translationInView:	The user’s touch coordinates
	///   - viewBounds:			The screen’s dimensions
	///   - direction:			The direction that the slide-out menu is moving
	/// - Returns: Progress expressed as percentage
	public static func calculateProgress(translationInView:CGPoint, viewBounds:CGRect, direction:SlideOutMenuDirection) -> CGFloat {
		
		let pointOnAxis:	CGFloat
		let axisLength:		CGFloat
		
		switch direction {
		case .Up, .Down:
			pointOnAxis = translationInView.y
			axisLength	= viewBounds.height
			
		case .Left, .Right:
			pointOnAxis = translationInView.x
			axisLength	= viewBounds.width
		}
		
		let movementOnAxis = pointOnAxis / axisLength
		let positiveMovementOnAxis:			Float
		let positiveMovementOnAxisPercent:	Float
		
		switch direction {
		case .Right, .Down: // positive
			positiveMovementOnAxis			= fmaxf(Float(movementOnAxis), 0.0)
			positiveMovementOnAxisPercent	= fminf(positiveMovementOnAxis, 1.0)
			
			return CGFloat(positiveMovementOnAxisPercent)
			
		case .Up, .Left: // negative
			positiveMovementOnAxis			= fminf(Float(movementOnAxis), 0.0)
			positiveMovementOnAxisPercent	= fmaxf(positiveMovementOnAxis, -1.0)
			
			return CGFloat(-positiveMovementOnAxisPercent)
		}
	}
	
	/// Maps the pan gesture state to various Interactor method calls
	///
	/// - Parameters:
	///   - gestureState:			The state of the pan gesture
	///   - percentThreshold:		How far the user must pan before the menu changes state
	///   - progress:				How far across the screen the user has panned
	///   - interactiveTransition:	The UIPercentDrivenInteractiveTransition that also serves as a state machine
	///   - triggerSegue:			A closure that is called to initiate the transition. The closure will contain something like performSegueWithIdentifier()
	public static func mapGestureStateToInteractor(gestureState:UIGestureRecognizerState, percentThreshold:	CGFloat, progress:CGFloat, interactiveTransition: SlideOutMenuInteractiveTransition?, triggerSegue: () -> Void){
		
		// Check interactiveTransition
		guard let interactiveTransition			= interactiveTransition else { return }
		
		switch gestureState {
		case .began:		// The hasStarted flag indicates that the interactive transition is in progress. Also, triggerSegue() is called to initiate the transition
			interactiveTransition.hasStarted	= true
			triggerSegue()
			
		case .changed:		// The user’s progress is passed into the updateInteractiveTransition() method. For example, if the user dragged 50% across the screen, the transition animation will scrub to its halfway point
			interactiveTransition.shouldFinish	= progress > percentThreshold
			interactiveTransition.update(progress)
			
		case .cancelled:	// This maps directly to the cancel() method
			interactiveTransition.hasStarted	= false
			interactiveTransition.cancel()
			
		case .ended:		// Depending on how far the user panned, the interactive transition either finishes or cancels
			interactiveTransition.hasStarted	= false
			interactiveTransition.shouldFinish
				? interactiveTransition.finish()
				: interactiveTransition.cancel()
			
		default:
			break
		}
	}
}
