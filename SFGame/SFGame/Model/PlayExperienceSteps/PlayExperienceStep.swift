//
//  PlayExperienceStep.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlayExperienceStepDataParameterKeys {
	case ID
	case PlayExperienceID
	case PlayExperienceStepType
	case PlayLanguageID
	case ContentData
	case OnCompleteData
	case LoadRelationalTablesYN
}

/// Encapsulates a PlayExperienceStep model item
public class PlayExperienceStep: ModelItemBase {
	
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
	
	let playexperienceidKey: String = "PlayExperienceID"
	
	/// Gets or sets the playExperienceID
	public var playExperienceID: String {
		get {
			
			return self.getProperty(key: playexperienceidKey)!
		}
		set(value) {
			
			self.setProperty(key: playexperienceidKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let playexperiencetypeKey: String = "PlayExperienceStepType"
	
	/// Gets or sets the playExperienceStepType
	public var playExperienceStepType: Int {
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

	let contentdataKey: String = "ContentData"
	
	/// Gets or sets the contentData
	public var contentData: String {
		get {
			
			return self.getProperty(key: contentdataKey)!
		}
		set(value) {
			
			self.setProperty(key: contentdataKey, value: value, setWhenInvalidYN: false)
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
	
	public func toWrapper() -> PlayExperienceStepWrapper {
		
		let wrapper = PlayExperienceStepWrapper()
		
		wrapper.id						= self.id
		wrapper.playExperienceID		= self.playExperienceID
		wrapper.playExperienceStepType	= self.playExperienceStepType
		wrapper.playLanguageID			= self.playLanguageID

		// Nb: This sets up the PlayExperienceStepContentData wrapper
		wrapper.set(contentData: self.contentData)
		
		// Nb: This sets up the PlayExperienceStepOnCompleteData wrapper
		wrapper.set(onCompleteData: self.onCompleteData)

		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlayExperienceStepWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN			= false
		
		// Copy all properties from the wrapper
		self.id							= wrapper.id
		self.playExperienceID			= wrapper.playExperienceID
		self.playExperienceStepType		= wrapper.playExperienceStepType
		self.playLanguageID				= wrapper.playLanguageID
		self.contentData				= wrapper.contentData
		self.onCompleteData				= wrapper.onCompleteData
		
		self.doValidationsYN 			= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: playexperienceidKey,	value: "")
		self.doSetProperty(key: playexperiencetypeKey,	value: "1")
		self.doSetProperty(key: playlanguageidKey,		value: "")
		self.doSetProperty(key: contentdataKey,	    	value: "")
		self.doSetProperty(key: oncompletedataKey,	    value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.playExperienceStep_id.rawValue
		endEnumIndex	= ModelProperties.playExperienceStep_onCompleteData.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]					= ModelProperties.playExperienceStep_id.rawValue
		keys[playexperienceidKey]	= ModelProperties.playExperienceStep_playExperienceID.rawValue
		keys[playexperiencetypeKey]	= ModelProperties.playExperienceStep_playExperienceStepType.rawValue
		keys[playlanguageidKey]		= ModelProperties.playExperienceStep_playLanguageID.rawValue
		keys[contentdataKey]		= ModelProperties.playExperienceStep_contentData.rawValue
		keys[oncompletedataKey]		= ModelProperties.playExperienceStep_onCompleteData.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlayExperienceStep"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties from the specified item
		if let item = item as? PlayExperienceStep {
			
			self.id						= item.id
			self.playExperienceID		= item.playExperienceID
			self.playExperienceStepType	= item.playExperienceStepType
			self.playLanguageID			= item.playLanguageID
			self.contentData			= item.contentData
			self.onCompleteData			= item.onCompleteData
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(PlayExperienceStepDataParameterKeys.PlayExperienceID)", value: self.playExperienceID)
		result.setParameterValue(key: "\(PlayExperienceStepDataParameterKeys.PlayExperienceStepType)", value: String(self.playExperienceStepType))
		result.setParameterValue(key: "\(PlayExperienceStepDataParameterKeys.PlayLanguageID)", value: self.playLanguageID)
		result.setParameterValue(key: "\(PlayExperienceStepDataParameterKeys.ContentData)", value: self.contentData)
		result.setParameterValue(key: "\(PlayExperienceStepDataParameterKeys.OnCompleteData)", value: self.onCompleteData)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties
		self.id 						= dataWrapper.ID
		self.playExperienceID 			= dataWrapper.getParameterValue(key: "\(PlayExperienceStepDataParameterKeys.PlayExperienceID)")!
		self.playExperienceStepType 	= Int(dataWrapper.getParameterValue(key: "\(PlayExperienceStepDataParameterKeys.PlayExperienceStepType)")!)!
		self.playLanguageID 			= dataWrapper.getParameterValue(key: "\(PlayExperienceStepDataParameterKeys.PlayLanguageID)")!
		self.contentData 				= dataWrapper.getParameterValue(key: "\(PlayExperienceStepDataParameterKeys.ContentData)")!
		self.onCompleteData 			= dataWrapper.getParameterValue(key: "\(PlayExperienceStepDataParameterKeys.OnCompleteData)")!
		
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
