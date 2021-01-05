//
//  RelativeMember.swift
//  SFSocial
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization

public enum RelativeMemberDataParameterKeys {
	case ID
	case ApplicationID
	case UserProfileID
	case Email
	case FindText
	case FullName
	case AvatarImageFileName
	case ConnectionContractType
	case CurrentRelativeMemberID
	case ConnectionContractTypes
	case ScopeType
	case AspectTypes
	case PreviousRelativeMemberID
	case NumberOfItemsToLoad
	case SelectItemsAfterPreviousYN
}

/// Encapsulates a RelativeMember model item
public class RelativeMember: ModelItemBase {
	
	// MARK: - Public Stored Properties
	
	public var avatarImageData: Data?
	
	
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
	
	let userprofileidKey: String = "UserProfileID"
	
	/// Gets or sets the userProfileID
	public var userProfileID: String {
		get {
			
			return self.getProperty(key: userprofileidKey)!
		}
		set(value) {
			
			self.setProperty(key: userprofileidKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let emailKey: String = "Email"
	
	/// Gets or sets the email
	public var email: String {
		get {
			
			return self.getProperty(key: emailKey)!
		}
		set(value) {
			
			self.setProperty(key: emailKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let fullnameKey: String = "FullName"
	
	/// Gets or sets the fullName
	public var fullName: String {
		get {
			
			return self.getProperty(key: fullnameKey)!
		}
		set(value) {
			
			self.setProperty(key: fullnameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let avatarimagefilenameKey: String = "AvatarImageFileName"
	
	/// Gets or sets the avatarImageFileName
	public var avatarImageFileName: String {
		get {
			
			return self.getProperty(key: avatarimagefilenameKey)!
		}
		set(value) {
			
			self.setProperty(key: avatarimagefilenameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let connectioncontracttypesKey: String = "ConnectionContractTypes"
	
	/// Gets or sets the connectionContractTypes
	public var connectionContractTypes: String {
		get {
			
			return self.getProperty(key: connectioncontracttypesKey)!
		}
		set(value) {
			
			self.setProperty(key: connectioncontracttypesKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> RelativeMemberWrapper {
		
		let wrapper = RelativeMemberWrapper()
		
		wrapper.id					    = self.id
		wrapper.applicationID 			= self.applicationID
		wrapper.userProfileID 	        = self.userProfileID
		wrapper.email					= self.email
		wrapper.fullName 				= self.fullName
		wrapper.avatarImageFileName 	= self.avatarImageFileName
		wrapper.avatarImageData 		= self.avatarImageData
		wrapper.connectionContractTypes	= self.connectionContractTypes
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: RelativeMemberWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN			= false
		
		// Copy all properties from the wrapper
		self.id							= wrapper.id
		self.applicationID				= wrapper.applicationID
		self.userProfileID 		    	= wrapper.userProfileID
		self.email						= wrapper.email
		self.fullName 					= wrapper.fullName
		self.avatarImageFileName 		= wrapper.avatarImageFileName
		self.avatarImageData			= wrapper.avatarImageData
		self.connectionContractTypes	= wrapper.connectionContractTypes
		
		self.doValidationsYN 			= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: applicationidKey,	    	value: "")
		self.doSetProperty(key: userprofileidKey,	    	value: "0")
		self.doSetProperty(key: emailKey,	    			value: "")
		self.doSetProperty(key: fullnameKey,		    	value: "")
		self.doSetProperty(key: avatarimagefilenameKey,		value: "")
		self.doSetProperty(key: connectioncontracttypesKey,	value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.relativeMember_id.rawValue
		endEnumIndex	= ModelProperties.relativeMember_connectionContractTypes.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]					    	= ModelProperties.relativeMember_id.rawValue
		keys[applicationidKey]				= ModelProperties.relativeMember_applicationID.rawValue
		keys[userprofileidKey]	        	= ModelProperties.relativeMember_userProfileID.rawValue
		keys[emailKey]	        			= ModelProperties.relativeMember_email.rawValue
		keys[fullnameKey]	        		= ModelProperties.relativeMember_fullName.rawValue
		keys[avatarimagefilenameKey]		= ModelProperties.relativeMember_avatarImageFileName.rawValue
		keys[connectioncontracttypesKey]	= ModelProperties.relativeMember_connectionContractTypes.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "RelativeMember"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 				Bool = self.doValidationsYN
		self.doValidationsYN 				= false
		
		// Copy all properties from the specified item
		if let item = item as? RelativeMember {
			
			self.id							= item.id
			self.applicationID				= item.applicationID
			self.userProfileID 		    	= item.userProfileID
			self.email						= item.email
			self.fullName 		    		= item.fullName
			self.avatarImageFileName 		= item.avatarImageFileName
			self.avatarImageData 			= item.avatarImageData
			self.connectionContractTypes 	= item.connectionContractTypes
	
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(RelativeMemberDataParameterKeys.ApplicationID)", value: self.applicationID)
		result.setParameterValue(key: "\(RelativeMemberDataParameterKeys.UserProfileID)", value: self.userProfileID)
		result.setParameterValue(key: "\(RelativeMemberDataParameterKeys.Email)", value: self.email)
		result.setParameterValue(key: "\(RelativeMemberDataParameterKeys.FullName)", value: self.fullName)
		result.setParameterValue(key: "\(RelativeMemberDataParameterKeys.AvatarImageFileName)", value: self.avatarImageFileName)
		result.setParameterValue(key: "\(RelativeMemberDataParameterKeys.ConnectionContractTypes)", value: self.connectionContractTypes)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 			Bool = self.doValidationsYN
		self.doValidationsYN 			= false
		
		// Copy all properties
		self.id 						= dataWrapper.ID
		self.applicationID 				= dataWrapper.getParameterValue(key: "\(RelativeMemberDataParameterKeys.ApplicationID)")!
		self.userProfileID 				= dataWrapper.getParameterValue(key: "\(RelativeMemberDataParameterKeys.UserProfileID)")!
		self.email 						= dataWrapper.getParameterValue(key: "\(RelativeMemberDataParameterKeys.Email)")!
		self.fullName 					= dataWrapper.getParameterValue(key: "\(RelativeMemberDataParameterKeys.FullName)")!
		self.avatarImageFileName 		= dataWrapper.getParameterValue(key: "\(RelativeMemberDataParameterKeys.AvatarImageFileName)")!
		self.connectionContractTypes 	= dataWrapper.getParameterValue(key: "\(RelativeMemberDataParameterKeys.ConnectionContractTypes)") ?? ""
		
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
