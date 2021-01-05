//
//  ProtocolPlayExperienceStepMarkerViewDelegate.swift
//  SFGame
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a PlayExperienceStepMarkerView class
public protocol ProtocolPlayExperienceStepMarkerViewDelegate: class {
	
	// MARK: - Methods
	
	func playExperienceStepMarkerView(tapped wrapper: PlayExperienceStepWrapper, sender: ProtocolPlayExperienceStepMarkerView)
	
}
