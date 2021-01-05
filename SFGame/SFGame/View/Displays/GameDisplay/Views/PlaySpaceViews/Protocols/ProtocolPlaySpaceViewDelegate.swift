//
//  ProtocolPlaySpaceView.swift
//  SFGame
//
//  Created by David on 16/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a PlaySpaceView class
public protocol ProtocolPlaySpaceViewDelegate: class {
	
	// MARK: - Methods

	func playSpaceView(playSpaceDataChanged wrapper: PlaySpaceWrapper, sender: ProtocolPlaySpaceView)
	
}
