//
//  ProtocolPlaySpaceBitView.swift
//  SFGame
//
//  Created by David on 15/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which is a PlaySpaceBitView
public protocol ProtocolPlaySpaceBitView {
	
	// MARK: - Stored Properties
	
	// MARK: - Methods
	
	func set(playSpaceBitWrapper: PlaySpaceBitWrapper)
	
	func refresh()
	
	func coordX() -> Int
	
	func coordY() -> Int

	func getWrapper() -> PlaySpaceBitWrapper?
	
}
