//
//  PlayResultWrapper.swift
//  SFGame
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// A wrapper for a PlayResult model item
public class PlayResultWrapper {
	
	// MARK: - Private Static Stored Properties
	
	fileprivate var playDataWrappers: 					[PlayDataWrapper] = [PlayDataWrapper]()
	fileprivate var playSpaceWrappers: 					[PlaySpaceWrapper] = [PlaySpaceWrapper]()
	fileprivate var playSpaceDataWrappers: 				[PlaySpaceDataWrapper] = [PlaySpaceDataWrapper]()
	fileprivate var playSpaceBitWrappers: 				[PlaySpaceBitWrapper] = [PlaySpaceBitWrapper]()
	fileprivate var playSpaceBitDataWrappers: 			[PlaySpaceBitDataWrapper] = [PlaySpaceBitDataWrapper]()
	fileprivate var playExperienceStepResultWrappers: 	[PlayExperienceStepResultWrapper] = [PlayExperienceStepResultWrapper]()
	

	// MARK: - Public Stored Properties
	
	public var id: 									String = ""
	public var playDataJSON: 						String = ""
	public var playSpacesJSON: 						String = ""
	public var playSpaceDataJSON: 					String = ""
	public var playSpaceBitsJSON: 					String = ""
	public var playSpaceBitDataJSON: 				String = ""
	public var playExperienceStepResultsJSON: 		String = ""
	
	
	// MARK: - Initializers
	
	public init() {
		
	}

	
	// MARK: - Public Methods

	public func dispose() {
		
	}
	
	public func clear() {
		
		self.playDataWrappers.removeAll()
		self.playSpaceWrappers.removeAll()
		self.playSpaceDataWrappers.removeAll()
		self.playSpaceBitWrappers.removeAll()
		self.playSpaceBitDataWrappers.removeAll()
		self.playExperienceStepResultWrappers.removeAll()
		
		self.playDataJSON 					= ""
		self.playSpacesJSON 				= ""
		self.playSpaceDataJSON 				= ""
		self.playSpaceBitsJSON 				= ""
		self.playSpaceBitDataJSON 			= ""
		self.playExperienceStepResultsJSON 	= ""
	}
	
	public func generateJSON() {

		self.doPlayDataWrappersToJSON()
		self.doPlaySpaceWrappersToJSON()
		self.doPlaySpaceDataWrappersToJSON()
		self.doPlaySpaceBitWrappersToJSON()
		self.doPlaySpaceBitDataWrappersToJSON()
		self.doPlayExperienceStepResultWrappersToJSON()
		
	}
	
	public func set(playDataWrapper: PlayDataWrapper) {
		
		self.playDataWrappers.append(playDataWrapper)
		
	}
	
	public func set(playSpaceWrapper: PlaySpaceWrapper) {
		
		self.playSpaceWrappers.append(playSpaceWrapper)
		
	}

	public func set(playSpaceDataWrapper: PlaySpaceDataWrapper) {
		
		self.playSpaceDataWrappers.append(playSpaceDataWrapper)
		
	}
	
	public func set(playSpaceBitWrapper: PlaySpaceBitWrapper) {
		
		self.playSpaceBitWrappers.append(playSpaceBitWrapper)
		
	}
	
	public func set(playSpaceBitDataWrapper: PlaySpaceBitDataWrapper) {
		
		self.playSpaceBitDataWrappers.append(playSpaceBitDataWrapper)
		
	}
	
