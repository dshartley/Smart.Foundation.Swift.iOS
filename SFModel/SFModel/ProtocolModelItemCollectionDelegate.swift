//
//  ProtocolModelItemCollectionDelegate.swift
//  SFModel
//
//  Created by David on 17/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a ProtocolModelItemCollection class
public protocol ProtocolModelItemCollectionDelegate: class {

	// MARK: - Methods
	
	func modelItemCollection(item: ProtocolModelItem,		itemModifiedFor propertyEnum: Int, message: String)
	
	func modelItemCollection(item: ProtocolModelItem,		itemStatusChangedTo status: ModelItemStatusTypes, message: String)
	
	func modelItemCollection(item: ProtocolModelItem,		itemPrimaryKeyModifiedTo id: String, previousID: String)
	
	func modelItemCollection(item: ProtocolHasValidations,	itemValidationPassedFor propertyEnum: Int, message: String, resultType: ValidationResultTypes)
	
	func modelItemCollection(item: ProtocolHasValidations,	itemValidationFailedFor propertyEnum: Int, message: String, resultType: ValidationResultTypes)
}
