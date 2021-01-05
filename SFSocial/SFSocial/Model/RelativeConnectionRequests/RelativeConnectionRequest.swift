//
//  RelativeConnectionRequest.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSerialization

public enum RelativeConnectionRequestDataParameterKeys {
	case ID
	case ApplicationID
	case FromRelativeMemberID
	case ToRelativeMemberID
	case RequestType
	case DateActioned
	case RequestStatus
}

/// Encapsulates a RelativeConnectionRequest model item
public class RelativeConnectionRequest: ModelItemBase {
	
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
	
	let requesttypeKey: String = "RequestType"
	
	/// Gets or sets the requestType
	public var requestType: RelativeConnectionRequestTypes {
		get {
			let i = Int(self.getProperty(key: requesttypeKey)!)!
			
			return RelativeConnectionRequestTypes(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: requesttypeKey, value: String(i), setWhenInvalidYN: false)
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
	
	let requeststatusKey: String = "RequestStatus"
	
	/// Gets or sets the requestStatus
	public var requestStatus: RelativeConnectionRequestStatus {
		get {
			let i = Int(self.getProperty(key: requeststatusKey)!)!
			
			return RelativeConnectionRequestStatus(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: requeststatusKey, value: String(i), setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> RelativeConnectionRequestWrapper {
		
		let wrapper = RelativeConnectionRequestWrapper()
		
		wrapper.id						= self.id
		wrapper.applicationID 			= self.applicationID
		wrapper.fromRelativeMemberID 	= self.fromRelativeMemberID
		wrapper.toRelativeMemberID 		= self.toRelativeMemberID
		wrapper.requestType 			= self.requestType
		wrapper.dateActioned 			= self.dateActioned
		wrapper.requestStatus 			= self.requestStatus
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: RelativeConnectionRequestWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN 		= false
		
		// Copy all properties from the wrapper
		self.id						= wrapper.id
		self.applicationID			= wrapper.applicationID
		self.fromRelativeMemberID 	= wrapper.fromRelativeMemberID
		self.toRelativeMemberID 	= wrapper.toRelativeMemberID
		self.requestType 			= wrapper.requestType
		self.dateActioned 			= wrapper.dateActioned
		self.requestStatus	 		= wrapper.requestStatus
		
		self.doValidationsYN 		= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		// Setup the node data
		
		self.doSetProperty(key: idKey,						value: "0")
		self.doSetProperty(key: applicationidKey,	    	value: "")
		self.doSetProperty(key: fromrelativememberidKey,	value: "0")
		self.doSetProperty(key: torelativememberidKey,		value: "0")
		self.doSetProperty(key: requesttypeKey,				value: "1")
		self.doSetProperty(key: dateactionedKey,			value: "1/1/1900")
		self.doSetProperty(key: requeststatusKey,			value: "1")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.relativeConnectionRequest_id.rawValue
		endEnumIndex	= ModelProperties.relativeConnectionRequest_requestStatus.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]						= ModelProperties.relativeConnectionRequest_id.rawValue
		keys[applicationidKey]			= ModelProperties.relativeConnectionRequest_applicationID.rawValue
		keys[fromrelativememberidKey]	= ModelProperties.relativeConnectionRequest_fromRelativeMemberID.rawValue
		keys[torelativememberidKey]		= ModelProperties.relativeConnectionRequest_toRelativeMemberID.rawValue
		keys[requesttypeKey]			= ModelProperties.relativeConnectionRequest_requestType.rawValue
		keys[dateactionedKey]			= ModelProperties.relativeConnectionRequest_dateActioned.rawValue
		keys[requeststatusKey]			= ModelProperties.relativeConnectionRequest_requestStatus.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "RelativeConnectionRequest"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties from the specified item
		if let item = item as? RelativeConnectionRequest {
			
			self.id						= item.id
			self.applicationID			= item.applicationID
			self.fromRelativeMemberID 	= item.fromRelativeMemberID
			self.toRelativeMemberID 	= item.toRelativeMemberID
			self.requestType 			= item.requestType
			self.dateActioned 			= item.dateActioned
			self.requestStatus 			= item.requestStatus
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()
		
		result.ID 		= self.id
		result.setParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.ApplicationID)", value: self.applicationID)
		result.setParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.FromRelativeMemberID)", value: self.fromRelativeMemberID)
		result.setParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.ToRelativeMemberID)", value: self.toRelativeMemberID)
		result.setParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.RequestType)", value: String(self.requestType.rawValue))
		result.setParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.DateActioned)", value: self.outputDateFormatter!.string(from: self.dateActioned))
		result.setParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.RequestStatus)", value: String(self.requestStatus.rawValue))
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper,
										 fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN 		= false
	
		// Copy all properties
		self.id 					= dataWrapper.ID
		self.applicationID 			= dataWrapper.getParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.ApplicationID)")!
		self.fromRelativeMemberID 	= dataWrapper.getParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.FromRelativeMemberID)")!
		self.toRelativeMemberID 	= dataWrapper.getParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.ToRelativeMemberID)")!
		self.requestType 			= RelativeConnectionRequestTypes(rawValue: Int(dataWrapper.getParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.RequestType)")!)!)!
		self.dateActioned 			= DateHelper.getDate(fromString: dataWrapper.getParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.DateActioned)")!, fromDateFormatter: fromDateFormatter)
		self.requestStatus 			= RelativeConnectionRequestStatus(rawValue: Int(dataWrapper.getParameterValue(key: "\(RelativeConnectionRequestDataParameterKeys.RequestStatus)")!)!)!
		
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
		case .relativeConnectionRequest_dateActioned:
			
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
		case .relativeConnectionRequest_dateActioned:
			
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
