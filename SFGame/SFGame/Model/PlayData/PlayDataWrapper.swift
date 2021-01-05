//
//  PlayDataWrapper.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a PlayData model item
public class PlayDataWrapper: Codable {
	
	// MARK: - Private Static Stored Properties
	

	// MARK: - Public Stored Properties
	
	public var id:					    	String = ""
	public var applicationID:				String = ""
	public var relativeMemberID:	    	String = ""
	public var playLanguageID:				String = ""
	public var numberOfFeathers:			Int = 0
	public var numberOfExperiencePoints: 	Int = 0
	public var numberOfPoints: 				Int = 0
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [PlayDataWrapper]) -> PlayDataWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
	
	// MARK: - Public Class Methods
	
	public func dispose() {
		
		
	}
	
}
