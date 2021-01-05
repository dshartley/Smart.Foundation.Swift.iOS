//
//  RelativeConnection.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSerialization

public enum RelativeConnectionDataParameterKeys {
	case ID
	case ApplicationID
	case FromRelativeMemberID
	case ToRelativeMemberID
	case ConnectionContractType
	case DateActioned
	case DateLastActive
	case ConnectionStatus
}

/// Encapsulates a RelativeConnection model item
public class RelativeConnection: ModelItemBase {
	
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
	
	let connectioncontracttypeKey: String = "ConnectionContractType"
	
	/// Gets or sets the connectionContractType
	public var connectionContractType: RelativeConnectionContractTypes {
		get {
			let i = Int(self.getProperty(key: connectioncontracttypeKey)!)!
			
			return RelativeConnectionContractTypes(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: connectioncontracttypeKey, value: String(i), setWhenInvalidYN: false)
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

	let datelastactiveKey: String = "DateLastActive"
	
	/// Gets or sets the dateLastActive
	public var dateLastActive: Date {
		get {
			
			let dateString = self.getProperty(key: datelastactiveKey)!
			
			return DateHelper.getDate(fromString: dateString, fromDateFormatter: self.storageDateFormatter!)
		}
		set(value) {
			
			self.setProperty(key: datelastactiveKey, value: self.getStorageDateString(fromDate: value), setWhenInvalidYN: false)
		}
	}
	
	let connectionstatusKey: String = "ConnectionStatus"
	
	/// Gets or sets the connectionStatus
	public var connectionStatus: RelativeConnectionStatus {
		get {
			let i = Int(self.getProperty(key: connectionstatusKey)!)!
			
			return RelativeConnectionStatus(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: connectionstatusKey, value: String(i), setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> RelativeConnectionWrapper {
		
		let wrapper = RelativeConnectionWrapper()
		
		wrapper.id					        = self.id
		wrapper.applicationID 				= self.applicationID
		wrapper.fromRelativeMemberID 	    = self.fromRelativeMemberID
		wrapper.toRelativeMemberID 	        = self.toRelativeMemberID
		wrapper.connectionContractType 		= self.connectionContractType
		wrapper.dateActioned 		        = self.dateActioned
		wrapper.dateLastActive 		        = self.dateLastActive
		wrapper.connectionStatus 	        = self.connectionStatus
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: RelativeConnectionWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 		    Bool = self.doValidationsYN
		self.doValidationsYN 		    = false
		
		// Copy all properties from the wrapper
		self.id						    = wrapper.id
		self.applicationID				= wrapper.applicationID
		self.fromRelativeMemberID 		= wrapper.fromRelativeMemberID
		self.toRelativeMemberID 		= wrapper.toRelativeMemberID
		self.connectionContractType 	= wrapper.connectionContractType
		self.dateActioned 			    = wrapper.dateActioned
		self.dateLastActive				= wrapper.dateLastActive
		self.connectionStatus	 	    = wrapper.connectionStatus
		
		self.doValidationsYN 		    = doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		// Setup the node data
		
		self.doSetProperty(key: idKey,					    value: "0")
		self.doSetProperty(key: applicationidKey,	    	value: "")
		self.doSetProperty(key: fromrelativememberidKey,	value: "0")
		self.doSetProperty(key: torelativememberidKey,		value: "0")
		self.doSetProperty(key: connectioncontracttypeKey,	value: "1")
		self.doSetProperty(key: dateactionedKey,		    value: "1/1/1900")
		self.doSetProperty(key: datelastactiveKey,		    value: "1/1/1900")
		self.doSetProperty(key: connectionstatusKey,	    value: "1")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.relativeConnection_id.rawValue
		endEnumIndex	= ModelProperties.relativeConnection_connectionStatus.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]					        = ModelProperties.relativeConnection_id.rawValue
		keys[applicationidKey]				= ModelProperties.relativeConnection_applicationID.rawValue
		keys[fromrelativememberidKey]	    = ModelProperties.relativeConnection_fromRelativeMemberID.rawValue
		keys[torelativememberidKey]	        = ModelProperties.relativeConnection_toRelativeMemberID.rawValue
		keys[connectioncontracttypeKey]		= ModelProperties.relativeConnection_connectionContractType.rawValue
		keys[dateactionedKey]		        = ModelProperties.relativeConnection_dateActioned.rawValue
		keys[datelastactiveKey]		        = ModelProperties.relativeConnection_dateLastActive.rawValue
		keys[connectionstatusKey]	        = ModelProperties.relativeConnection_connectionStatus.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "RelativeConnection"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties from the specified item
		if let item = item as? RelativeConnection {
			
			self.id						    = item.id
			self.applicationID				= item.applicationID
			self.fromRelativeMemberID 		= item.fromRelativeMemberID
			self.toRelativeMemberID 		= item.toRelativeMemberID
			self.connectionContractType 	= item.connectionContractType
			self.dateActioned 			    = item.dateActioned
			self.dateLastActive				= item.dateLastActive
			self.connectionStatus 		    = item.connectionStatus
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()
		
		result.ID 		= self.id
		
		result.setParameterValue(key: "\(RelativeConnectionDataParameterKeys.ApplicationID)", value: self.applicationID)
		result.setParameterValue(key: "\(RelativeConnectionDataParameterKeys.FromRelativeMemberID)", value: self.fromRelativeMemberID)
		result.setParameterValue(key: "\(RelativeConnectionDataParameterKeys.ToRelativeMemberID)", value: self.toRelativeMemberID)
		result.setParameterValue(key: "\(RelativeConnectionDataParameterKeys.ConnectionContractType)", value: String(self.connectionContractType.rawValue))
		result.setParameterValue(key: "\(RelativeConnectionDataParameterKeys.DateActioned)", value: self.outputDateFormatter!.string(from: self.dateActioned))
		result.setParameterValue(key: "\(RelativeConnectionDataParameterKeys.DateLastActive)", value: self.outputDateFormatter!.string(from: self.dateLastActive))
		result.setParameterValue(key: "\(RelativeConnectionDataParameterKeys.ConnectionStatus)", value: String(self.connectionStatus.rawValue))
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper,
										 fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties
		self.id 						= dataWrapper.ID
		self.applicationID 				= dataWrapper.getParameterValue(key: "\(RelativeConnectionDataParameterKeys.ApplicationID)")!
		self.fromRelativeMemberID 		= dataWrapper.getParameterValue(key: "\(RelativeConnectionDataParameterKeys.FromRelativeMemberID)")!
		self.toRelativeMemberID 		= dataWrapper.getParameterValue(key: "\(RelativeConnectionDataParameterKeys.ToRelativeMemberID)")!
		self.connectionContractType 	= RelativeConnectionContractTypes(rawValue: Int(dataWrapper.getParameterValue(key: "\(RelativeConnectionDataParameterKeys.ConnectionContractType)")!)!)!
		self.dateActioned 				= DateHelper.getDate(fromString: dataWrapper.getParameterValue(key: "\(RelativeConnectionDataParameterKeys.DateActioned)")!, fromDateFormatter: fromDateFormatter)
		self.dateLastActive 			= DateHelper.getDate(fromString: dataWrapper.getParameterValue(key: "\(RelativeConnectionDataParameterKeys.DateLastActive)")!, fromDateFormatter: fromDateFormatter)
		self.connectionStatus 			= RelativeConnectionStatus(rawValue: Int(dataWrapper.getParameterValue(key: "\(RelativeConnectionDataParameterKeys.ConnectionStatus)")!)!)!
		
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
		case .relativeConnection_dateActioned:
			
			result = toDateFormatter.string(from: self.dateActioned)
			break

		case .relativeConnection_dateLastActive:
			
			result = toDateFormatter.string(from: self.dateLastActive)
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
		case .relativeConnection_dateActioned:
			
			// Parse the value using fromDateFormatter
			s = self.doParseToStorageDateString(value: value, fromDateFormatter: fromDateFormatter)
			break

		case .relativeConnection_dateLastActive:
			
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
