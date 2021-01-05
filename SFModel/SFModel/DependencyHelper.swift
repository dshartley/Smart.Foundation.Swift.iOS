//
//  DependencyHelper.swift
//  SFModel
//
//  Created by David on 19/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Helps to manage dependency items based on a foreign key
public struct DependencyHelper {

	// MARK: - Private Stored Properties
	
	fileprivate var dependencyModelAdministrator:	ProtocolModelAdministrator?
	fileprivate var parentItem:						ProtocolModelItem?
	fileprivate var foreignKeyIDPropertyEnum:		Int = 0
	
	
	// MARK: - Initializers
	
	private init() {
	}
	
	public init(	dependencyModelAdministrator:	ProtocolModelAdministrator,
	            	parentItem:						ProtocolModelItem,
	            	foreignKeyIDPropertyEnum:		Int) {
		
		self.dependencyModelAdministrator	= dependencyModelAdministrator
		self.parentItem						= parentItem
		self.foreignKeyIDPropertyEnum		= foreignKeyIDPropertyEnum
	}
	
	
	// MARK: - Public Methods
	
	public func setForeignKeyByPropertyValue(propertyEnum: Int, value: String) -> Bool {
		
		// Get the foreign key item with the specified property value
		let item: ProtocolModelItem? = self.dependencyModelAdministrator!.collection!.getItem(propertyEnum: propertyEnum, value: value)
		
		if (item != nil) {
			
			// Set the foreign key ID
			self.parentItem!.setProperty(propertyEnum: self.foreignKeyIDPropertyEnum, value: String(item!.id), setWhenInvalidYN: true)
			
			return true
			
		} else {
			
			return false
		}
	}
	
	public func getForeignKeyPropertyValue(propertyEnum: Int) -> String {
		
		// Get the foreign key ID
		let id:		String = String(self.parentItem!.getProperty(propertyEnum: self.foreignKeyIDPropertyEnum)!)
		
		var value:	String = ""
		
		// Get the item from the collection
		let item:	ProtocolModelItem? = self.dependencyModelAdministrator!.collection?.getItem(id: id)
		
		if (item != nil) { value = item!.getProperty(propertyEnum: propertyEnum)! }
		
		return value
	}
}
