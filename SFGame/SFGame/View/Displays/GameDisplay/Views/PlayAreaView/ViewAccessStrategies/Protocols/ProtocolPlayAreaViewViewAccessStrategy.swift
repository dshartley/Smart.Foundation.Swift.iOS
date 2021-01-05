//
//  ProtocolPlayAreaViewViewAccessStrategy.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which provides a strategy for accessing the PlayAreaView view
public protocol ProtocolPlayAreaViewViewAccessStrategy {
	
	// MARK: - Methods
	
	func displayTotalNumberOfFeathers(value: Int)
	
	func displayTotalNumberOfPoints(value: Int)
	
	func present(playMoves wrappers: [PlayMoveWrapper])
	
	func present(playSpaceMarkerView view: ProtocolPlaySpaceMarkerView)
	
}
