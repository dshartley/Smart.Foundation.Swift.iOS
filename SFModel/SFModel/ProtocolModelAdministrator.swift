//
//  ProtocolModelAdministrator.swift
//  SFModel
//
//  Created by David on 22/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSerialization

/// Defines a model administrator
public protocol ProtocolModelAdministrator: class {
	
	// MARK: - Properties
	
	/// modelAccessStrategy
	var modelAccessStrategy:			ProtocolModelAccessStrategy? { get set }
	
	/// collection
	var collection:						ProtocolModelItemCollection? { get }
	
	/// dataIsLoadedYN
	var dataIsLoadedYN:					Bool { get }
	
	/// dataIsSavedYN
	var dataIsSavedYN:					Bool { get }
	
	/// modelAdministratorProvider
	var modelAdministratorProvider:		ProtocolModelAdministratorProvider? { get }
	
	var tableName: 						String { get }
	
	
	// MARK: - Methods
	
	/// Initialises the model administrator
	///
	func initialise()
	
	/// Loads the data
	///
	/// - Parameter completionHandler: The completionHandler
	func load(oncomplete completionHandler:@escaping (Error?) -> Void)
	
	/// Loads the items from the specified data
	///
	/// - Parameter:
	///   - data: The data
	///	  - completionHandler: The completionHandler
	func load(data: [Any])
	
	/// Loads the item with the specified ID
	///
	/// - Parameter:
	///   - id: The ID
	///	  - completionHandler: The completionHandler
	func load(id: Int, oncomplete completionHandler:@escaping (Error?) -> Void)
	
	/// Loads a number of items before the specified item
	///
	/// - Parameters:
	///   - beforeID: The beforeID
	///   - includeBeforeIDItemYN: The includeBeforeIDItemYN
	///   - numberofItems: The numberofItems
	///	  - completionHandler: The completionHandler
	func loadItemsBefore(beforeID: Int, includeBeforeIDItemYN: Bool, numberofItems: Int, oncomplete completionHandler:@escaping (Error?) -> Void)

	/// Loads a number of items after the specified item
	///
	/// - Parameters:
	///   - afterID: The afterID
	///   - includeAfterIDItemYN: The includeAfterIDItemYN
	///   - numberofItems: The numberofItems
	///	  - completionHandler: The completionHandler
	func loadItemsAfter(afterID: Int, includeAfterIDItemYN: Bool, numberofItems: Int, oncomplete completionHandler:@escaping (Error?) -> Void)
	
	/// Loads item between the specified row numbers
	///
	/// - Parameters:
	///   - fromRowNumber: The fromRowNumber
	///   - toRowNumber: The toRowNumber
	///   - sortBy: The sortBy
	///	  - completionHandler: The completionHandler
	func loadItemsBetween(fromRowNumber: Int, toRowNumber: Int, sortBy: Int, oncomplete completionHandler:@escaping (Error?) -> Void)
	
	/// Returns a count of all items in the data source
	///
	/// - Parameter completionHandler: The completionHandler
	func countAll(oncomplete completionHandler:@escaping (Int, Error?) -> Void)
	
	/// Saves the data
	///
	/// - Parameter completionHandler: The completionHandler
	func save(oncomplete completionHandler:@escaping (Error?) -> Void)
	
	/// Gets a new item
	///
	/// - Returns: The item
	func getNewItem() -> ProtocolModelItem
	
	/// Adds the specified item
	///
	/// - Parameter item: The item
	func addItem(item: ProtocolModelItem)
	
	/// Removes the specified item
	///
	/// - Parameter item: The item
	func removeItem(item: ProtocolModelItem)
	
	/// Copies the specified item
	///
	/// - Parameter item: The item
	/// - Returns: The item copy
	func copyItem(item: ProtocolModelItem) -> ProtocolModelItem
	
	/// Copies the data to a wrapper
	///
	/// - Returns: The wrapper
	func toWrapper() -> DataJSONWrapper
	
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
	
	/// Occurs when the data is loaded
	///
	func onDataLoaded()
	
	/// Occurs when the data is saved
	///
	func onDataSaved()
	
}
