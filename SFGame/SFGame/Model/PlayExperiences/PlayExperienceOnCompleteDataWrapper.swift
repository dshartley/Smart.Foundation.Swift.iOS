//
//  PlayExperienceOnCompleteDataWrapper.swift
//  SFGame
//
//  Created by David on 27/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// A wrapper for a PlayExperienceOnCompleteDataWrapper model item
public class PlayExperienceOnCompleteDataWrapper {
	
	// MARK: - Public Stored Properties
	
	public var numberOfExperiencePoints: 	Int = 0
	
	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}
	
	public init(onCompleteData: String) {
		
		self.set(onCompleteData: onCompleteData)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func set(onCompleteData: String) {
		
		guard (onCompleteData.count > 0) else { return }
		
		// Get DataJSONWrapper from onCompleteData
		let wrapper: DataJSONWrapper? = JSONHelper.DeserializeDataJSONWrapper(dataString: onCompleteData)
		
		guard (wrapper != nil) else { return }
		
		// NumberOfExperiencePoints
		self.numberOfExperiencePoints = Int(wrapper?.getParameterValue(key: "NumberOfExperiencePoints") ?? "0")!
		
	}
	
}
