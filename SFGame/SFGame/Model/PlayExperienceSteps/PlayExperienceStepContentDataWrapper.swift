//
//  PlayExperienceStepContentDataWrapper.swift
//  SFGame
//
//  Created by David on 05/10/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// A wrapper for a PlayExperienceStepContentDataWrapper model item
public class PlayExperienceStepContentDataWrapper {
	
	// MARK: - Private Stored Properties
	
	fileprivate var wrapper: DataJSONWrapper?
	
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}
	
	public init(contentData: String) {
		
		self.set(contentData: contentData)
		
	}
	
	
	// MARK: - Public Methods
	
	public func get(key: String) -> String? {
		
		guard (wrapper != nil) else { return nil }
		
		return wrapper!.getParameterValue(key: key)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func set(contentData: String) {
		
		guard (contentData.count > 0) else { return }
		
		// Get DataJSONWrapper from contentData
		self.wrapper = JSONHelper.DeserializeDataJSONWrapper(dataString: contentData)
		
		guard (self.wrapper != nil) else { return }
		
	}
	
}
