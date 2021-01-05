//
//  BasicPlayExperienceStepViewViewAccessStrategy.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// A strategy for accessing the BasicPlayExperienceStepView view
public class BasicPlayExperienceStepViewViewAccessStrategy {
	
	// MARK: - Private Stored Properties

	fileprivate var questionTextLabel: 	UILabel!
	fileprivate var option1Button: 		UIButton!
	fileprivate var option2Button: 		UIButton!
	fileprivate var resultLabel: 		UILabel!
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setup(questionTextLabel: UILabel,
					  option1Button: UIButton,
					  option2Button: UIButton,
					  resultLabel: UILabel) {

		self.questionTextLabel 	= questionTextLabel
		self.option1Button 		= option1Button
		self.option2Button 		= option2Button
		self.resultLabel 		= resultLabel
		
	}
	
}

// MARK: - Extension ProtocolBasicPlayExperienceStepViewViewAccessStrategy

extension BasicPlayExperienceStepViewViewAccessStrategy: ProtocolBasicPlayExperienceStepViewViewAccessStrategy {
	
	// MARK: - Methods
	
	public func display(questionText: String) {
		
		self.questionTextLabel.text = questionText
		
	}
	
	public func display(option1Text: String, isCorrectYN: Bool) {
		
		// Create identifier
		let identifier: 		DataJSONWrapper = DataJSONWrapper()
		identifier.ID 			= "1"
		identifier.setParameterValue(key: "IsCorrectYN", value: "\(isCorrectYN)")
		
		let identifierString: 	String? = JSONHelper.SerializeDataJSONWrapper(dataWrapper: identifier)
		
		self.option1Button.setTitle(option1Text, for: .normal)
		self.option1Button.accessibilityIdentifier = identifierString
		
	}
	
	public func display(option2Text: String, isCorrectYN: Bool) {
		
		// Create identifier
		let identifier: 		DataJSONWrapper = DataJSONWrapper()
		identifier.ID 			= "2"
		identifier.setParameterValue(key: "IsCorrectYN", value: "\(isCorrectYN)")
		
		let identifierString: 	String? = JSONHelper.SerializeDataJSONWrapper(dataWrapper: identifier)
		
		self.option2Button.setTitle(option2Text, for: .normal)
		self.option2Button.accessibilityIdentifier = identifierString
		
	}

	public func displayResult() {
		
		self.resultLabel.alpha = 1
		
	}
	
}

// MARK: - Extension ProtocolPlayExperienceStepViewViewAccessStrategy

extension BasicPlayExperienceStepViewViewAccessStrategy: ProtocolPlayExperienceStepViewViewAccessStrategy {
	
	// MARK: - Methods
	
}
