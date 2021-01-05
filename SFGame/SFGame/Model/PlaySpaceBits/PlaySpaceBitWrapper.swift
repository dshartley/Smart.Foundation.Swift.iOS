//
//  PlaySpaceBitWrapper.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a PlaySpaceBit model item
public class PlaySpaceBitWrapper {
	
	// MARK: - Private Static Stored Properties
	

	// MARK: - Public Stored Properties
	
	public var id:					    			String = ""
	public var relativeMemberID:					String = ""
	public var playSpaceID:							String = ""
	public var playSpaceBitType:					Int = 0
	public var coordX:								Int = 0
	public var coordY:								Int = 0
	public fileprivate(set) var playSpaceBitData:	PlaySpaceBitDataWrapper? = nil
	public fileprivate(set) var playMoves:			[String:PlayMoveWrapper]? = nil

	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [PlaySpaceBitWrapper]) -> PlaySpaceBitWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	

	// MARK: - Public Methods
	
	public func dispose() {
		
		self.playSpaceBitData 	= nil
		self.playMoves 			= nil
		
	}
	
	public func set(playSpaceBitDataWrapper: PlaySpaceBitDataWrapper) {
		
		self.playSpaceBitData = playSpaceBitDataWrapper
		
	}
	
	public func set(playMoveWrapper: PlayMoveWrapper) {
		
		if (self.playMoves == nil) {
			
			self.playMoves = [String:PlayMoveWrapper]()
			
		}
		
		self.playMoves![playMoveWrapper.id] = playMoveWrapper
		
	}
	
}
