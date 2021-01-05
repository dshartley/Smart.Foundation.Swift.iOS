//
//  ProtocolPlayExperienceViewDelegate.swift
//  f30
//
//  Created by David on 16/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a PlayExperienceView class
public protocol ProtocolPlayExperienceViewDelegate: class {
	
	// MARK: - Methods
	
	func playExperienceView(playExperienceCompleted wrapper: PlayExperienceWrapper, sender: ProtocolPlayExperienceView)
	
	func playExperienceView(presentPlayExperienceStepViewFor wrapper: PlayExperienceStepWrapper, sender: ProtocolPlayExperienceView, delegate: ProtocolPlayExperienceStepViewDelegate)
	
	func playExperienceView(closeButtonTapped sender: ProtocolPlayExperienceView)
	
	func playExperienceView(playExperienceStepViewCloseButtonTapped sender: ProtocolPlayExperienceStepView)
	
	//func playExperienceView(playExperienceStepMarkerViewTapped sender: ProtocolPlayExperienceStepMarkerView)
	
}
