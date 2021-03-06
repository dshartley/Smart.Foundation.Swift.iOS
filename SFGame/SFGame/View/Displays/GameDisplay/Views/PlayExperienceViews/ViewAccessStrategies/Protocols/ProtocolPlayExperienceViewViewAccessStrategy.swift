//
//  ProtocolPlayExperienceViewViewAccessStrategy.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which provides a strategy for accessing the PlayExperienceView view
public protocol ProtocolPlayExperienceViewViewAccessStrategy {
	
	// MARK: - Methods

	func present(playExperienceStepMarkerView view: ProtocolPlayExperienceStepMarkerView)
	
}
