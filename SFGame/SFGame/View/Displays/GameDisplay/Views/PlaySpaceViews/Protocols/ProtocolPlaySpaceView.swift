//
//  ProtocolPlaySpaceView.swift
//  SFGame
//
//  Created by David on 16/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which is a PlaySpaceView
public protocol ProtocolPlaySpaceView {
	
	// MARK: - Stored Properties
	
	// MARK: - Methods
	
	func set(playSpaceWrapper: PlaySpaceWrapper, wrappers: [String:Any])
	
	func present(playSpaceBitView view: ProtocolPlaySpaceBitView)
	
	func present(playMoves wrappers: [PlayMoveWrapper])

}
