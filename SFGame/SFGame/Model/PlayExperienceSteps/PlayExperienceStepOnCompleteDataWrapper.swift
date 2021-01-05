//
//  PlayExperienceStepOnCompleteDataWrapper.swift
//  SFGame
//
//  Created by David on 27/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// A wrapper for a PlayExperienceStepOnCompleteDataWrapper model item
public class PlayExperienceStepOnCompleteDataWrapper {
	
	// MARK: - Public Stored Properties
	
	public var numberOfPoints: 		Int = 0
	public var numberOfFeathers: 	Int = 0
	
	
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
		
		// NumberOfPoints
		self.numberOfPoints 	= Int(wrapper?.getParameterValue(key: "NumberOfPoints") ?? "0")!

		// NumberOfFeathers
		self.numberOfFeathers 	= Int(wrapper?.getParameterValue(key: "NumberOfFeathers") ?? "0")!
		
	}
	
}
