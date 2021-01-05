//
//  PanGestureHelper.swift
//  SFView
//
//  Created by David on 20/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// A helper for handling pan gestures
public class PanGestureHelper {
	
	// MARK: - Private Stored Properties
	
	fileprivate var gestureAttributes				= PanGestureAttributes()
	
	
	// MARK: - Public Stored Properties
	
	public var delegate:							ProtocolPanGestureHelperDelegate?
	public var gestureRightEnableThresholdYN:		Bool			= false
	public var gestureRightCommitThreshold:			CGFloat			= 150
	public var gestureLeftEnableThresholdYN:		Bool			= false
	public var gestureLeftCommitThreshold:			CGFloat			= 150
	public var gestureUpEnableThresholdYN:			Bool			= false
	public var gestureUpCommitThreshold:			CGFloat			= 150
	public var gestureDownEnableThresholdYN:		Bool			= false
	public var gestureDownCommitThreshold:			CGFloat			= 150
	public var horizontalPanYN:						Bool = true
	public var verticalPanYN:						Bool = true
	
	
	// MARK: - Initializers
	
	public init() {
	}
	
	public init(gesture:UIPanGestureRecognizer) {
		
		// Set handler for the gesture
		gesture.addTarget(self, action: #selector(handlePanGesture(_:)))

	}

	
	// MARK: - Public Methods
	
	@objc public func handlePanGesture(_ sender:UIPanGestureRecognizer) {
		
		if (sender.state == .began) {
			
			// Get current touch point
			self.gestureAttributes.currentTouchPoint = sender.location(in: sender.view)
			
			self.gestureAttributes.direction			= .none
			self.gestureAttributes.initialTouchPoint	= self.gestureAttributes.currentTouchPoint
			
		}
		else if (sender.state == .changed) {
			
			// Get translation to calculate currentTouchPoint
			let translation: CGPoint = sender.translation(in: sender.view)
			
			// Get current touch point
			self.determineCurrentTouchPoint(translation: translation)
			
			// Determine gesture distance
			self.determineGestureDistance()
			
			if (self.gestureAttributes.direction == .none) {

				// Determine gesture direction
				self.determineGestureDirection()
				
				// Notify the delegate
				self.delegate?.panGestureHelper!(for: sender, panningStartedWith: self.gestureAttributes)
				
			} else {
				
				// Notify the delegate
				self.delegate?.panGestureHelper!(for: sender, panningContinuedWith: self.gestureAttributes)
				
			}
			
		}
		else if (sender.state == .ended || sender.state == .cancelled) {

			if (self.gestureAttributes.direction == .up) {
				
				self.checkEndofUpGesture(for: sender)
				
			} else if (self.gestureAttributes.direction == .down) {
				
				self.checkEndofDownGesture(for: sender)
				
			} else if (self.gestureAttributes.direction == .left) {
			
				self.checkEndofLeftGesture(for: sender)
				
			} else if (self.gestureAttributes.direction == .right) {
				
				self.checkEndofRightGesture(for: sender)
			}
		}
	}

	
	// MARK: - Delegate Notifications
	
	
	// MARK: - Private Methods
	
	fileprivate func determineCurrentTouchPoint(translation: CGPoint) {
	
		var tx: CGFloat = 0
		
		if (self.horizontalPanYN) {
			
			tx = translation.x
			
		}
		
		var ty: CGFloat = 0
		
		if (self.verticalPanYN) {
			
			ty = translation.y
			
		}
		
		// Get current touch point
		self.gestureAttributes.currentTouchPoint = CGPoint(x: self.gestureAttributes.initialTouchPoint.x + tx, y: self.gestureAttributes.initialTouchPoint.y + ty)
		
	}
	
	fileprivate func determineGestureDistance() {
		
		// Get vertical distance
		self.gestureAttributes.verticalDistance		= self.gestureAttributes.currentTouchPoint.y - self.gestureAttributes.initialTouchPoint.y
		
		// Get horizontal distance
		self.gestureAttributes.horizontalDistance	= self.gestureAttributes.currentTouchPoint.x - self.gestureAttributes.initialTouchPoint.x
		
		self.gestureAttributes.transform 			= CGAffineTransform(translationX: self.gestureAttributes.horizontalDistance, y: self.gestureAttributes.verticalDistance)
		
	}
	
	fileprivate func determineGestureDirection() {
		
		// Determine direction
		if (abs(self.gestureAttributes.verticalDistance) >= abs(self.gestureAttributes.horizontalDistance)) {	// Vertical movement
			
			if (self.gestureAttributes.verticalDistance < 0) {				// Moving up
				self.gestureAttributes.direction = .up
			}
			else if (self.gestureAttributes.verticalDistance > 0) {			// Moving down
				self.gestureAttributes.direction = .down
			}
			
		} else {															// Horizontal movement
			
			if (self.gestureAttributes.horizontalDistance > 0) {			// Moving right
				self.gestureAttributes.direction = .right
			}
			else if (self.gestureAttributes.horizontalDistance < 0) {		// Moving left
				self.gestureAttributes.direction = .left
			}
			
		}
		
	}

	fileprivate func checkEndofGesture(for gesture:UIPanGestureRecognizer, enableThresholdYN: Bool, stoppedAfterThresholdYN: Bool) {
		
		if (enableThresholdYN) {
			
			if (stoppedAfterThresholdYN) {
				
				// Notify the delegate
				self.delegate?.panGestureHelper!(for: gesture, panningStoppedAfterThresholdWith: self.gestureAttributes)
			}
			else {
				
				// Notify the delegate
				self.delegate?.panGestureHelper!(for: gesture, panningStoppedBeforeThresholdWith: self.gestureAttributes)
			}
			
		} else {
			
			// Notify the delegate
			self.delegate?.panGestureHelper!(for: gesture, panningStoppedWith: self.gestureAttributes)
		}
		
	}
	
	fileprivate func checkEndofUpGesture(for gesture:UIPanGestureRecognizer) {
		
		// Check if stopped after threshold
		let stoppedAfterThresholdYN: Bool = (abs(self.gestureAttributes.currentTouchPoint.y - self.gestureAttributes.initialTouchPoint.y) > self.gestureUpCommitThreshold)
		
		self.checkEndofGesture(for: gesture, enableThresholdYN: self.gestureUpEnableThresholdYN, stoppedAfterThresholdYN: stoppedAfterThresholdYN)
		
	}
	
	fileprivate func checkEndofDownGesture(for gesture:UIPanGestureRecognizer) {
		
		// Check if stopped after threshold
		let stoppedAfterThresholdYN: Bool = (abs(self.gestureAttributes.currentTouchPoint.y - self.gestureAttributes.initialTouchPoint.y) > self.gestureDownCommitThreshold)
		
		self.checkEndofGesture(for: gesture, enableThresholdYN: self.gestureDownEnableThresholdYN, stoppedAfterThresholdYN: stoppedAfterThresholdYN)
		
	}
	
	fileprivate func checkEndofLeftGesture(for gesture:UIPanGestureRecognizer) {
		
		// Check if stopped after threshold
		let stoppedAfterThresholdYN: Bool = (abs(self.gestureAttributes.currentTouchPoint.x - self.gestureAttributes.initialTouchPoint.x) > self.gestureLeftCommitThreshold)
		
		self.checkEndofGesture(for: gesture, enableThresholdYN: self.gestureLeftEnableThresholdYN, stoppedAfterThresholdYN: stoppedAfterThresholdYN)
		
	}
	
	fileprivate func checkEndofRightGesture(for gesture:UIPanGestureRecognizer) {
		
		// Check if stopped after threshold
		let stoppedAfterThresholdYN: Bool = (abs(self.gestureAttributes.currentTouchPoint.x - self.gestureAttributes.initialTouchPoint.x) > self.gestureRightCommitThreshold)
		
		self.checkEndofGesture(for: gesture, enableThresholdYN: self.gestureRightEnableThresholdYN, stoppedAfterThresholdYN: stoppedAfterThresholdYN)
		
	}
	
}
