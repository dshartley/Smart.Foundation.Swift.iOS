//
//  PlaySpaceBitType.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlaySpaceBitTypeDataParameterKeys {
	case ID
	case PlaySpaceBitType
	case PlaySpaceID
	case Name
}

/// Encapsulates a PlaySpaceBitType model item
public class PlaySpaceBitType: ModelItemBase {
	
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
	
	let playspacetypeKey: String = "PlaySpaceBitType"
	
	/// Gets or sets the playSpaceBitType
	public var playSpaceBitType: Int {
		get {
			let i = Int(self.getProperty(key: playspacetypeKey)!)!
			
			return i
		}
		set(value) {
			
			self.setProperty(key: playspacetypeKey, value: String(value), setWhenInvalidYN: false)
		}
	}

	let nameKey: String = "Name"
	
	/// Gets or sets the name
	public var name: String {
		get {
			
			return self.getProperty(key: nameKey)!
		}
		set(value) {
			
			self.setProperty(key: nameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> PlaySpaceBitTypeWrapper {
		
		let wrapper = PlaySpaceBitTypeWrapper()
		
		wrapper.id					= self.id
		wrapper.playSpaceBitType	= self.playSpaceBitType
		wrapper.name				= self.name
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlaySpaceBitTypeWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 	Bool = self.doValidationsYN
		self.doValidationsYN	= false
		
		// Copy all properties from the wrapper
		self.id					= wrapper.id
		self.playSpaceBitType	= wrapper.playSpaceBitType
		self.name				= wrapper.name
		
		self.doValidationsYN 	= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: playspacetypeKey,	value: "1")
		self.doSetProperty(key: nameKey,	    	value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.playSpaceBitType_id.rawValue
		endEnumIndex	= ModelProperties.playSpaceBitType_name.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]				= ModelProperties.playSpaceBitType_id.rawValue
		keys[playspacetypeKey]	= ModelProperties.playSpaceBitType_playSpaceBitType.rawValue
		keys[nameKey]			= ModelProperties.playSpaceBitType_name.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlaySpaceBitType"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN 		= false
		
		// Copy all properties from the specified item
		if let item = item as? PlaySpaceBitType {
			
			self.id					= item.id
			self.playSpaceBitType	= item.playSpaceBitType
			self.name				= item.name
	
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(PlaySpaceBitTypeDataParameterKeys.PlaySpaceBitType)", value: String(self.playSpaceBitType))
		result.setParameterValue(key: "\(PlaySpaceBitTypeDataParameterKeys.Name)", value: self.name)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN 		= false
		
		// Copy all properties
		self.id 					= dataWrapper.ID
		self.playSpaceBitType 		= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceBitTypeDataParameterKeys.PlaySpaceBitType)")!)!
		self.name 					= dataWrapper.getParameterValue(key: "\(PlaySpaceBitTypeDataParameterKeys.Name)")!
		
		self.doValidationsYN 		= doValidationsYN
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
