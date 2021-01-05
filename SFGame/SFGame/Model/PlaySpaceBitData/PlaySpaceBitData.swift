//
//  PlaySpaceBitData.swift
//  SFGame
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum PlaySpaceBitDataDataParameterKeys {
	case ID
	case RelativeMemberID
	case PlaySpaceBitID
	case NumberOfFeathers
	case NumberOfExperiencePoints
	case NumberOfPoints
	case AttributeData
}

/// Encapsulates a PlaySpaceBitData model item
public class PlaySpaceBitData: ModelItemBase {
	
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

	let playspacebitidKey: String = "PlaySpaceBitID"
	
	/// Gets or sets the playSpaceBitID
	public var playSpaceBitID: String {
		get {
			
			return self.getProperty(key: playspacebitidKey)!
		}
		set(value) {
			
			self.setProperty(key: playspacebitidKey, value: value, setWhenInvalidYN: false)
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
	
	public func toWrapper() -> PlaySpaceBitDataWrapper {
		
		let wrapper = PlaySpaceBitDataWrapper()
		
		wrapper.id							= self.id
		wrapper.relativeMemberID			= self.relativeMemberID
		wrapper.playSpaceBitID				= self.playSpaceBitID
		wrapper.numberOfFeathers			= self.numberOfFeathers
		wrapper.numberOfExperiencePoints	= self.numberOfExperiencePoints
		wrapper.numberOfPoints				= self.numberOfPoints
		
		// Nb: This sets up the PlaySpaceBitDataAttributeData wrapper
		wrapper.set(attributeData: self.attributeData)
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: PlaySpaceBitDataWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN			= false
		
		// Copy all properties from the wrapper
		self.id							= wrapper.id
		self.relativeMemberID			= wrapper.relativeMemberID
		self.playSpaceBitID				= wrapper.playSpaceBitID
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
		self.doSetProperty(key: playspacebitidKey,	    		value: "")
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
		
		startEnumIndex	= ModelProperties.playSpaceBitData_id.rawValue
		endEnumIndex	= ModelProperties.playSpaceBitData_attributeData.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]							= ModelProperties.playSpaceBitData_id.rawValue
		keys[relativememberidKey]			= ModelProperties.playSpaceBitData_relativeMemberID.rawValue
		keys[playspacebitidKey]				= ModelProperties.playSpaceBitData_playSpaceBitID.rawValue
		keys[numberoffeathersKey]			= ModelProperties.playSpaceBitData_numberOfFeathers.rawValue
		keys[numberofexperiencepointsKey]	= ModelProperties.playSpaceBitData_numberOfExperiencePoints.rawValue
		keys[numberofpointsKey]				= ModelProperties.playSpaceBitData_numberOfPoints.rawValue
		keys[attributedataKey]				= ModelProperties.playSpaceBitData_attributeData.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "PlaySpaceBitData"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN 				= false
		
		// Copy all properties from the specified item
		if let item = item as? PlaySpaceBitData {
			
			self.id							= item.id
			self.relativeMemberID			= item.relativeMemberID
			self.playSpaceBitID				= item.playSpaceBitID
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

		result.setParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.RelativeMemberID)", value: self.relativeMemberID)
		result.setParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.PlaySpaceBitID)", value: self.playSpaceBitID)
		result.setParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.NumberOfFeathers)", value: "\(self.numberOfFeathers)")
		result.setParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.NumberOfExperiencePoints)", value: "\(self.numberOfExperiencePoints)")
		result.setParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.NumberOfPoints)", value: "\(self.numberOfPoints)")
		result.setParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.AttributeData)", value: self.attributeData)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties
		self.id 						= dataWrapper.ID
		self.relativeMemberID 			= dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.RelativeMemberID)")!
		self.playSpaceBitID 			= dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.PlaySpaceBitID)")!
		self.numberOfFeathers 			= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.NumberOfFeathers)")!) ?? 0
		self.numberOfExperiencePoints 	= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.NumberOfExperiencePoints)")!) ?? 0
		self.numberOfPoints 			= Int(dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.NumberOfPoints)")!) ?? 0
		self.attributeData 				= dataWrapper.getParameterValue(key: "\(PlaySpaceBitDataDataParameterKeys.AttributeData)")!
		
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
