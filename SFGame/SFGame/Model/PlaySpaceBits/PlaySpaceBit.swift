//
//  PlaySpaceBit.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlaySpaceBitDataParameterKeys {
	case ID
	case RelativeMemberID
	case PlaySpaceID
	case PlaySpaceBitType
	case CoordX
	case CoordY
}

/// Encapsulates a PlaySpaceBit model item
public class PlaySpaceBit: ModelItemBase {
	
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
	
	let relativememberidKey: String = "RelativeMemberID"
	
	/// Gets or sets the relativeMemberID
	public var relativeMemberID: String {
		get {
			
			return self.getProperty(key: relativememberidKey)!
		}
		set(value) {
			
			self.setProperty(key: relativememberidKey, value: value, setWhenInvalidYN: false)
		}
	}

	let playspaceidKey: String = "PlaySpaceID"
	
	/// Gets or sets the playSpaceID
	public var playSpaceID: String {
		get {
			
			return self.getProperty(key: playspaceidKey)!
		}
		set(value) {
			
			self.setProperty(key: playspaceidKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let playspacebittypeKey: String = "PlaySpaceBitType"
	
	/// Gets or sets the playSpaceBitType
	public var playSpaceBitType: Int {
		get {
			let i = Int(self.getProperty(key: playspacebittypeKey)!)!
			
			return i
		}
		set(value) {
			
			self.setProperty(key: playspacebittypeKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let coordxKey: String = "CoordX"
	
	/// Gets or sets the coordX
	public var coordX: Int {
		get {
			
			return Int(self.getProperty(key: coordxKey)!)!
		}
		set(value) {
			
			self.setProperty(key: coordxKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let coordyKey: String = "CoordY"
	
	/// Gets or sets the coordY
	public var coordY: Int {
		get {
			
			return Int(self.getProperty(key: coordyKey)!)!
		}
		set(value) {
			
			self.setProperty(key: coordyKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> PlaySpaceBitWrapper {
		
		let wrapper = PlaySpaceBitWrapper()
		
		wrapper.id					= self.id
		wrapper.relativeMemberID	= self.relativeMemberID
		wrapper.playSpaceID			= self.playSpaceID
		wrapper.playSpaceBitType	= self.playSpaceBitType
		wrapper.coordX				= self.coordX
		wrapper.coordY				= self.coordY
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlaySpaceBitWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN		= false
		
		// Copy all properties from the wrapper
		self.id						= wrapper.id
		self.relativeMemberID		= wrapper.relativeMemberID
		self.playSpaceID			= wrapper.playSpaceID
		self.playSpaceBitType		= wrapper.playSpaceBitType
		self.coordX					= wrapper.coordX
		self.coordY					= wrapper.coordY
		
		self.doValidationsYN 		= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: relativememberidKey,	value: "")
		self.doSetProperty(key: playspaceidKey,	    	value: "")
		self.doSetProperty(key: playspacebittypeKey,	value: "1")
		self.doSetProperty(key: coordxKey,	    		value: "0")
		self.doSetProperty(key: coordyKey,	    		value: "0")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.playSpaceBit_id.rawValue
		endEnumIndex	= ModelProperties.playSpaceBit_coordY.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]					= ModelProperties.playSpaceBit_id.rawValue
		keys[relativememberidKey]	= ModelProperties.playSpaceBit_relativeMemberID.rawValue
		keys[playspaceidKey]		= ModelProperties.playSpaceBit_playSpaceID.rawValue
		keys[playspacebittypeKey]	= ModelProperties.playSpaceBit_playSpaceBitType.rawValue
		keys[coordxKey]				= ModelProperties.playSpaceBit_coordX.rawValue
		keys[coordyKey]				= ModelProperties.playSpaceBit_coordY.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlaySpaceBit"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN 		= false
		
		// Copy all properties from the specified item
		if let item = item as? PlaySpaceBit {
			
			self.id					= item.id
			self.relativeMemberID	= item.relativeMemberID
			self.playSpaceID		= item.playSpaceID
			self.playSpaceBitType	= item.playSpaceBitType
			self.coordX				= item.coordX
			self.coordY				= item.coordY
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(PlaySpaceBitDataParameterKeys.RelativeMemberID)", value: self.relativeMemberID)
		result.setParameterValue(key: "\(PlaySpaceBitDataParameterKeys.PlaySpaceID)", value: self.playSpaceID)
		result.setParameterValue(key: "\(PlaySpaceBitDataParameterKeys.PlaySpaceBitType)", value: String(self.playSpaceBitType))
		result.setParameterValue(key: "\(PlaySpaceBitDataParameterKeys.CoordX)", value: "\(self.coordX)")
		result.setParameterValue(key: "\(PlaySpaceBitDataParameterKeys.CoordY)", value: "\(self.coordY)")
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 	Bool = self.doValidationsYN
		self.doValidationsYN 	= false
		
		// Copy all properties
		self.id 				= dataWrapper.ID
		self.relativeMemberID 	= dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataParameterKeys.RelativeMemberID)")!
		self.playSpaceID 		= dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataParameterKeys.PlaySpaceID)")!
		self.playSpaceBitType 	= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataParameterKeys.PlaySpaceBitType)")!)!
		self.coordX 			= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataParameterKeys.CoordX)")!) ?? 0
		self.coordY 			= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataParameterKeys.CoordY)")!) ?? 0
		
		self.doValidationsYN 	= doValidationsYN
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
