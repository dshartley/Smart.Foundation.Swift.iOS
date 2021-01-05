//
//  PlayExperience.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlayExperienceDataParameterKeys {
	case ID
	case PlayExperienceType
	case PlayLanguageID
	case Name
	case OnCompleteData
	case LoadRelationalTablesYN
}

/// Encapsulates a PlayExperience model item
public class PlayExperience: ModelItemBase {
	
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
	
	let playexperiencetypeKey: String = "PlayExperienceType"
	
	/// Gets or sets the playExperienceType
	public var playExperienceType: Int {
		get {
			let i = Int(self.getProperty(key: playexperiencetypeKey)!)!
			
			return i
		}
		set(value) {

			self.setProperty(key: playexperiencetypeKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let playlanguageidKey: String = "PlayLanguageID"
	
	/// Gets or sets the playLanguageID
	public var playLanguageID: String {
		get {
			
			return self.getProperty(key: playlanguageidKey)!
		}
		set(value) {
			
			self.setProperty(key: playlanguageidKey, value: value, setWhenInvalidYN: false)
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
	
	public func toWrapper() -> PlayExperienceWrapper {
		
		let wrapper = PlayExperienceWrapper()
		
		wrapper.id						= self.id
		wrapper.playExperienceType		= self.playExperienceType
		wrapper.playLanguageID			= self.playLanguageID
		wrapper.name					= self.name
		
		// Nb: This sets up the PlayExperienceOnCompleteData wrapper
		wrapper.set(onCompleteData: self.onCompleteData)

		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlayExperienceWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN			= false
		
		// Copy all properties from the wrapper
		self.id							= wrapper.id
		self.playExperienceType			= wrapper.playExperienceType
		self.playLanguageID				= wrapper.playLanguageID
		self.name						= wrapper.name
		self.onCompleteData				= wrapper.onCompleteData
		
		self.doValidationsYN 			= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: playexperiencetypeKey,		value: "1")
		self.doSetProperty(key: playlanguageidKey,			value: "")
		self.doSetProperty(key: nameKey,	    			value: "")
		self.doSetProperty(key: oncompletedataKey,	    	value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.playExperience_id.rawValue
		endEnumIndex	= ModelProperties.playExperience_onCompleteData.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]							= ModelProperties.playExperience_id.rawValue
		keys[playexperiencetypeKey]			= ModelProperties.playExperience_playExperienceType.rawValue
		keys[playlanguageidKey]				= ModelProperties.playExperience_playLanguageID.rawValue
		keys[nameKey]						= ModelProperties.playExperience_name.rawValue
		keys[oncompletedataKey]				= ModelProperties.playExperience_onCompleteData.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlayExperience"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN 				= false
		
		// Copy all properties from the specified item
		if let item = item as? PlayExperience {
			
			self.id							= item.id
			self.playExperienceType			= item.playExperienceType
			self.playLanguageID				= item.playLanguageID
			self.name						= item.name
			self.onCompleteData				= item.onCompleteData
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(PlayExperienceDataParameterKeys.PlayExperienceType)", value: String(self.playExperienceType))
		result.setParameterValue(key: "\(PlayExperienceDataParameterKeys.PlayLanguageID)", value: self.playLanguageID)
		result.setParameterValue(key: "\(PlayExperienceDataParameterKeys.Name)", value: self.name)
		result.setParameterValue(key: "\(PlayExperienceDataParameterKeys.OnCompleteData)", value: self.onCompleteData)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties
		self.id 						= dataWrapper.ID
		
		self.playExperienceType 		= Int(dataWrapper.getParameterValue(key: "\(PlayExperienceDataParameterKeys.PlayExperienceType)")!)!
		self.playLanguageID 			= dataWrapper.getParameterValue(key: "\(PlayExperienceDataParameterKeys.PlayLanguageID)")!
		self.name 						= dataWrapper.getParameterValue(key: "\(PlayExperienceDataParameterKeys.Name)")!
		self.onCompleteData 			= dataWrapper.getParameterValue(key: "\(PlayExperienceDataParameterKeys.OnCompleteData)")!
		
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
