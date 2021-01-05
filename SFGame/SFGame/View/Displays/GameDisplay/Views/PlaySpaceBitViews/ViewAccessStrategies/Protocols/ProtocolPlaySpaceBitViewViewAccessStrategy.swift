//
//  ProtocolPlaySpaceBitViewViewAccessStrategy.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which provides a strategy for accessing the PlaySpaceBitView view
public protocol ProtocolPlaySpaceBitViewViewAccessStrategy {
	
	// MARK: - Methods
	
	func display(numberOfFeathers: Int)
	
	func display(numberOfExperiencePoints: Int)
	
	func display(numberOfPoints: Int)
	
}
