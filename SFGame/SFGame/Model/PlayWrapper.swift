//
//  PlayWrapper.swift
//  SFGame
//
//  Created by David on 24/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for Play model items
public class PlayWrapper {

	// MARK: - Private Static Stored Properties
	
	fileprivate static var _current:			PlayWrapper? = nil
	
	
	// MARK: - Public Stored Properties
	
	public var id:					    		String = ""
	public fileprivate(set) var playResult:		PlayResultWrapper = PlayResultWrapper()
	public var playData:						[String:PlayDataWrapper]? = nil
	public var playMoves:						[String:PlayMoveWrapper]? = nil
	public var playSpaceTypes:					[String:PlaySpaceTypeWrapper]? = nil
	public var playSpaces:						[String:PlaySpaceWrapper]? = nil
	public var playSpaceBitTypes:				[String:PlaySpaceBitTypeWrapper]? = nil
	public var playSpaceBits: 					[String:PlaySpaceBitWrapper]? = nil
	public var playExperiences: 				[String:PlayExperienceWrapper]? = nil
	
	
	// MARK: - Public Class Computed Properties
	
	public class var current: PlayWrapper? {
		get {
			if (PlayWrapper._current == nil) {
				
				PlayWrapper._current = PlayWrapper()
				
			}
			
			return PlayWrapper._current
		}
		set(value) {
			PlayWrapper._current = value
		}
	}
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	
	// MARK: - Public Methods
	
	public func set(wrappers: [String:Any]) {
	
		self.doSetPlayData(wrappers: wrappers)
		self.doSetPlayMoves(wrappers: wrappers)
		self.doSetPlaySpaceTypes(wrappers: wrappers)
		self.doSetPlaySpaces(wrappers: wrappers)
		self.doSetPlaySpaceData(wrappers: wrappers)
		self.doSetPlaySpaceBitTypes(wrappers: wrappers)
		self.doSetPlaySpaceBits(wrappers: wrappers)
		self.doSetPlaySpaceBitData(wrappers: wrappers)
		self.doSetPlayExperiences(wrappers: wrappers)
		self.doSetPlayExperienceSteps(wrappers: wrappers)
		self.doSetPlayMovesToPlayReference()
	}

	public func findPlayData(byPlayLanguageID playLanguageID: String) -> PlayDataWrapper? {
		
		guard (self.playData != nil) else { return nil }
		
		var result: PlayDataWrapper? = nil
		
		// Go through each item
		for pdw in self.playData!.values {
		
			if (pdw.playLanguageID == playLanguageID) {
				
				result = pdw
				
			}
			
		}
		
		return result
		
	}
	
	public func clear(playSpace wrapper: PlaySpaceWrapper) {
		
		// Clear PlaySpace
		self.doClear(playSpace: wrapper)

	}
	
	
	// MARK: - Private Methods
	
	fileprivate func doSetPlayData(wrappers: [String:Any]) {
		
		if (self.playData == nil) {
			
			self.playData = [String:PlayDataWrapper]()
			
		}
		
		// Get playDataWrappers
		if let playDataWrappers = wrappers["PlayData"] as? [PlayDataWrapper] {
			
			// Go through each item
			for pdw in playDataWrappers {
				
				// Add to dictionary
				self.playData![pdw.id] = pdw
				
			}
			
		}
		
	}

	fileprivate func doSetPlayMoves(wrappers: [String:Any]) {
		
		if (self.playMoves == nil) {
			
			self.playMoves = [String:PlayMoveWrapper]()
			
		}
		
		// Get playMoveWrappers
		if let playMoveWrappers = wrappers["PlayMoves"] as? [PlayMoveWrapper] {
			
			// Go through each item
			for pmw in playMoveWrappers {
				
				// Add to dictionary
				self.playMoves![pmw.id] = pmw
				
			}
			
		}
		
	}
	
	fileprivate func doSetPlaySpaceTypes(wrappers: [String:Any]) {
		
		if (self.playSpaceTypes == nil) {
			
			self.playSpaceTypes = [String:PlaySpaceTypeWrapper]()
			
		}
		
		// Get playSpaceTypeWrappers
		if let playSpaceTypeWrappers = wrappers["PlaySpaceTypes"] as? [PlaySpaceTypeWrapper] {
			
			// Go through each item
			for pstw in playSpaceTypeWrappers {
				
				// Add to dictionary
				self.playSpaceTypes![pstw.id] = pstw
				
			}
			
		}

	}
	
	fileprivate func doSetPlaySpaces(wrappers: [String:Any]) {
		
		if (self.playSpaces == nil) {
			
			self.playSpaces = [String:PlaySpaceWrapper]()
			
		}
		
		// Get playSpaceWrappers
		if let playSpaceWrappers = wrappers["PlaySpaces"] as? [PlaySpaceWrapper] {
		
			// Go through each item
			for psw in playSpaceWrappers {
				
				// Add to dictionary
				self.playSpaces![psw.id] = psw
				
			}
			
		}
		
	}

	fileprivate func doSetPlaySpaceData(wrappers: [String:Any]) {
		
		// Get playSpaceDataWrappers
		if let playSpaceDataWrappers = wrappers["PlaySpaceData"] as? [PlaySpaceDataWrapper] {
			
			// Go through each item
			for psdw in playSpaceDataWrappers {
				
				// Get PlaySpaceWrapper
				if let psw = self.playSpaces?[psdw.playSpaceID] {
					
					psw.set(playSpaceDataWrapper: psdw)
					
				}
				
			}
			
		}
		
	}
	
