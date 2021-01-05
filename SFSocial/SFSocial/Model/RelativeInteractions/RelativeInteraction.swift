//
//  RelativeInteraction.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSerialization

public enum RelativeInteractionDataParameterKeys {
	case ID
	case ApplicationID
	case FromRelativeMemberID
	case ToRelativeMemberID
	case InteractionType
	case DateActioned
	case InteractionStatus
	case Text
}

/// Encapsulates a RelativeInteraction model item
public class RelativeInteraction: ModelItemBase {
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(collection: 			ProtocolModelItemCollection,
						 storageDateFormatter:	DateFormatter) {
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
	
	let fromrelativememberidKey: String = "FromRelativeMemberID"
	
	/// Gets or sets the fromRelativeMemberID
	public var fromRelativeMemberID: String {
		get {
			
			return self.getProperty(key: fromrelativememberidKey)!
		}
		set(value) {
			
			self.setProperty(key: fromrelativememberidKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let torelativememberidKey: String = "ToRelativeMemberID"
	
	/// Gets or sets the toRelativeMemberID
	public var toRelativeMemberID: String {
		get {
			
			return self.getProperty(key: torelativememberidKey)!
		}
		set(value) {
			
			self.setProperty(key: torelativememberidKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let interactiontypeKey: String = "InteractionType"
	
	/// Gets or sets the interactionType
	public var interactionType: RelativeInteractionTypes {
		get {
			let i = Int(self.getProperty(key: interactiontypeKey)!)!
			
			return RelativeInteractionTypes(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: interactiontypeKey, value: String(i), setWhenInvalidYN: false)
		}
	}
	
	let dateactionedKey: String = "DateActioned"
	
	/// Gets or sets the dateActioned
	public var dateActioned: Date {
		get {
			
			let dateString = self.getProperty(key: dateactionedKey)!
			
			return DateHelper.getDate(fromString: dateString, fromDateFormatter: self.storageDateFormatter!)
		}
		set(value) {
			
			self.setProperty(key: dateactionedKey, value: self.getStorageDateString(fromDate: value), setWhenInvalidYN: false)
		}
	}
	
	let interactionstatusKey: String = "InteractionStatus"
	
	/// Gets or sets the interactionStatus
	public var interactionStatus: RelativeInteractionStatus {
		get {
			let i = Int(self.getProperty(key: interactionstatusKey)!)!
			
			return RelativeInteractionStatus(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: interactionstatusKey, value: String(i), setWhenInvalidYN: false)
		}
	}
	
	let textKey: String = "Text"
	
	/// Gets or sets the text
	public var text: String {
		get {
			
			return self.getProperty(key: textKey)!
		}
		set(value) {
			
			self.setProperty(key: textKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> RelativeInteractionWrapper {
		
		let wrapper = RelativeInteractionWrapper()
		
		wrapper.id						= self.id
		wrapper.applicationID 			= self.applicationID
		wrapper.fromRelativeMemberID 	= self.fromRelativeMemberID
		wrapper.toRelativeMemberID 		= self.toRelativeMemberID
		wrapper.interactionType 		= self.interactionType
		wrapper.dateActioned 			= self.dateActioned
		wrapper.interactionStatus 		= self.interactionStatus
		wrapper.text 					= self.text
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: RelativeInteractionWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN 		= false
		
		// Copy all properties from the wrapper
		self.id						= wrapper.id
		self.applicationID			= wrapper.applicationID
		self.fromRelativeMemberID 	= wrapper.fromRelativeMemberID
		self.toRelativeMemberID 	= wrapper.toRelativeMemberID
		self.interactionType 		= wrapper.interactionType
		self.dateActioned 			= wrapper.dateActioned
		self.interactionStatus	 	= wrapper.interactionStatus
		self.text 					= wrapper.text
		
		self.doValidationsYN 		= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		// Setup the node data
		
		self.doSetProperty(key: idKey,						value: "0")
		self.doSetProperty(key: applicationidKey,	    	value: "")
		self.doSetProperty(key: fromrelativememberidKey,	value: "0")
		self.doSetProperty(key: torelativememberidKey,		value: "0")
		self.doSetProperty(key: interactiontypeKey,			value: "1")
		self.doSetProperty(key: dateactionedKey,			value: "1/1/1900")
		self.doSetProperty(key: interactionstatusKey,		value: "1")
		self.doSetProperty(key: textKey,					value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.relativeInteraction_id.rawValue
		endEnumIndex	= ModelProperties.relativeInteraction_text.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]						= ModelProperties.relativeInteraction_id.rawValue
		keys[applicationidKey]			= ModelProperties.relativeInteraction_applicationID.rawValue
		keys[fromrelativememberidKey]	= ModelProperties.relativeInteraction_fromRelativeMemberID.rawValue
		keys[torelativememberidKey]		= ModelProperties.relativeInteraction_toRelativeMemberID.rawValue
		keys[interactiontypeKey]		= ModelProperties.relativeInteraction_interactionType.rawValue
		keys[dateactionedKey]			= ModelProperties.relativeInteraction_dateActioned.rawValue
		keys[interactionstatusKey]		= ModelProperties.relativeInteraction_interactionStatus.rawValue
		keys[textKey]					= ModelProperties.relativeInteraction_text.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "RelativeInteraction"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties from the specified item
		if let item = item as? RelativeInteraction {
			
			self.id						= item.id
			self.applicationID			= item.applicationID
			self.fromRelativeMemberID 	= item.fromRelativeMemberID
			self.toRelativeMemberID 	= item.toRelativeMemberID
			self.interactionType 		= item.interactionType
			self.dateActioned 			= item.dateActioned
			self.interactionStatus 		= item.interactionStatus
			self.text 					= item.text
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()
		
		result.ID 		= self.id
		
		result.setParameterValue(key: "\(RelativeInteractionDataParameterKeys.ApplicationID)", value: self.applicationID)
		result.setParameterValue(key: "\(RelativeInteractionDataParameterKeys.FromRelativeMemberID)", value: self.fromRelativeMemberID)
		result.setParameterValue(key: "\(RelativeInteractionDataParameterKeys.ToRelativeMemberID)", value: self.toRelativeMemberID)
		result.setParameterValue(key: "\(RelativeInteractionDataParameterKeys.InteractionType)", value: String(self.interactionType.rawValue))
		result.setParameterValue(key: "\(RelativeInteractionDataParameterKeys.DateActioned)", value: self.outputDateFormatter!.string(from: self.dateActioned))
		result.setParameterValue(key: "\(RelativeInteractionDataParameterKeys.InteractionStatus)", value: String(self.interactionStatus.rawValue))
		result.setParameterValue(key: "\(RelativeInteractionDataParameterKeys.Text)", value: self.text)
	
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper,
										 fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN 		= false
		
		// Copy all properties
		self.id 					= dataWrapper.ID
		self.applicationID 			= dataWrapper.getParameterValue(key: "\(RelativeInteractionDataParameterKeys.ApplicationID)")!
		self.fromRelativeMemberID 	= dataWrapper.getParameterValue(key: "\(RelativeInteractionDataParameterKeys.FromRelativeMemberID)")!
		self.toRelativeMemberID 	= dataWrapper.getParameterValue(key: "\(RelativeInteractionDataParameterKeys.ToRelativeMemberID)")!
		self.interactionType 		= RelativeInteractionTypes(rawValue: Int(dataWrapper.getParameterValue(key: "\(RelativeInteractionDataParameterKeys.InteractionType)")!)!)!
		self.dateActioned 			= DateHelper.getDate(fromString: dataWrapper.getParameterValue(key: "\(RelativeInteractionDataParameterKeys.DateActioned)")!, fromDateFormatter: fromDateFormatter)
		self.interactionStatus 		= RelativeInteractionStatus(rawValue: Int(dataWrapper.getParameterValue(key: "\(RelativeInteractionDataParameterKeys.InteractionStatus)")!)!)!
		self.text 					= dataWrapper.getParameterValue(key: "\(RelativeInteractionDataParameterKeys.Text)")!
		
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
	
	// Note: This method is overridden to implement culture specific formatting
	public override func getProperty(propertyEnum: Int, toDateFormatter: DateFormatter) -> String? {
		
		var result: String = ""
		
		switch toProperty(propertyEnum: propertyEnum) {
		case .relativeInteraction_dateActioned:
			
			result = toDateFormatter.string(from: self.dateActioned)
			break
			
		default:
			
			result = self.getProperty(propertyEnum: propertyEnum) ?? ""
			break
			
		}
		
		return result
		
	}
	
	// Note: This method is overridden to implement culture specific formatting
	public override func setProperty(key: String, value: String, setWhenInvalidYN: Bool, fromDateFormatter: DateFormatter) {
		
		var s: 				String = ""
		let propertyEnum: 	Int = self.toEnum(key: key)
		
		switch toProperty(propertyEnum: propertyEnum) {
		case .relativeInteraction_dateActioned:
			
			// Parse the value using fromDateFormatter
			s = self.doParseToStorageDateString(value: value, fromDateFormatter: fromDateFormatter)
			break
			
		default:
			
			s = value
			break
			
		}
		
		self.setProperty(key: key, value: s, setWhenInvalidYN: setWhenInvalidYN)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func toProperty(propertyEnum: Int) -> ModelProperties {
		
		return ModelProperties(rawValue: propertyEnum)!
	}
	
	
	// MARK: - Validations
	
}
