//
//  PlayExperienceWrapper.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a PlayExperience model item
public class PlayExperienceWrapper {
	
	// MARK: - Private Static Stored Properties
	

	// MARK: - Public Stored Properties
	
	public var id:					    				String = ""
	public var playExperienceType:						Int = 0
	public var playLanguageID:							String = ""
	public var name:									String = ""
	public fileprivate(set) var onCompleteData:			String = ""
	public var playExperienceOnCompleteData:			PlayExperienceOnCompleteDataWrapper? = nil
	public var playExperienceResult:					PlayExperienceResultWrapper? = nil
	public fileprivate(set) var playExperiencesSteps:	[String:PlayExperienceStepWrapper]? = [String:PlayExperienceStepWrapper]()
	public fileprivate(set) var playMove:				PlayMoveWrapper? = nil
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [PlayExperienceWrapper]) -> PlayExperienceWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
	
	// MARK: - Public Methods
	
	public func dispose() {
		
		self.playExperienceOnCompleteData 	= nil
		self.playExperienceResult 			= nil
		self.playExperiencesSteps 			= nil
		self.playMove						= nil
		
	}
	
	public func set(playExperienceStepWrapper: PlayExperienceStepWrapper) {
		
		if (self.playExperiencesSteps == nil) {
			
			self.playExperiencesSteps = [String:PlayExperienceStepWrapper]()
			
		}
		
		self.playExperiencesSteps![playExperienceStepWrapper.id] = playExperienceStepWrapper
		
	}
	
	public func set(onCompleteData: String) {
		
		self.onCompleteData 				= onCompleteData
		
		// Create PlayExperienceOnCompleteDataWrapper
		self.playExperienceOnCompleteData 	= PlayExperienceOnCompleteDataWrapper(onCompleteData: onCompleteData)
		
	}
	
	public func set(playMoveWrapper: PlayMoveWrapper) {
		
		self.playMove = playMoveWrapper
		
	}
	
	public func clearPlayExperienceSteps() {
		
		guard (self.playExperiencesSteps != nil) else { return }
		
		// Go through each item
		for pesw in self.playExperiencesSteps!.values {
			
			pesw.dispose()
			
		}
		
		self.playExperiencesSteps = nil
		
	}
	
}
