//
//  PlaySpaceData.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlaySpaceDataDataParameterKeys {
	case ID
	case RelativeMemberID
	case PlaySpaceID
	case NumberOfFeathers
	case NumberOfExperiencePoints
	case NumberOfPoints
	case AttributeData
	case LoadRelationalTablesYN
}

/// Encapsulates a PlaySpaceData model item
public class PlaySpaceData: ModelItemBase {
	
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
	
	let attributedataKey: String = "AttributeData"
	
	/// Gets or sets the attributeData
	public var attributeData: String {
		get {
			
			return self.getProperty(key: attributedataKey)!
		}
		set(value) {
			
			self.setProperty(key: attributedataKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> PlaySpaceDataWrapper {
		
		let wrapper = PlaySpaceDataWrapper()
		
		wrapper.id							= self.id
		wrapper.relativeMemberID			= self.relativeMemberID
		wrapper.playSpaceID					= self.playSpaceID
		wrapper.numberOfFeathers			= self.numberOfFeathers
		wrapper.numberOfExperiencePoints	= self.numberOfExperiencePoints
		wrapper.numberOfPoints				= self.numberOfPoints
		
		// Nb: This sets up the PlaySpaceDataAttributeData wrapper
		wrapper.set(attributeData: self.attributeData)
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlaySpaceDataWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN			= false
		
		// Copy all properties from the wrapper
		self.id							= wrapper.id
		self.relativeMemberID			= wrapper.relativeMemberID
		self.playSpaceID				= wrapper.playSpaceID
		self.numberOfFeathers			= wrapper.numberOfFeathers
		self.numberOfExperiencePoints	= wrapper.numberOfExperiencePoints
		self.numberOfPoints				= wrapper.numberOfPoints
		self.attributeData				= wrapper.attributeData
		
		self.doValidationsYN 			= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: relativememberidKey,			value: "")
		self.doSetProperty(key: playspaceidKey,					value: "")
		self.doSetProperty(key: numberoffeathersKey,			value: "0")
		self.doSetProperty(key: numberofexperiencepointsKey,	value: "0")
		self.doSetProperty(key: numberofpointsKey,				value: "0")
		self.doSetProperty(key: attributedataKey,	   			value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.playSpaceData_id.rawValue
		endEnumIndex	= ModelProperties.playSpaceData_attributeData.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]							= ModelProperties.playSpaceData_id.rawValue
		keys[relativememberidKey]			= ModelProperties.playSpaceData_relativeMemberID.rawValue
		keys[playspaceidKey]				= ModelProperties.playSpaceData_playSpaceID.rawValue
		keys[numberoffeathersKey]			= ModelProperties.playSpaceData_numberOfFeathers.rawValue
		keys[numberofexperiencepointsKey]	= ModelProperties.playSpaceData_numberOfExperiencePoints.rawValue
		keys[numberofpointsKey]				= ModelProperties.playSpaceData_numberOfPoints.rawValue
		keys[attributedataKey]				= ModelProperties.playSpaceData_attributeData.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlaySpaceData"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN 				= false
		
		// Copy all properties from the specified item
		if let item = item as? PlaySpaceData {
			
			self.id							= item.id
			self.relativeMemberID			= item.relativeMemberID
			self.playSpaceID				= item.playSpaceID
			self.numberOfFeathers			= item.numberOfFeathers
			self.numberOfExperiencePoints	= item.numberOfExperiencePoints
			self.numberOfPoints				= item.numberOfPoints
			self.attributeData				= item.attributeData
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(PlaySpaceDataDataParameterKeys.RelativeMemberID)", value: self.relativeMemberID)
		result.setParameterValue(key: "\(PlaySpaceDataDataParameterKeys.PlaySpaceID)", value: self.playSpaceID)
		result.setParameterValue(key: "\(PlaySpaceDataDataParameterKeys.NumberOfFeathers)", value: "\(self.numberOfFeathers)")
		result.setParameterValue(key: "\(PlaySpaceDataDataParameterKeys.NumberOfExperiencePoints)", value: "\(self.numberOfExperiencePoints)")
		result.setParameterValue(key: "\(PlaySpaceDataDataParameterKeys.NumberOfPoints)", value: "\(self.numberOfPoints)")
		result.setParameterValue(key: "\(PlaySpaceDataDataParameterKeys.AttributeData)", value: self.attributeData)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties
		self.id 						= dataWrapper.ID
		self.relativeMemberID 			= dataWrapper.getParameterValue(key: "\(PlaySpaceDataDataParameterKeys.RelativeMemberID)")!
		self.playSpaceID 				= dataWrapper.getParameterValue(key: "\(PlaySpaceDataDataParameterKeys.PlaySpaceID)")!
		self.numberOfFeathers 			= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceDataDataParameterKeys.NumberOfFeathers)")!) ?? 0
		self.numberOfExperiencePoints 	= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceDataDataParameterKeys.NumberOfExperiencePoints)")!) ?? 0
		self.numberOfPoints 			= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceDataDataParameterKeys.NumberOfPoints)")!) ?? 0
		self.attributeData 				= dataWrapper.getParameterValue(key: "\(PlaySpaceDataDataParameterKeys.AttributeData)")!
		
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
