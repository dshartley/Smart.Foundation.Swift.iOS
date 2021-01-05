//
//  PlayMove.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlayMoveDataParameterKeys {
	case ID
	case PlayReferenceType
	case PlayReferenceID
	case PlayReferenceActionType
	case OnCompleteData
}

/// Encapsulates a PlayMove model item
public class PlayMove: ModelItemBase {
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(collection: ProtocolModelItemCollection,
						 storageDateFormatter: DateFormatter) {
		super.init(collection: collection,
				   storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods
	
	let playreferencetypeKey: String = "PlayReferenceType"
	
	/// Gets or sets the playReferenceType
	public var playReferenceType: PlayReferenceTypes {
		get {
			let i = Int(self.getProperty(key: playreferencetypeKey)!)!
			
			return PlayReferenceTypes(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: playreferencetypeKey, value: String(i), setWhenInvalidYN: false)
		}
	}
	
	let playreferenceidKey: String = "PlayReferenceID"
	
	/// Gets or sets the playReferenceID
	public var playReferenceID: String {
		get {
			
			return self.getProperty(key: playreferenceidKey)!
		}
		set(value) {
			
			self.setProperty(key: playreferenceidKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let playreferenceactiontypeKey: String = "PlayReferenceActionType"
	
	/// Gets or sets the playReferenceActionType
	public var playReferenceActionType: PlayReferenceActionTypes {
		get {
			let i = Int(self.getProperty(key: playreferenceactiontypeKey)!)!
			
			return PlayReferenceActionTypes(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: playreferenceactiontypeKey, value: String(i), setWhenInvalidYN: false)
		}
	}
	
	let oncompletedataKey: String = "OnCompleteData"
	
	/// Gets or sets the onCompleteData
	public var onCompleteData: String {
		get {
			
			return self.getProperty(key: oncompletedataKey)!
		}
		set(value) {
			
			self.setProperty(key: oncompletedataKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> PlayMoveWrapper {
		
		let wrapper = PlayMoveWrapper()
		
		wrapper.id						= self.id
		wrapper.playReferenceType		= self.playReferenceType
		wrapper.playReferenceID			= self.playReferenceID
		wrapper.playReferenceActionType	= self.playReferenceActionType
		
		// Nb: This sets up the PlayExperienceStepOnCompleteData wrapper
		wrapper.set(onCompleteData: self.onCompleteData)
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlayMoveWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN			= false
		
		// Copy all properties from the wrapper
		self.id							= wrapper.id
		self.playReferenceType			= wrapper.playReferenceType
		self.playReferenceID			= wrapper.playReferenceID
		self.playReferenceActionType	= wrapper.playReferenceActionType
		self.onCompleteData				= wrapper.onCompleteData
		
		self.doValidationsYN 			= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: playreferencetypeKey,		value: "1")
		self.doSetProperty(key: playreferenceidKey,			value: "")
		self.doSetProperty(key: playreferenceactiontypeKey,	value: "1")
		self.doSetProperty(key: oncompletedataKey,	   		value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.playMove_id.rawValue
		endEnumIndex	= ModelProperties.playMove_onCompleteData.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]							= ModelProperties.playMove_id.rawValue
		keys[playreferencetypeKey]			= ModelProperties.playMove_playReferenceType.rawValue
		keys[playreferenceidKey]			= ModelProperties.playMove_playReferenceID.rawValue
		keys[playreferenceactiontypeKey]	= ModelProperties.playMove_playReferenceActionType.rawValue
		keys[oncompletedataKey]				= ModelProperties.playMove_onCompleteData.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlayMove"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN 				= false
		
		// Copy all properties from the specified item
		if let item = item as? PlayMove {
			
			self.id							= item.id
			self.playReferenceType			= item.playReferenceType
			self.playReferenceID			= item.playReferenceID
			self.playReferenceActionType	= item.playReferenceActionType
			self.onCompleteData				= item.onCompleteData
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()
		
		result.ID 		= self.id
		
		result.setParameterValue(key: "\(PlayMoveDataParameterKeys.PlayReferenceType)", value: String(self.playReferenceType.rawValue))
		result.setParameterValue(key: "\(PlayMoveDataParameterKeys.PlayReferenceID)", value: self.playReferenceID)
		result.setParameterValue(key: "\(PlayMoveDataParameterKeys.PlayReferenceActionType)", value: String(self.playReferenceActionType.rawValue))
		result.setParameterValue(key: "\(PlayMoveDataParameterKeys.OnCompleteData)", value: self.onCompleteData)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties
		self.id 						= dataWrapper.ID
		self.playReferenceType 			= PlayReferenceTypes(rawValue: Int(dataWrapper.getParameterValue(key: "\(PlayMoveDataParameterKeys.PlayReferenceType)")!)!)!
		self.playReferenceID 			= dataWrapper.getParameterValue(key: "\(PlayMoveDataParameterKeys.PlayReferenceID)")!
		self.playReferenceActionType 	= PlayReferenceActionTypes(rawValue: Int(dataWrapper.getParameterValue(key: "\(PlayMoveDataParameterKeys.PlayReferenceActionType)")!)!)!
		self.onCompleteData 			= dataWrapper.getParameterValue(key: "\(PlayMoveDataParameterKeys.OnCompleteData)")!
		
		self.doValidationsYN 			= doValidationsYN
	}
	
	public override func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		let result: ValidationResultTypes = ValidationResultTypes.passed
		
		// Perform validations for the specified property
		//		switch toProperty(propertyEnum: propertyEnum) {
		//		case .artworkComment_postedByName:
		//			result = self.isValidPostedByName(value: value)
		//			break
		//
		//		default:
		//			break
		//		}
		
		return result
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func toProperty(propertyEnum: Int) -> ModelProperties {
		
		return ModelProperties(rawValue: propertyEnum)!
	}
	
	
	// MARK: - Validations
	
}

