//
//  PanGestureAttributes.swift
//  SFView
//
//  Created by David on 25/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Encapsulates attributes for a pan gesture
public class PanGestureAttributes: NSObject {
	
	// MARK: - Public Stored Properties
	
	public var initialTouchPoint:	CGPoint = CGPoint()
	public var currentTouchPoint:	CGPoint = CGPoint()
	public var direction:			SwipeDirections = .none
	public var verticalDistance:	CGFloat = 0
	public var horizontalDistance:	CGFloat = 0
	public var transform: 			CGAffineTransform? = nil
	
	
	// MARK: - Initializers
	
	public override init() {
	}
	
}
