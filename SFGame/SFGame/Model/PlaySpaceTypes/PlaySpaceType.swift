//
//  PlaySpaceType.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlaySpaceTypeDataParameterKeys {
	case ID
	case PlaySpaceType
	case PlayAreaID
	case Name
}

/// Encapsulates a PlaySpaceType model item
public class PlaySpaceType: ModelItemBase {
	
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
	
	let playspacetypeKey: String = "PlaySpaceType"
	
	/// Gets or sets the playSpaceType
	public var playSpaceType: Int {
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
	
	public func toWrapper() -> PlaySpaceTypeWrapper {
		
		let wrapper = PlaySpaceTypeWrapper()
		
		wrapper.id				= self.id
		wrapper.playSpaceType	= self.playSpaceType
		wrapper.name			= self.name
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlaySpaceTypeWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 	Bool = self.doValidationsYN
		self.doValidationsYN	= false
		
		// Copy all properties from the wrapper
		self.id					= wrapper.id
		self.playSpaceType		= wrapper.playSpaceType
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
		
		startEnumIndex	= ModelProperties.playSpaceType_id.rawValue
		endEnumIndex	= ModelProperties.playSpaceType_name.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]				= ModelProperties.playSpaceType_id.rawValue
		keys[playspacetypeKey]	= ModelProperties.playSpaceType_playSpaceType.rawValue
		keys[nameKey]			= ModelProperties.playSpaceType_name.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlaySpaceType"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 	Bool = self.doValidationsYN
		self.doValidationsYN 	= false
		
		// Copy all properties from the specified item
		if let item = item as? PlaySpaceType {
			
			self.id				= item.id
			self.playSpaceType	= item.playSpaceType
			self.name			= item.name
	
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(PlaySpaceTypeDataParameterKeys.PlaySpaceType)", value: "\(self.playSpaceType)")
		result.setParameterValue(key: "\(PlaySpaceTypeDataParameterKeys.Name)", value: self.name)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN 		= false
		
		// Copy all properties
		self.id 					= dataWrapper.ID
		self.playSpaceType 			= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceTypeDataParameterKeys.PlaySpaceType)")!)!
		self.name 					= dataWrapper.getParameterValue(key: "\(PlaySpaceTypeDataParameterKeys.Name)")!
		
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
