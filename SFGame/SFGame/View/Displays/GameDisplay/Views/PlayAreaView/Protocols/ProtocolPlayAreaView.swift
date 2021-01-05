//
//  ProtocolPlayAreaView.swift
//  SFGame
//
//  Created by David on 10/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which is a PlayAreaView
public protocol ProtocolPlayAreaView {
	
	// MARK: - Stored Properties
	
	
	// MARK: - Methods
	
	func present(playMoves wrappers: [PlayMoveWrapper])
	
	func present(playSpaceMarkerView view: ProtocolPlaySpaceMarkerView)
	
}