	public func set(playExperienceStepResultWrapper: PlayExperienceStepResultWrapper) {
		
		self.playExperienceStepResultWrappers.append(playExperienceStepResultWrapper)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func doPlayDataWrappersToJSON() {
		
		// Create DataJSONWrapper for collection of items
		let jsonItems: 		DataJSONWrapper = DataJSONWrapper()
		jsonItems.ID 		= "PlayData"
		
		// Convert playDataWrappers to JSON
		let collection: 	PlayDataCollection = PlayDataCollection()
		
		// Go through each item
		for pdw in self.playDataWrappers {
			
			// Create the model item from the wrapper
			let item: 		PlayData = collection.addItem() as! PlayData
			item.clone(fromWrapper: pdw)
			
			// Create DataJSONWrapper from item
			let jsonItem: 	DataJSONWrapper = item.copyToWrapper()
			
			jsonItems.Items.append(jsonItem)
			
		}
		
		self.playDataJSON 	= JSONHelper.SerializeDataJSONWrapper(dataWrapper: jsonItems)!
		
	}
	
	fileprivate func doPlaySpaceWrappersToJSON() {
		
		// Create DataJSONWrapper for collection of items
		let jsonItems: 		DataJSONWrapper = DataJSONWrapper()
		jsonItems.ID 		= "PlaySpaces"
		
		// Convert playSpaceWrappers to JSON
		let collection: 	PlaySpaceCollection = PlaySpaceCollection()
		
		// Go through each item
		for psw in self.playSpaceWrappers {
			
			// Create the model item from the wrapper
			let item: 		PlaySpace = collection.addItem() as! PlaySpace
			item.clone(fromWrapper: psw)
			
			// Create DataJSONWrapper from item
			let jsonItem: 	DataJSONWrapper = item.copyToWrapper()
			
			jsonItems.Items.append(jsonItem)
			
		}
		
		self.playSpacesJSON = JSONHelper.SerializeDataJSONWrapper(dataWrapper: jsonItems)!
		
	}
	
	fileprivate func doPlaySpaceDataWrappersToJSON() {
		
		// Create DataJSONWrapper for collection of items
		let jsonItems: 		DataJSONWrapper = DataJSONWrapper()
		jsonItems.ID 		= "PlaySpaceData"
		
		// Convert playSpaceDataWrappers to JSON
		let collection: 	PlaySpaceDataCollection = PlaySpaceDataCollection()
		
		// Go through each item
		for psdw in self.playSpaceDataWrappers {
			
			// Create the model item from the wrapper
			let item: 		PlaySpaceData = collection.addItem() as! PlaySpaceData
			item.clone(fromWrapper: psdw)
			
			// Create DataJSONWrapper from item
			let jsonItem: 	DataJSONWrapper = item.copyToWrapper()
			
			jsonItems.Items.append(jsonItem)
			
		}
		
		self.playSpaceDataJSON = JSONHelper.SerializeDataJSONWrapper(dataWrapper: jsonItems)!
		
	}
	
	fileprivate func doPlaySpaceBitWrappersToJSON() {
		
		// Create DataJSONWrapper for collection of items
		let jsonItems: 		DataJSONWrapper = DataJSONWrapper()
		jsonItems.ID 		= "PlaySpaceBits"
		
		// Convert playSpaceBitWrappers to JSON
		let collection: 	PlaySpaceBitCollection = PlaySpaceBitCollection()
		
		// Go through each item
		for psbw in self.playSpaceBitWrappers {
			
			// Create the model item from the wrapper
			let item: 		PlaySpaceBit = collection.addItem() as! PlaySpaceBit
			item.clone(fromWrapper: psbw)
			
			// Create DataJSONWrapper from item
			let jsonItem: 	DataJSONWrapper = item.copyToWrapper()
			
			jsonItems.Items.append(jsonItem)
			
		}
		
		self.playSpaceBitsJSON = JSONHelper.SerializeDataJSONWrapper(dataWrapper: jsonItems)!
		
	}
	
	fileprivate func doPlaySpaceBitDataWrappersToJSON() {
		
		// Create DataJSONWrapper for collection of items
		let jsonItems: 		DataJSONWrapper = DataJSONWrapper()
		jsonItems.ID 		= "PlaySpaceBitData"
		
		// Convert playSpaceBitDataWrappers to JSON
		let collection: 	PlaySpaceBitDataCollection = PlaySpaceBitDataCollection()
		
		// Go through each item
		for psbdw in self.playSpaceBitDataWrappers {
			
			// Create the model item from the wrapper
			let item: 		PlaySpaceBitData = collection.addItem() as! PlaySpaceBitData
			item.clone(fromWrapper: psbdw)
			
			// Create DataJSONWrapper from item
			let jsonItem: 	DataJSONWrapper = item.copyToWrapper()
			
			jsonItems.Items.append(jsonItem)
			
		}
		
		self.playSpaceBitDataJSON = JSONHelper.SerializeDataJSONWrapper(dataWrapper: jsonItems)!
		
	}
	
	fileprivate func doPlayExperienceStepResultWrappersToJSON() {
		
		// Create DataJSONWrapper for collection of items
		let jsonItems: 		DataJSONWrapper = DataJSONWrapper()
		jsonItems.ID 		= "PlayExperienceStepResults"
		
		// Go through each item
		for pesrw in self.playExperienceStepResultWrappers {
			
			// Create DataJSONWrapper from item
			let jsonItem: 	DataJSONWrapper = pesrw.copyToWrapper()
			
			jsonItems.Items.append(jsonItem)
			
		}
		
		self.playExperienceStepResultsJSON = JSONHelper.SerializeDataJSONWrapper(dataWrapper: jsonItems)!
		
	}
	
}
