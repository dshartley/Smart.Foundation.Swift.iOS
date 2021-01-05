//
//  ProtocolPlayExperienceViewControlManagerDelegate.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a PlayExperienceViewControlManager class
public protocol ProtocolPlayExperienceViewControlManagerDelegate: class {
	
	// MARK: - Methods
	
	func playExperienceViewControlManager(playExperienceCompleted wrapper: PlayExperienceWrapper, sender: PlayExperienceViewControlManagerBase)
	
	func playExperienceViewControlManager(createPlayExperienceStepMarkerViewFor wrapper: PlayExperienceStepWrapper) -> ProtocolPlayExperienceStepMarkerView
	
}
