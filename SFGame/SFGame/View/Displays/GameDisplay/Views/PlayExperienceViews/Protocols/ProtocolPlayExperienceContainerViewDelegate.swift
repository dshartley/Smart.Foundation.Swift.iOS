//
//  ProtocolPlayExperienceContainerViewDelegate.swift
//  SFGame
//
//  Created by David on 11/10/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a PlayExperienceContainerView class
public protocol ProtocolPlayExperienceContainerViewDelegate: class {
	
	// MARK: - Methods
	
	func playExperienceContainerView(startExperienceFor playMoveWrapper: PlayMoveWrapper, delegate: ProtocolPlayExperienceViewDelegate)
	
}
