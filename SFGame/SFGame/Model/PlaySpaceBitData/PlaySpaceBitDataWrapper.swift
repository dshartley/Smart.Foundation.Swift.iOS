//
//  PlaySpaceBitDataWrapper.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a PlaySpaceBitData model item
public class PlaySpaceBitDataWrapper {
	
	// MARK: - Private Static Stored Properties
	

	// MARK: - Public Stored Properties
	
	public var id:					    		String = ""
	public var relativeMemberID:				String = ""
	public var playSpaceBitID:					String = ""
	public var numberOfFeathers:				Int = 0
	public var numberOfExperiencePoints: 		Int = 0
	public var numberOfPoints: 					Int = 0
	public fileprivate(set) var attributeData:	String = ""
	public var playSpaceBitDataAttributeData:	PlaySpaceBitDataAttributeDataWrapper? = nil
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [PlaySpaceBitDataWrapper]) -> PlaySpaceBitDataWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
	
	// MARK: - Public Methods
	
	public func dispose() {
		
		self.playSpaceBitDataAttributeData = nil
		
	}
	
	public func set(attributeData: String) {
		
		self.attributeData 					= attributeData
		
		// Create PlaySpaceBitDataAttributeDataWrapper
		self.playSpaceBitDataAttributeData 	= PlaySpaceBitDataAttributeDataWrapper(attributeData: attributeData)
		
	}
	
	public func refreshAttributeDataString() {
		
		if (self.playSpaceBitDataAttributeData != nil) {
			
			self.attributeData = self.playSpaceBitDataAttributeData!.toString()
			
		} else {
			
			self.attributeData = ""
			
		}
		
	}
}
