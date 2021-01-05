//
//  PlayData.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlayDataDataParameterKeys {
	case ID
	case ApplicationID
	case RelativeMemberID
	case PlayLanguageID
	case NumberOfFeathers
	case NumberOfExperiencePoints
	case NumberOfPoints
}

/// Encapsulates a PlayData model item
public class PlayData: ModelItemBase {
	
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
	
	let applicationidKey: String = "ApplicationID"
	
	/// Gets or sets the applicationID
	public var applicationID: String {
		get {
			
			return self.getProperty(key: applicationidKey)!
		}
		set(value) {
			
			self.setProperty(key: applicationidKey, value: value, setWhenInvalidYN: false)
		}
	}
	
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
	
	let numberoffeathersKey: String = "NumberOfFeathers"
	
	/// Gets or sets the numberOfFeathers
	public var numberOfFeathers: Int {
		get {
			
			return Int(self.getProperty(key: numberoffeathersKey)!)!
		}
		set(value) {
			
			self.setProperty(key: numberoffeathersKey, value: String(value), setWhenInvalidYN: false)
		}
	}

	let numberofexperiencepointsKey: String = "NumberOfExperiencePoints"
	
	/// Gets or sets the numberOfExperiencePoints
	public var numberOfExperiencePoints: Int {
		get {
			
			return Int(self.getProperty(key: numberofexperiencepointsKey)!)!
		}
		set(value) {
			
			self.setProperty(key: numberofexperiencepointsKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let numberofpointsKey: String = "NumberOfPoints"
	
	/// Gets or sets the numberOfPoints
	public var numberOfPoints: Int {
		get {
			
			return Int(self.getProperty(key: numberofpointsKey)!)!
		}
		set(value) {
			
			self.setProperty(key: numberofpointsKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> PlayDataWrapper {
		
		let wrapper = PlayDataWrapper()
		
		wrapper.id							= self.id
		wrapper.applicationID 				= self.applicationID
		wrapper.relativeMemberID			= self.relativeMemberID
		wrapper.playLanguageID				= self.playLanguageID
		wrapper.numberOfFeathers 			= self.numberOfFeathers
		wrapper.numberOfExperiencePoints	= self.numberOfExperiencePoints
		wrapper.numberOfPoints				= self.numberOfPoints
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlayDataWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN			= false
		
		// Copy all properties from the wrapper
		self.id							= wrapper.id
		self.applicationID				= wrapper.applicationID
		self.relativeMemberID			= wrapper.relativeMemberID
		self.playLanguageID				= wrapper.playLanguageID
		self.numberOfFeathers			= wrapper.numberOfFeathers
		self.numberOfExperiencePoints	= wrapper.numberOfExperiencePoints
		self.numberOfPoints				= wrapper.numberOfPoints
		
		self.doValidationsYN 			= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: applicationidKey,	    		value: "")
		self.doSetProperty(key: relativememberidKey,			value: "")
		self.doSetProperty(key: playlanguageidKey,	    		value: "")
		self.doSetProperty(key: numberoffeathersKey,			value: "0")
		self.doSetProperty(key: numberofexperiencepointsKey,	value: "0")
		self.doSetProperty(key: numberofpointsKey,				value: "0")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.playData_id.rawValue
		endEnumIndex	= ModelProperties.playData_numberOfPoints.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]							= ModelProperties.playData_id.rawValue
		keys[applicationidKey]				= ModelProperties.playData_applicationID.rawValue
		keys[relativememberidKey]			= ModelProperties.playData_relativeMemberID.rawValue
		keys[playlanguageidKey]				= ModelProperties.playData_playLanguageID.rawValue
		keys[numberoffeathersKey]			= ModelProperties.playData_numberOfFeathers.rawValue
		keys[numberofexperiencepointsKey]	= ModelProperties.playData_numberOfExperiencePoints.rawValue
		keys[numberofpointsKey]				= ModelProperties.playData_numberOfPoints.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlayData"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN 				= false
		
		// Copy all properties from the specified item
		if let item = item as? PlayData {
			
			self.id							= item.id
			self.applicationID				= item.applicationID
			self.relativeMemberID			= item.relativeMemberID
			self.playLanguageID				= item.playLanguageID
			self.numberOfFeathers			= item.numberOfFeathers
			self.numberOfExperiencePoints	= item.numberOfExperiencePoints
			self.numberOfPoints				= item.numberOfPoints
	
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(PlayDataDataParameterKeys.ApplicationID)", value: self.applicationID)
		result.setParameterValue(key: "\(PlayDataDataParameterKeys.RelativeMemberID)", value: self.relativeMemberID)
		result.setParameterValue(key: "\(PlayDataDataParameterKeys.PlayLanguageID)", value: self.playLanguageID)
		result.setParameterValue(key: "\(PlayDataDataParameterKeys.NumberOfFeathers)", value: "\(self.numberOfFeathers)")
		result.setParameterValue(key: "\(PlayDataDataParameterKeys.NumberOfExperiencePoints)", value: "\(self.numberOfExperiencePoints)")
		result.setParameterValue(key: "\(PlayDataDataParameterKeys.NumberOfPoints)", value: "\(self.numberOfPoints)")
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties
		self.id 						= dataWrapper.ID
		self.applicationID 				= dataWrapper.getParameterValue(key: "\(PlayDataDataParameterKeys.ApplicationID)")!
		self.relativeMemberID 			= dataWrapper.getParameterValue(key: "\(PlayDataDataParameterKeys.RelativeMemberID)")!
		self.playLanguageID 			= dataWrapper.getParameterValue(key: "\(PlayDataDataParameterKeys.PlayLanguageID)")!
		self.numberOfFeathers 			= Int(dataWrapper.getParameterValue(key: "\(PlayDataDataParameterKeys.NumberOfFeathers)")!) ?? 0
		self.numberOfExperiencePoints 	= Int(dataWrapper.getParameterValue(key: "\(PlayDataDataParameterKeys.NumberOfExperiencePoints)")!) ?? 0
		self.numberOfPoints 			= Int(dataWrapper.getParameterValue(key: "\(PlayDataDataParameterKeys.NumberOfPoints)")!) ?? 0
		
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
