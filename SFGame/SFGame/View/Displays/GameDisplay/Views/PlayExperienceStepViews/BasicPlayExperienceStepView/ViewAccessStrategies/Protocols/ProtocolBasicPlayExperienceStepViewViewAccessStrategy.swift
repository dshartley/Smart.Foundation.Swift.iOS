//
//  ProtocolBasicPlayExperienceStepViewViewAccessStrategy.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a class which provides a strategy for accessing the BasicPlayExperienceStepView view
public protocol ProtocolBasicPlayExperienceStepViewViewAccessStrategy {
	
	// MARK: - Methods
	
	func display(questionText: String)
	
	func display(option1Text: String, isCorrectYN: Bool)
	
	func display(option2Text: String, isCorrectYN: Bool)
	
	func displayResult()
	
}
