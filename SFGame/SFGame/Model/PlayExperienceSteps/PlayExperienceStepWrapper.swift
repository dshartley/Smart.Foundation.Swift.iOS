//
//  PlayExperienceStepWrapper.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a PlayExperienceStep model item
public class PlayExperienceStepWrapper {
	
	// MARK: - Private Static Stored Properties
	

	// MARK: - Public Stored Properties
	
	public var id:					    			String = ""
	public var playExperienceID:					String = ""
	public var playExperienceStepType:				Int = 0
	public var playLanguageID:						String = ""
	public fileprivate(set) var contentData:		String = ""
	public var playExperienceStepContentData:		PlayExperienceStepContentDataWrapper? = nil
	public fileprivate(set) var onCompleteData:		String = ""
	public var playExperienceStepOnCompleteData:	PlayExperienceStepOnCompleteDataWrapper? = nil
	public var playExperienceStepResult:			PlayExperienceStepResultWrapper? = nil
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [PlayExperienceStepWrapper]) -> PlayExperienceStepWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
	
	// MARK: - Public Methods
	
	public func dispose() {
		
		self.playExperienceStepContentData 		= nil
		self.playExperienceStepOnCompleteData 	= nil
		self.playExperienceStepResult 			= nil
		
	}
	
	public func set(contentData: String) {
		
		self.contentData 					= contentData
		
		// Create PlayExperienceStepContentDataWrapper
		self.playExperienceStepContentData 	= PlayExperienceStepContentDataWrapper(contentData: contentData)
		
	}
	
	public func set(onCompleteData: String) {
		
		self.onCompleteData 					= onCompleteData
		
		// Create PlayExperienceStepOnCompleteDataWrapper
		self.playExperienceStepOnCompleteData 	= PlayExperienceStepOnCompleteDataWrapper(onCompleteData: onCompleteData)
		
	}
	
}
