//
//  PlayResult.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlayResultDataParameterKeys {
	case ID
	case PlayDataJSON
	case PlaySpacesJSON
	case PlaySpaceDataJSON
	case PlaySpaceBitsJSON
	case PlaySpaceBitDataJSON
	case PlayExperienceStepResultsJSON
}

/// Encapsulates a PlayResult model item
public class PlayResult: ModelItemBase {
	
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
	
	let playdatajsonKey: String = "PlayDataJSON"
	
	/// Gets or sets the playDataJSON
	public var playDataJSON: String {
		get {
			
			return self.getProperty(key: playdatajsonKey)!
		}
		set(value) {
			
			self.setProperty(key: playdatajsonKey, value: value, setWhenInvalidYN: false)
		}
	}

	let playspacesjsonKey: String = "PlaySpacesJSON"
	
	/// Gets or sets the playSpacesJSON
	public var playSpacesJSON: String {
		get {
			
			return self.getProperty(key: playspacesjsonKey)!
		}
		set(value) {
			
			self.setProperty(key: playspacesjsonKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let playspacedatajsonKey: String = "PlaySpaceDataJSON"
	
	/// Gets or sets the playSpaceDataJSON
	public var playSpaceDataJSON: String {
		get {
			
			return self.getProperty(key: playspacedatajsonKey)!
		}
		set(value) {
			
			self.setProperty(key: playspacedatajsonKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let playspacebitsjsonKey: String = "PlaySpaceBitsJSON"
	
	/// Gets or sets the playSpaceBitsJSON
	public var playSpaceBitsJSON: String {
		get {
			
			return self.getProperty(key: playspacebitsjsonKey)!
		}
		set(value) {
			
			self.setProperty(key: playspacebitsjsonKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let playspacebitdatajsonKey: String = "PlaySpaceBitDataJSON"
	
	/// Gets or sets the playSpaceBitDataJSON
	public var playSpaceBitDataJSON: String {
		get {
			
			return self.getProperty(key: playspacebitdatajsonKey)!
		}
		set(value) {
			
			self.setProperty(key: playspacebitdatajsonKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let playexperiencestepresultsjsonKey: String = "PlayExperienceStepResultsJSON"
	
	/// Gets or sets the playExperienceStepResultsJSON
	public var playExperienceStepResultsJSON: String {
		get {
			
			return self.getProperty(key: playexperiencestepresultsjsonKey)!
		}
		set(value) {
			
			self.setProperty(key: playexperiencestepresultsjsonKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> PlayResultWrapper {
		
		let wrapper = PlayResultWrapper()
		
		wrapper.id								= self.id
		wrapper.playDataJSON					= self.playDataJSON
		wrapper.playSpacesJSON					= self.playSpacesJSON
		wrapper.playSpaceDataJSON				= self.playSpaceDataJSON
		wrapper.playSpaceBitsJSON				= self.playSpaceBitsJSON
		wrapper.playSpaceBitDataJSON			= self.playSpaceBitDataJSON
		wrapper.playExperienceStepResultsJSON	= self.playExperienceStepResultsJSON
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlayResultWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN				= false
		
		// Copy all properties from the wrapper
		self.id								= wrapper.id
		self.playDataJSON					= wrapper.playDataJSON
		self.playSpacesJSON					= wrapper.playSpacesJSON
		self.playSpaceDataJSON				= wrapper.playSpaceDataJSON
		self.playSpaceBitsJSON				= wrapper.playSpaceBitsJSON
		self.playSpaceBitDataJSON			= wrapper.playSpaceBitDataJSON
		self.playExperienceStepResultsJSON	= wrapper.playExperienceStepResultsJSON
		
		self.doValidationsYN 				= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data

		self.doSetProperty(key: playdatajsonKey,					value: "")
		self.doSetProperty(key: playspacesjsonKey,					value: "")
		self.doSetProperty(key: playspacedatajsonKey,				value: "")
		self.doSetProperty(key: playspacebitsjsonKey,				value: "")
		self.doSetProperty(key: playspacebitdatajsonKey,			value: "")
		self.doSetProperty(key: playexperiencestepresultsjsonKey,	value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.playResult_id.rawValue
		endEnumIndex	= ModelProperties.playResult_playExperienceStepResultsJSON.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]								= ModelProperties.playResult_id.rawValue
		keys[playdatajsonKey]					= ModelProperties.playResult_playDataJSON.rawValue
		keys[playspacesjsonKey]					= ModelProperties.playResult_playSpacesJSON.rawValue
		keys[playspacedatajsonKey]				= ModelProperties.playResult_playSpaceDataJSON.rawValue
		keys[playspacebitsjsonKey]				= ModelProperties.playResult_playSpaceBitsJSON.rawValue
		keys[playspacebitdatajsonKey]			= ModelProperties.playResult_playSpaceBitDataJSON.rawValue
		keys[playexperiencestepresultsjsonKey]	= ModelProperties.playResult_playExperienceStepResultsJSON.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlayResult"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN 				= false
		
		// Copy all properties from the specified item
		if let item = item as? PlayResult {
			
			self.id								= item.id
			self.playDataJSON					= item.playDataJSON
			self.playSpacesJSON					= item.playSpacesJSON
			self.playSpaceDataJSON				= item.playSpaceDataJSON
			self.playSpaceBitsJSON				= item.playSpaceBitsJSON
			self.playSpaceBitDataJSON			= item.playSpaceBitDataJSON
			self.playExperienceStepResultsJSON	= item.playExperienceStepResultsJSON
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(PlayResultDataParameterKeys.PlayDataJSON)", value: self.playDataJSON)
		result.setParameterValue(key: "\(PlayResultDataParameterKeys.PlaySpacesJSON)", value: self.playSpacesJSON)
		result.setParameterValue(key: "\(PlayResultDataParameterKeys.PlaySpaceDataJSON)", value: self.playSpaceDataJSON)
		result.setParameterValue(key: "\(PlayResultDataParameterKeys.PlaySpaceBitsJSON)", value: self.playSpaceBitsJSON)
		result.setParameterValue(key: "\(PlayResultDataParameterKeys.PlaySpaceBitDataJSON)", value: self.playSpaceBitDataJSON)
		result.setParameterValue(key: "\(PlayResultDataParameterKeys.PlayExperienceStepResultsJSON)", value: self.playExperienceStepResultsJSON)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN 				= false
		
		// Copy all properties
		self.id 							= dataWrapper.ID
		self.playDataJSON 					= dataWrapper.getParameterValue(key: "\(PlayResultDataParameterKeys.PlayDataJSON)")!
		self.playSpacesJSON 				= dataWrapper.getParameterValue(key: "\(PlayResultDataParameterKeys.PlaySpacesJSON)")!
		self.playSpaceDataJSON 				= dataWrapper.getParameterValue(key: "\(PlayResultDataParameterKeys.PlaySpaceDataJSON)")!
		self.playSpaceBitsJSON 				= dataWrapper.getParameterValue(key: "\(PlayResultDataParameterKeys.PlaySpaceBitsJSON)")!
		self.playSpaceBitDataJSON 			= dataWrapper.getParameterValue(key: "\(PlayResultDataParameterKeys.PlaySpaceBitDataJSON)")!
		self.playExperienceStepResultsJSON 	= dataWrapper.getParameterValue(key: "\(PlayResultDataParameterKeys.PlayExperienceStepResultsJSON)")!
		
		self.doValidationsYN 				= doValidationsYN
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
