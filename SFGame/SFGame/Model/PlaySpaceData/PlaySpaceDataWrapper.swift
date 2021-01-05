//
//  PlaySpaceDataWrapper.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a PlaySpaceData model item
public class PlaySpaceDataWrapper {
	
	// MARK: - Private Static Stored Properties
	

	// MARK: - Public Stored Properties
	
	public var id:					    		String = ""
	public var relativeMemberID:	    		String = ""
	public var playSpaceID:	    				String = ""
	public var numberOfFeathers:				Int = 0
	public var numberOfExperiencePoints: 		Int = 0
	public var numberOfPoints: 					Int = 0
	public fileprivate(set) var attributeData:	String = ""
	public var playSpaceDataAttributeData:		PlaySpaceDataAttributeDataWrapper? = nil

	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [PlaySpaceDataWrapper]) -> PlaySpaceDataWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
	
	// MARK: - Public Methods
	
	public func dispose() {
		
		self.playSpaceDataAttributeData = nil
		
	}
	
	public func set(attributeData: String) {
		
		self.attributeData 					= attributeData
		
		// Create PlaySpaceDataAttributeDataWrapper
		self.playSpaceDataAttributeData 	= PlaySpaceDataAttributeDataWrapper(attributeData: attributeData)
		
	}
	
}
