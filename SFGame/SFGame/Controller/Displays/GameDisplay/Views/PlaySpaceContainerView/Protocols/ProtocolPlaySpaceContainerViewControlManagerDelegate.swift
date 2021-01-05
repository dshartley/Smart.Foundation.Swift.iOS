//
//  ProtocolPlaySpaceContainerViewControlManagerDelegate.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a PlaySpaceContainerViewControlManager class
public protocol ProtocolPlaySpaceContainerViewControlManagerDelegate: class {
	
	// MARK: - Methods

	func playSpaceContainerViewControlManager(isNotConnected error: Error?)
	
}
