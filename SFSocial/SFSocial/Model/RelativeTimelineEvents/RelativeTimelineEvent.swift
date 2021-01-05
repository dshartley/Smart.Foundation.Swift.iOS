//
//  RelativeTimelineEvent.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSerialization

public enum RelativeTimelineEventDataParameterKeys {
	case ID
	case ApplicationID
	case ForRelativeMemberID
	case CurrentRelativeMemberID
	case RelativeInteractionID
	case EventType
	case DateActioned
	case EventStatus
	case PreviousRelativeTimelineEventID
	case NumberOfItemsToLoad
	case SelectItemsAfterPreviousYN
	case RelativeTimelineEventTypes
}

/// Encapsulates a RelativeTimelineEvent model item
public class RelativeTimelineEvent: ModelItemBase {
	
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
	
	let forrelativememberidKey: String = "ForRelativeMemberID"
	
	/// Gets or sets the forRelativeMemberID
	public var forRelativeMemberID: String {
		get {
			
			return self.getProperty(key: forrelativememberidKey)!
		}
		set(value) {
			
			self.setProperty(key: forrelativememberidKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let relativeinteractionidKey: String = "RelativeInteractionID"
	
	/// Gets or sets the relativeInteractionID
	public var relativeInteractionID: String {
		get {
			
			return self.getProperty(key: relativeinteractionidKey)!
		}
		set(value) {
			
			self.setProperty(key: relativeinteractionidKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let eventtypeKey: String = "EventType"
	
	/// Gets or sets the eventType
	public var eventType: RelativeTimelineEventTypes {
		get {
			let i = Int(self.getProperty(key: eventtypeKey)!)!
			
			return RelativeTimelineEventTypes(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: eventtypeKey, value: String(i), setWhenInvalidYN: false)
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
	
	let eventstatusKey: String = "EventStatus"
	
	/// Gets or sets the eventStatus
	public var eventStatus: RelativeTimelineEventStatus {
		get {
			let i = Int(self.getProperty(key: eventstatusKey)!)!
			
			return RelativeTimelineEventStatus(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: eventstatusKey, value: String(i), setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> RelativeTimelineEventWrapper {
		
		let wrapper = RelativeTimelineEventWrapper()
		
		wrapper.id							= self.id
		wrapper.applicationID 				= self.applicationID
		wrapper.forRelativeMemberID 		= self.forRelativeMemberID
		wrapper.relativeInteractionID 		= self.relativeInteractionID
		wrapper.eventType 					= self.eventType
		wrapper.dateActioned 				= self.dateActioned
		wrapper.eventStatus 				= self.eventStatus
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: RelativeTimelineEventWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN 		= false
		
		// Copy all properties from the wrapper
		self.id						= wrapper.id
		self.applicationID			= wrapper.applicationID
		self.forRelativeMemberID 	= wrapper.forRelativeMemberID
		self.relativeInteractionID 	= wrapper.relativeInteractionID
		self.eventType 				= wrapper.eventType
		self.dateActioned 			= wrapper.dateActioned
		self.eventStatus	 		= wrapper.eventStatus
		
		self.doValidationsYN 		= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		// Setup the node data
		
		self.doSetProperty(key: idKey,						value: "0")
		self.doSetProperty(key: applicationidKey,	    	value: "")
		self.doSetProperty(key: forrelativememberidKey,		value: "0")
		self.doSetProperty(key: relativeinteractionidKey,	value: "0")
		self.doSetProperty(key: eventtypeKey,				value: "1")
		self.doSetProperty(key: dateactionedKey,			value: "1/1/1900")
		self.doSetProperty(key: eventstatusKey,				value: "1")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.relativeTimelineEvent_id.rawValue
		endEnumIndex	= ModelProperties.relativeTimelineEvent_eventStatus.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]							= ModelProperties.relativeTimelineEvent_id.rawValue
		keys[applicationidKey]				= ModelProperties.relativeTimelineEvent_applicationID.rawValue
		keys[forrelativememberidKey]		= ModelProperties.relativeTimelineEvent_forRelativeMemberID.rawValue
		keys[relativeinteractionidKey]		= ModelProperties.relativeTimelineEvent_relativeInteractionID.rawValue
		keys[eventtypeKey]					= ModelProperties.relativeTimelineEvent_eventType.rawValue
		keys[dateactionedKey]				= ModelProperties.relativeTimelineEvent_dateActioned.rawValue
		keys[eventstatusKey]				= ModelProperties.relativeTimelineEvent_eventStatus.rawValue

	}
	
	public override var dataType: String {
		get {
			return "RelativeTimelineEvent"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN 				= false
		
		// Copy all properties from the specified item
		if let item = item as? RelativeTimelineEvent {
			
			self.id							= item.id
			self.applicationID				= item.applicationID
			self.forRelativeMemberID 		= item.forRelativeMemberID
			self.relativeInteractionID 		= item.relativeInteractionID
			self.eventType 					= item.eventType
			self.dateActioned 				= item.dateActioned
			self.eventStatus 				= item.eventStatus
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()
		
		result.ID 		= self.id
		
		result.setParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.ApplicationID)", value: self.applicationID)
		result.setParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.ForRelativeMemberID)", value: self.forRelativeMemberID)
		result.setParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.RelativeInteractionID)", value: self.relativeInteractionID)
		result.setParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.EventType)", value: String(self.eventType.rawValue))
		result.setParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.DateActioned)", value: self.outputDateFormatter!.string(from: self.dateActioned))
		result.setParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.EventStatus)", value: String(self.eventStatus.rawValue))
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper,
										 fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties
		self.id 						= dataWrapper.ID
		self.applicationID 				= dataWrapper.getParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.ApplicationID)")!
		self.forRelativeMemberID 		= dataWrapper.getParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.ForRelativeMemberID)")!
		self.relativeInteractionID 		= dataWrapper.getParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.RelativeInteractionID)")!
		self.eventType 					= RelativeTimelineEventTypes(rawValue: Int(dataWrapper.getParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.EventType)")!)!)!
		self.dateActioned 				= DateHelper.getDate(fromString: dataWrapper.getParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.DateActioned)")!, fromDateFormatter: fromDateFormatter)
		self.eventStatus 				= RelativeTimelineEventStatus(rawValue: Int(dataWrapper.getParameterValue(key: "\(RelativeTimelineEventDataParameterKeys.EventStatus)")!)!)!
		
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
	
	// Note: This method is overridden to implement culture specific formatting
	public override func getProperty(propertyEnum: Int, toDateFormatter: DateFormatter) -> String? {
		
		var result: String = ""
		
		switch toProperty(propertyEnum: propertyEnum) {
		case .relativeTimelineEvent_dateActioned:
			
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
		case .relativeTimelineEvent_dateActioned:
			
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
