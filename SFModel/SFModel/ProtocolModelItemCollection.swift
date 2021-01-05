//
//  ProtocolModelItemCollection.swift
//  SFModel
//
//  Created by David on 22/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a model item collection
public protocol ProtocolModelItemCollection: class {

	// MARK: - Properties
	
	/// dataType
	var dataType:					String { get }
	
	/// dataDocument
	var dataDocument:				[[String : Any]] { get }
	
	/// items
	var items:						[ProtocolModelItem]? { get }
	
	/// modelAdministrator
	weak var modelAdministrator:	ProtocolModelAdministrator? { get }
	
	
	// MARK: - Methods
	
	/// Adds a delegate
	///
	/// - Parameter delegate: The delegate
	//func add(delegate: ProtocolModelItemCollectionDelegate)
	
	/// Clears the collection
	func clear()
	
	/// Gets the next ID
	///
	/// - Returns: The next ID
	func getNextID() -> String
	
	/// Gets a new item
	///
	/// - Returns: The new item
	func getNewItem() -> ProtocolModelItem?
	
	/// Gets a new item
	///
	/// - Parameter:
	///   - dataNode: The data node
	///   - fromDateFormatter: The fromDateFormatter
	/// - Returns: The new item
	func getNewItem(dataNode:[String: Any], fromDateFormatter: DateFormatter) -> ProtocolModelItem?
	
	/// Adds a new item
	///
	/// - Returns: The new item
	func addItem() -> ProtocolModelItem
	
	/// Adds a specified item
	///
	/// - Parameter item: The item
	func addItem(item: ProtocolModelItem)
	
	/// Removes the specified item
	///
	/// - Parameter item: The item
	func removeItem(item: ProtocolModelItem)
	
	/// Gets an item
	///
	/// - Parameter id: The ID
	/// - Returns: The item
	func getItem(id: String) -> ProtocolModelItem?
	
	/// Gets an item
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - value: The value
	/// - Returns: The item
	func getItem(propertyEnum: Int, value: String) -> ProtocolModelItem?
	
	/// Gets an item
	///
	/// - Parameters:
	///   - propertyKey: The propertyKey
	///   - value: The value
	/// - Returns: The item
	func getItem(propertyKey: String, value: String) -> ProtocolModelItem?
	
	/// Gets items
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - value: The value
	/// - Returns: The items
	func getItems(propertyEnum: Int, value: String) -> [ProtocolModelItem]
	
	/// Gets items
	///
	/// - Parameters:
	///   - propertyKey: The propertyKey
	///   - value: The value
	/// - Returns: The items
	func getItems(propertyKey: String, value: String) -> [ProtocolModelItem]
	
	/// Sorts the items by the specified property
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - ascending: If true sorts by ascending value
	/// - Returns: The items
	func sortBy(propertyEnum: Int, ascending: Bool) -> [ProtocolModelItem]
	
	/// Sets a setting
	///
	/// - Parameters:
	///   - key: The key
	///   - value: The value
	func setSetting(key: String, value: Any)
	
	/// Gets a setting
	///
	/// - Parameter key: The key
	/// - Returns: The value
	func getSetting(key: String) -> Any?
	
	
	// MARK: - Delegate Notifications
	
	/// Occurs when the data item is modified
	///
	/// - Parameters:
	///   - item: The item
	///   - propertyEnum: The propertyEnum
	///   - message: The message
	func onItemModified(item: ProtocolModelItem, propertyEnum:Int, message: String)
	
	/// Occurs when the status of the data item is changed
	///
	/// - Parameters:
	///   - item: The item
	///   - status: The status
	///   - message: The message
	func onItemStatusChanged(item: ProtocolModelItem, status: ModelItemStatusTypes, message: String)
	
	/// Occurs when the primary key of the item is modified
	///
	/// - Parameters:
	///   - item: The item
	///   - id: The id
	///   - previousID: The previousID
	func onItemPrimaryKeyModified(item: ProtocolModelItem, id: String, previousID: String)
	
	/// Occurs when a validation has passed
	///
	/// - Parameters:
	///   - item: The item
	///   - propertyEnum: The propertyEnum
	///   - message: The message
	///   - resultType: The resultType
	func onItemValidationPassed(item: ProtocolHasValidations, propertyEnum: Int, message: String, resultType: ValidationResultTypes)
	
	/// Occurs when a validation has passed
	///
	/// - Parameters:
	///   - item: The item
	///   - propertyEnum: The propertyEnum
	///   - message: The message
	///   - resultType: The resultType
	func onItemValidationFailed(item: ProtocolHasValidations, propertyEnum: Int, message: String, resultType: ValidationResultTypes)
}
