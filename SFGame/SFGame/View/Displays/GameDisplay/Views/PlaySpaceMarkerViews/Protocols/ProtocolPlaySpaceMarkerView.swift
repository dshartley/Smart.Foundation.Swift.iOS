//
//  ProtocolPlaySpaceMarkerView.swift
//  SFGame
//
//  Created by David on 15/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which is a PlaySpaceMarkerView
public protocol ProtocolPlaySpaceMarkerView {
	
	// MARK: - Stored Properties
	
	// MARK: - Methods
	
	func set(playSpaceWrapper: PlaySpaceWrapper)
	
	func refresh(playSpaceWrapper: PlaySpaceWrapper)
	
	func coordX() -> Int
	
	func coordY() -> Int

	func getWrapper() -> PlaySpaceWrapper?
	
}
