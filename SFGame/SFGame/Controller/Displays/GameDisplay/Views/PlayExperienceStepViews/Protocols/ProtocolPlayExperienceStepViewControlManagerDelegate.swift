//
//  ProtocolPlayExperienceStepViewControlManagerDelegate.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a PlayExperienceStepViewControlManager class
public protocol ProtocolPlayExperienceStepViewControlManagerDelegate: class {
	
	// MARK: - Methods
	
	func playExperienceStepViewControlManager(playExperienceStepCompleted wrapper: PlayExperienceStepWrapper)
	
}
