//
//  ProtocolPanGestureHelperDelegate.swift
//  SFView
//
//  Created by David on 25/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a PanGestureHelper class
@objc public protocol ProtocolPanGestureHelperDelegate {
	
	// MARK: - Methods
	
	@objc optional func panGestureHelper(for gesture:UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes)
	
	@objc optional func panGestureHelper(for gesture:UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes)
	
	@objc optional func panGestureHelper(for gesture:UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes)
	
	@objc optional func panGestureHelper(for gesture:UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes)

	@objc optional func panGestureHelper(for gesture:UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes)
	
}
