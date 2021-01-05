//
//  ProtocolPlayExperienceView.swift
//  SFGame
//
//  Created by David on 16/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which is a PlayExperienceView
public protocol ProtocolPlayExperienceView {
	
	// MARK: - Stored Properties
	
	// MARK: - Methods

	func set(playExperienceWrapper: PlayExperienceWrapper)
	
	func present(playExperienceStepMarkerView view: ProtocolPlayExperienceStepMarkerView)
	
}
