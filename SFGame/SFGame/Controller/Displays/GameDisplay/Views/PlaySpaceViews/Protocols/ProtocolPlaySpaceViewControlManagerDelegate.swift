//
//  ProtocolPlaySpaceViewControlManagerDelegate.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a PlaySpaceViewControlManager class
public protocol ProtocolPlaySpaceViewControlManagerDelegate: class {
	
	// MARK: - Methods
	
	func playSpaceViewControlManager(isNotConnected error: Error?)
	
	func playSpaceViewControlManager(createPlaySpaceBitViewFor wrapper: PlaySpaceBitWrapper) -> ProtocolPlaySpaceBitView

	func playSpaceViewControlManager(playSpaceDataChanged wrapper: PlaySpaceWrapper)
	
}
