//
//  ProtocolModelAccessStrategy.swift
//  SFModel
//
//  Created by David on 22/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

// Defines a class which provides a strategy for accessing data
public protocol ProtocolModelAccessStrategy {

	// MARK: - Properties
	
	var tableName: String { get }
	
	
	// MARK: - Methods
	
	/// Commits all items in the collection
	///
	/// - Parameter collection: The collection
	///	- completionHandler: The completionHandler
	func commit(collection: ProtocolModelItemCollection, insertRelationalItemsYN: Bool, oncomplete completionHandler:@escaping (Error?) -> Void)
	
	/// Inserts the item
	///
	/// - Parameters:
	///   - item: The item
	///	  - completionHandler: The completionHandler
	func insert(item: ProtocolModelItem, insertRelationalItemsYN: Bool, oncomplete completionHandler:@escaping (String, Error?) -> Void)
	
	/// Updates the item
	///
	/// - Parameters:
	///   - item: The item
	///	  - completionHandler: The completionHandler
	func update(item: ProtocolModelItem, oncomplete completionHandler:@escaping (Error?) -> Void)
	
	/// Deletes the item
	///
	/// - Parameter:
	///   - item: The item
	///	  - completionHandler: The completionHandler
	func delete(item: ProtocolModelItem, oncomplete completionHandler:@escaping (Error?) -> Void)
	
	/// Selects all items
	///
	/// - Parameter:
	///   - collection: The collection
	///	  - completionHandler: The completionHandler
	func select(collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	/// Selects the item with the specified ID
	///
	/// - Parameters:
	///   - collection: The collection
	///   - id: The ID
	///	  - completionHandler: The completionHandler
	func select(collection: ProtocolModelItemCollection, id: Int, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	/// Selects the items before the specified ID
	///
	/// - Parameters:
	///   - collection: The collection
	///   - beforeID: The beforeID
	///   - includeBeforeIDItemYN: The includeBeforeIDItemYN
	///   - numberofItems: The numberofItems
	///	  - completionHandler: The completionHandler
	func selectBefore(collection: ProtocolModelItemCollection, beforeID: Int, includeBeforeIDItemYN: Bool, numberofItems: Int, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	/// Selects the items after the specified ID
	///
	/// - Parameters:
	///   - collection: The collection
	///   - afterID: The afterID
	///   - includeAfterIDItemYN: The includeAfterIDItemYN
	///   - numberofItems: The numberofItems
	///	  - completionHandler: The completionHandler
	func selectAfter(collection: ProtocolModelItemCollection, afterID: Int, includeAfterIDItemYN: Bool, numberofItems: Int, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	/// Selects the items between the specified rows
	///
	/// - Parameters:
	///   - collection: The collection
	///   - fromRowNumber: The fromRowNumber
	///   - toRowNumber: The toRowNumber
	///   - sortBy: The sortBy
	///	  - completionHandler: The completionHandler
	func selectBetween(collection: ProtocolModelItemCollection, fromRowNumber: Int, toRowNumber: Int, sortBy: Int, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	/// Selects the number of items
	///
	/// - Parameters:
	///   - collection: The collection
	///   - completionHandler: The completion handler
	func selectCount(collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping (Int, Error?) -> Void)
	
	/// Clears the list of omitted parameter keys
	///
	func clearOmittedParameterKeys()
	
	/// Sets the omitted parameter
	///
	/// - Parameter key: The key
	func setOmittedParameter(key: String)
	
	/// Determines whether the parameter is omitted
	///
	/// - Parameter key: The key
	/// - Returns: Returns true if the parameter is omitted
	func isParameterOmitted(key: String) -> Bool
	
	/// Fills the collection with the specified data
	///
	/// - Parameters:
	///   - collection: The collection
	///   - data: The data
	/// - Returns: The collection
	func fillCollection(collection: ProtocolModelItemCollection, data: [Any]) -> ProtocolModelItemCollection?
	
	/// Fills the collection with the specified data
	///
	/// - Parameters:
	///   - collection: The collection
	///   - data: The data
	///   - appendYN: The appendYN
	/// - Returns: The collection
	func fillCollection(collection: ProtocolModelItemCollection, data: [Any], appendYN: Bool) -> ProtocolModelItemCollection?
}
