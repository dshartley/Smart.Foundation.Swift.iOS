//
//  ProtocolPlayAreaViewControlManagerDelegate.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a PlayAreaViewControlManager class
public protocol ProtocolPlayAreaViewControlManagerDelegate: class {
	
	// MARK: - Methods
	
	func playAreaViewControlManager(isNotConnected error: Error?)
	
	func playAreaViewControlManager(createPlaySpaceMarkerViewFor wrapper: PlaySpaceWrapper) -> ProtocolPlaySpaceMarkerView?
	
}
