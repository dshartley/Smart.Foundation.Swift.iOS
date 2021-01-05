//
//  ProtocolModelAdministratorDelegate.swift
//  SFModel
//
//  Created by David on 17/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a ProtocolModelAdministrator class
public protocol ProtocolModelAdministratorDelegate: class {
	
	// MARK: - Methods
	
	func modelAdministrator(item: ProtocolModelItem,		itemModifiedFor propertyEnum: Int, message: String)
	
	func modelAdministrator(item: ProtocolModelItem,		itemStatusChangedTo status: ModelItemStatusTypes, message: String)
	
	func modelAdministrator(item: ProtocolModelItem,		itemPrimaryKeyModifiedTo id: String, previousID: String)
	
	func modelAdministrator(item: ProtocolHasValidations,	itemValidationPassedFor propertyEnum: Int, message: String, resultType: ValidationResultTypes)
	
	func modelAdministrator(item: ProtocolHasValidations,	itemValidationFailedFor propertyEnum: Int, message: String, resultType: ValidationResultTypes)
	
	func modelAdministratorDataLoaded()
	
	func modelAdministratorDataSaved()
}
