//
//  ProtocolPlayExperienceStepViewDelegate.swift
//  f30
//
//  Created by David on 16/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a PlayExperienceStepView class
public protocol ProtocolPlayExperienceStepViewDelegate: class {
	
	// MARK: - Methods

	func playExperienceStepView(closeButtonTapped sender: ProtocolPlayExperienceStepView)
	
	func playExperienceStepView(playExperienceStepCompleted wrapper: PlayExperienceStepWrapper, sender: ProtocolPlayExperienceStepView)
	
}
