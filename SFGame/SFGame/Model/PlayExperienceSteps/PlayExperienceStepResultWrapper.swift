//
//  PlayExperienceStepResultWrapper.swift
//  SFGame
//
//  Created by David on 22/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// A wrapper for a PlayExperienceStepResult model item
public class PlayExperienceStepResultWrapper {

	// MARK: - Public Stored Properties
	
	public var playExperienceID:		String = ""
	public var playExperienceStepID:	String = ""
	public var numberOfPoints: 			Int = 0
	public var numberOfFeathers: 		Int = 0
	public var dateCompleted:			Date = Date()
	public var repeatedYN:				Bool = false

	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func copyToWrapper() -> DataJSONWrapper {
		
		let outputDateFormatter: DateFormatter = DateFormatter()
		
		let result: 	DataJSONWrapper = DataJSONWrapper()
		
		result.setParameterValue(key: "PlayExperienceID", value: self.playExperienceID)
		result.setParameterValue(key: "PlayExperienceStepID", value: self.playExperienceStepID)
		result.setParameterValue(key: "DateCompleted", value: outputDateFormatter.string(from: self.dateCompleted))
		result.setParameterValue(key: "RepeatedYN", value: "\(self.repeatedYN)")
		
		return result
	}
	
}
