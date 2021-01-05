//
//  ProtocolPlaySpaceViewViewAccessStrategy.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which provides a strategy for accessing the PlaySpaceView view
public protocol ProtocolPlaySpaceViewViewAccessStrategy {
	
	// MARK: - Methods
	
	func present(playSpaceBitView view: ProtocolPlaySpaceBitView)
	
	func present(playMoves wrappers: [PlayMoveWrapper])

	func display(numberOfFeathers: Int)
	
	func display(numberOfExperiencePoints: Int)
	
	func display(numberOfPoints: Int)
	
}
