//
//  PlaySpaceWrapper.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a PlaySpace model item
public class PlaySpaceWrapper {
	
	// MARK: - Private Static Stored Properties
	

	// MARK: - Public Stored Properties
	
	public var id:					    			String = ""
	public var relativeMemberID:					String = ""
	public var playAreaID:							String = ""
	public var playSpaceType:						Int = 0
	public var playLanguageID:						Int = 0
	public var coordX:								Int = 0
	public var coordY:								Int = 0
	public fileprivate(set) var playSpaceData:		PlaySpaceDataWrapper? = nil
	public fileprivate(set) var playSpaceBits:		[String:PlaySpaceBitWrapper]? = [String:PlaySpaceBitWrapper]()
	public fileprivate(set) var playMoves:			[String:PlayMoveWrapper]? = nil
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [PlaySpaceWrapper]) -> PlaySpaceWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
	
	// MARK: - Public Methods
	
	public func dispose() {
		
		self.playSpaceData 	= nil
		self.playSpaceBits 	= nil
		self.playMoves 		= nil
		
	}
	
	public func set(playSpaceDataWrapper: PlaySpaceDataWrapper) {
		
		self.playSpaceData = playSpaceDataWrapper
		
	}

	public func set(playSpaceBitWrapper: PlaySpaceBitWrapper) {

		if (self.playSpaceBits == nil) {

			self.playSpaceBits = [String:PlaySpaceBitWrapper]()

		}

		self.playSpaceBits![playSpaceBitWrapper.id] = playSpaceBitWrapper

	}

	public func set(playMoveWrapper: PlayMoveWrapper) {

		if (self.playMoves == nil) {

			self.playMoves = [String:PlayMoveWrapper]()

		}

		self.playMoves![playMoveWrapper.id] = playMoveWrapper

	}

	public func clearPlaySpaceBits() {

		guard (self.playSpaceBits != nil) else { return }

		// TODO:
		// Go through each item
//		for psbw in self.playSpaceBits!.values {
//
//		}

		self.playSpaceBits = nil

	}
	
}
