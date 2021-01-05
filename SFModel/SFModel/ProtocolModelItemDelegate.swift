//
//  ProtocolModelItemDelegate.swift
//  SFModel
//
//  Created by David on 26/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a ProtocolModelItem class
public protocol ProtocolModelItemDelegate: class {
	
	// MARK: - Methods
	
	func modelItem(item: ProtocolModelItem, modifiedFor				propertyEnum: Int, message: String)
	
	func modelItem(item: ProtocolModelItem, statusChangedTo			status: ModelItemStatusTypes, message: String)
	
	func modelItem(item: ProtocolModelItem, primaryKeyModifiedTo	id: String, previousID: String)
	
}