	fileprivate func doSetPlaySpaceBitTypes(wrappers: [String:Any]) {
		
		if (self.playSpaceBitTypes == nil) {
			
			self.playSpaceBitTypes = [String:PlaySpaceBitTypeWrapper]()
			
		}
		
		// Get playSpaceBitTypeWrappers
		if let playSpaceBitTypeWrappers = wrappers["PlaySpaceBitTypes"] as? [PlaySpaceBitTypeWrapper] {
			
			// Go through each item
			for psbtw in playSpaceBitTypeWrappers {
				
				// Add to dictionary
				self.playSpaceBitTypes![psbtw.id] = psbtw
				
			}
			
		}
		
	}
	
	fileprivate func doSetPlaySpaceBits(wrappers: [String:Any]) {
		
		if (self.playSpaceBits == nil) {
			
			self.playSpaceBits = [String:PlaySpaceBitWrapper]()
			
		}
		
		// Get playSpaceBitWrappers
		if let playSpaceBitWrappers = wrappers["PlaySpaceBits"] as? [PlaySpaceBitWrapper] {
			
			// Go through each item
			for psbw in playSpaceBitWrappers {
				
				// Add to dictionary
				self.playSpaceBits![psbw.id] = psbw
				
				// Get PlaySpaceWrapper
				if let psw = self.playSpaces?[psbw.playSpaceID] {
					
					psw.set(playSpaceBitWrapper: psbw)
					
				}
				
			}
			
		}
		
	}
	
	fileprivate func doSetPlaySpaceBitData(wrappers: [String:Any]) {
		
		// Get playSpaceBitDataWrappers
		if let playSpaceBitDataWrappers = wrappers["PlaySpaceBitData"] as? [PlaySpaceBitDataWrapper] {
			
			// Go through each item
			for psbdw in playSpaceBitDataWrappers {
				
				// Get PlaySpaceBitWrapper
				if let psbw = self.playSpaceBits?[psbdw.playSpaceBitID] {
					
					psbw.set(playSpaceBitDataWrapper: psbdw)
					
				}
				
			}
			
		}
		
	}
	
	fileprivate func doSetPlayExperiences(wrappers: [String:Any]) {
		
		if (self.playExperiences == nil) {
			
			self.playExperiences = [String:PlayExperienceWrapper]()
			
		}

		// PlayExperiences
		if let playExperienceWrappers = wrappers["PlayExperiences"] as? [PlayExperienceWrapper] {

			// Go through each item
			for pew in playExperienceWrappers {
				
				// Add to dictionary
				self.playExperiences![pew.id] = pew
				
			}
			
		}
		
	}
	
	fileprivate func doSetPlayExperienceSteps(wrappers: [String:Any]) {
		
		// Get playExperienceStepWrappers
		if let playExperienceStepWrappers = wrappers["PlayExperienceSteps"] as? [PlayExperienceStepWrapper] {
			
			// Go through each item
			for pesw in playExperienceStepWrappers {
				
				// Get PlayExperienceWrapper
				if let pew = self.playExperiences?[pesw.playExperienceID] {
					
					pew.set(playExperienceStepWrapper: pesw)
					
				}
				
			}
			
		}
		
	}
	
	fileprivate func doSetPlayMovesToPlayReference() {
		
		// Get playMoveWrappers
		if let playMoveWrappers = self.playMoves?.values {
			
			// Go through each item
			for pmw in playMoveWrappers {
				
				// Check playReferenceType
				switch pmw.playReferenceType {
					
				case .PlaySpaceType:
					
					// Get PlaySpaceTypeWrapper
					if let pstw = self.playSpaceTypes?[pmw.playReferenceID] {
						
						pstw.set(playMoveWrapper: pmw)
						
					}
					
				case .PlaySpace:
					
					// Get PlaySpaceWrapper
					if let psw = self.playSpaces?[pmw.playReferenceID] {
						
						psw.set(playMoveWrapper: pmw)
						
					}
					
				case .PlaySpaceBitType:
					
					// Get PlaySpaceBitTypeWrapper
					if let psbtw = self.playSpaceBitTypes?[pmw.playReferenceID] {
						
						psbtw.set(playMoveWrapper: pmw)
						
					}
					
				case .PlaySpaceBit:
					
					// Get PlaySpaceBitWrapper
					if let psbw = self.playSpaceBits?[pmw.playReferenceID] {
						
						psbw.set(playMoveWrapper: pmw)
						
					}

				}
			
			}
			
		}
		
	}
	
	fileprivate func doClear(playSpace wrapper: PlaySpaceWrapper) {
		
		// Check playSpaceBits
		if (wrapper.playSpaceBits != nil) {
			
			// Go through each item
			for psbw in wrapper.playSpaceBits! {
				
				// Clear PlaySpaceBit
				self.doClear(playSpaceBit: psbw.value)
				
				// Remove PlaySpaceBit
				self.playSpaceBits?.removeValue(forKey: psbw.key)
				
			}
			
		}
		
	}
	
	fileprivate func doClear(playSpaceBit wrapper: PlaySpaceBitWrapper) {
		
		// TODO:
		
	}
}
