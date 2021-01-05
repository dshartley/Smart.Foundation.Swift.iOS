//
//  PlayMoveWrapper.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a PlayMove model item
public class PlayMoveWrapper {
	
	// MARK: - Private Static Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var id:									String = ""
	public var playReferenceType: 					PlayReferenceTypes = .PlaySpaceType
	public var playReferenceID:						String = ""
	public var playReferenceActionType: 			PlayReferenceActionTypes = .AddPlaySpace
	public fileprivate(set) var onCompleteData:		String = ""
	public var playMoveOnCompleteData:				PlayMoveOnCompleteDataWrapper? = nil
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [PlayMoveWrapper]) -> PlayMoveWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
	
	// MARK: - Public Methods
	
	public func dispose() {
		
		self.playMoveOnCompleteData = nil
		
	}
	
	public func set(onCompleteData: String) {
		
		self.onCompleteData 			= onCompleteData
		
		// Create PlayMoveOnCompleteDataWrapper
		self.playMoveOnCompleteData 	= PlayMoveOnCompleteDataWrapper(onCompleteData: onCompleteData)
		
	}
	
}

