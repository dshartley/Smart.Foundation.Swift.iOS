//
//  BasicPlayExperienceStepViewViewManager.swift
//  SFGame
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView

/// Manages the BasicPlayExperienceStepView view layer
public class BasicPlayExperienceStepViewViewManager: PlayExperienceStepViewViewManagerBase {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Initializers
	
	fileprivate override init() {
		super.init()
	}
	
	public override init(viewAccessStrategy: ProtocolPlayExperienceStepViewViewAccessStrategy) {
		super.init(viewAccessStrategy: viewAccessStrategy)
		
	}
	
	
	// MARK: - Public Methods
	
	public func display(questionText: String) {
		
		if let viewAccessStrategy = self.viewAccessStrategy as? ProtocolBasicPlayExperienceStepViewViewAccessStrategy {
			
			viewAccessStrategy.display(questionText: questionText)
			
		}
		
	}
	
	public func display(option1Text: String, isCorrectYN: Bool) {
		
		if let viewAccessStrategy = self.viewAccessStrategy as? ProtocolBasicPlayExperienceStepViewViewAccessStrategy {
			
			viewAccessStrategy.display(option1Text: option1Text, isCorrectYN: isCorrectYN)
			
		}
		
	}
	
	public func display(option2Text: String, isCorrectYN: Bool) {
		
		if let viewAccessStrategy = self.viewAccessStrategy as? ProtocolBasicPlayExperienceStepViewViewAccessStrategy {
			
			viewAccessStrategy.display(option2Text: option2Text, isCorrectYN: isCorrectYN)
			
		}
		
	}
	
	public func displayResult() {

		if let viewAccessStrategy = self.viewAccessStrategy as? ProtocolBasicPlayExperienceStepViewViewAccessStrategy {
			
			viewAccessStrategy.displayResult()
			
		}
		
	}
	
}
