//
//  PlaySpaceBitTypeWrapper.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a PlaySpaceBitType model item
public class PlaySpaceBitTypeWrapper {
	
	// MARK: - Private Static Stored Properties
	

	// MARK: - Public Stored Properties
	
	public var id:							String = ""
	public var playSpaceBitType:			Int = 0
	public var name:						String = ""
	public fileprivate(set) var playMoves:	[String:PlayMoveWrapper]? = nil
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [PlaySpaceBitTypeWrapper]) -> PlaySpaceBitTypeWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
	
	// MARK: - Public Methods
	
	public func dispose() {
		
		self.playMoves = nil
		
	}
	
	public func set(playMoveWrapper: PlayMoveWrapper) {
		
		if (self.playMoves == nil) {
			
			self.playMoves = [String:PlayMoveWrapper]()
			
		}
		
		self.playMoves![playMoveWrapper.id] = playMoveWrapper
		
	}
	
}
