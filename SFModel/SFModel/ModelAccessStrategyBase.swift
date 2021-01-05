//
//  ModelAccessStrategyBase.swift
//  SFModel
//
//  Created by David on 19/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSerialization

/// Specifies query parameter keys
fileprivate enum QueryParameterKeys : Int {
	case beforeID
	case includeBeforeIDItem
	case afterID
	case includeAfterIDItem
	case rowCount
	case fromRowNumber
	case toRowNumber
	case sortBy
}

/// Specifies query attribute keys
fileprivate enum QueryAttributeKeys {
	case tableName
}

/// Specifies query types
public enum QueryTypes : Int {
	case insert
	case update
	case delete
	case select
	case selectByID
	case selectBefore
	case selectAfter
	case selectBetween
	case selectCount
}

/// A base class for model access strategy classes
open class ModelAccessStrategyBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate: 				ProtocolModelAccessStrategyDelegate?
	public var tableName:					String = ""
	public var connectionString:			String = ""
	public var omittedParameterKeys:		[String]?
	public let primaryKeyColumnName:		String = "ID"
	public let relationalDataColumnName:	String = "RelationalDataJSON"
	public let rootKey:						String = "node"

	// Culture formatters used to define how data is stored and how data is output
	public var storageDateFormatter:	DateFormatter?
	
	
	// MARK: - Initializers
	
	public init() {
	}
	
	public init(connectionString: String,
				storageDateFormatter: DateFormatter) {
		
		self.connectionString		= connectionString
		self.storageDateFormatter 	= storageDateFormatter
		
	}

	public init(connectionString: String,
				storageDateFormatter: DateFormatter,
				tableName: String) {
		
		self.connectionString		= connectionString
		self.storageDateFormatter 	= storageDateFormatter
		self.tableName				= tableName
		
	}
	
	
	// MARK: - Public Methods
	
	public func getRelationalDataWrapper(fromData data: [String:Any]) -> DataJSONWrapper? {
		
		var relationalDataString: 	String? = nil
		
		// Get the parameters
		let parameters:				[Any]? = data["Params"] as? [Any]
		
		// Go through each parameter
		for (_, parameter) in parameters!.enumerated() {

			let parameter:			[String:Any] = parameter as! [String:Any]

			// Get key
			let key:				String = parameter.keys.first!

			// Get value
			let value:				String = parameter[key] as! String

			// Check relationalDataColumnName
			if (key == self.relationalDataColumnName) {

				relationalDataString = value

			}

		}
		
		guard (relationalDataString != nil) else { return nil }
		
		// Get relationalDataWrapper
		let relationalDataWrapper:	DataJSONWrapper? = JSONHelper.DeserializeDataJSONWrapper(dataString: relationalDataString!)
		
		return relationalDataWrapper
		
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	/// Sets the primary key in the item using the primary key output parameter
	///
	/// - Parameters:
	///   - item: The item
	///   - parameters: The parameters
	open func setPrimaryKeyOutput(item: ProtocolModelItem, data: [String:Any]) {
		
		var item = item
		
		let primaryKey: String? = data[self.primaryKeyColumnName.uppercased()] as? String
		
		// Get the primary key parameter and set the ID of the data item
		//let parameter: ModelAccessParameter = parameters.get(parameterName: self.primaryKeyColumnName) as! ModelAccessParameter
		
		//item.id = parameter.value as! String
		
		if (primaryKey != nil) {
			
			item.id = primaryKey!
			
		}
		
	}
	
	/// Gets a parameters collection
	///
	/// - Returns: The parameters collection
	open func getParametersCollection() -> ProtocolParametersCollection? {
		
		return ModelAccessParametersCollection()
	}
	
	/// Removes the omitted parameters
	///
	/// - Parameter parameters: The parameters collection
	open func removeOmittedParameters(parameters: ProtocolParametersCollection) {
		
		// Override
		
		// eg. parameters.remove(parameterName: "[NotRequired]")
	}
	
	/// Builds an empty collection of parameters
	///
	/// - Returns: The parameters
	open func buildParameters() -> ProtocolParametersCollection? {
		
		let parameters: ProtocolParametersCollection = self.getParametersCollection()!
		
		return parameters
	}
	
	/// Builds a collection of parameters
	///
	/// - Parameters:
	///   - item: The item
	///   - outputParametersYN: The outputParametersYN
	/// - Returns: The parameters
	open func buildParameters(item: ProtocolModelItem, outputParametersYN: Bool) -> ProtocolParametersCollection? {
		
		let parameters: 		ProtocolParametersCollection = self.getParametersCollection()!
		
		// Iterate through the property keys to determine the set of parameters
		for key in item.getPropertyKeys() {
			
			// Check whether the parameter has been specified to be omitted
			if (!self.isParameterOmitted(key: key)) {
				
				print(key)
				
				// Get the property value
				let value: 		String = item.getProperty(key: key, toDateFormatter: self.storageDateFormatter!)!
				
				// Create the parameter
				let parameter: 	ModelAccessParameter = parameters.add(parameterName: key, parameterValue: value) as! ModelAccessParameter
				
				// If it is the primary key ID property then make it an output parameter of type Int
				if (key.uppercased() == self.primaryKeyColumnName.uppercased()) {
					
					if (outputParametersYN) { parameter.direction = .outward }
					//parameter.SqlDbType = SqlDbType.Int
					
				}
				
			}
			
		}
		
		// Remove parameters that are not columns in the data table
		self.removeOmittedParameters(parameters: parameters)
		
		return parameters
	}
	
	open func createNode(with parameters: ProtocolParametersCollection?, collection: ProtocolModelItemCollection) -> [String:Any] {
		
		// Create the node
		var node:			[String:Any] = [String:Any]()
		
		// Get a model item to use for iterating property keys
		let modelItem: 		ProtocolModelItem = collection.getNewItem()!
		
		// Iterate through the property keys
		for key in modelItem.getPropertyKeys() {
			
			// Get the parameter
			let parameter: 	ModelAccessParameter = (parameters!.get(parameterName: key) as! ModelAccessParameter)
			
			// Put the property in the node
			node[key] 		= parameter.value
			
		}
		
		return node
	}
	
	open func createDataWrapper(with parameters: ProtocolParametersCollection?, collection: ProtocolModelItemCollection) -> DataJSONWrapper {
		
		// Create the dataWrapper
		let dataWrapper:	DataJSONWrapper = DataJSONWrapper()
		
		// Get a model item to use for iterating property keys
		let modelItem: 		ProtocolModelItem = collection.getNewItem()!
		
		// Iterate through the property keys
		for key in modelItem.getPropertyKeys() {
			
			// Check if parameter is omitted
			if (self.isParameterOmitted(key: key)) { continue }
				
			// Get the parameter
			let parameter: 	ModelAccessParameter = (parameters!.get(parameterName: key) as! ModelAccessParameter)
			
			// Put the property in the dataWrapper
			dataWrapper.setParameterValue(key: key, value: "\(parameter.value ?? "")")
			
			// Check primary primary key column
			if (key == self.primaryKeyColumnName) {
				
				dataWrapper.ID = (parameter.value as? String) ?? ""
				
			}
			
		}
		
		// Get parameter for relationalData
		if let relationalDataParameter = parameters?.get(parameterName: self.relationalDataColumnName) as? ModelAccessParameter {
			
			dataWrapper.setParameterValue(key: self.relationalDataColumnName, value: relationalDataParameter.value! as! String)
			
		}
		
		return dataWrapper
	}
	
	open func getRelationalDataWrapper(fromItem item: ProtocolModelItem) -> DataJSONWrapper? {
		
		// Override
		
		return nil
		
	}
	
	open func setRelationalDataParameter(wrapper: DataJSONWrapper, parameters: ProtocolParametersCollection) {
		
		let relationalDataString: String? = JSONHelper.SerializeDataJSONWrapper(dataWrapper: wrapper)
		
		// Check relationalDataString
		guard (relationalDataString != nil && relationalDataString!.count > 0) else { return }
		
		let _: ModelAccessParameter = parameters.add(parameterName: self.relationalDataColumnName, parameterValue: relationalDataString!) as! ModelAccessParameter
		
	}
	
	open func setRelationalItems(fromWrapper relationalDataWrapper: DataJSONWrapper, for item: ProtocolModelItem, originalID: String) {
		
		// Override

	}
	
	/// Runs the query
	///
	/// - Parameters:
	///   - type: The query type
	///   - attributes: The attributes
	///   - parameters: The parameters
	/// - Returns: The query result
	open func runQuery(type: QueryTypes, attributes: [String : Any], with parameters: inout ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Run the query for the specified query type
		switch type {
		case .insert:
			self.runQuery(insert: attributes, with: &parameters, into: collection, oncomplete: completionHandler)
			break
			
		case .update:
			
			// DEBUG:
			//completionHandler([String:Any](), nil)
			//return
				
				
			self.runQuery(update: attributes, with: parameters, into: collection, oncomplete: completionHandler)
			break
			
		case .delete:
			self.runQuery(delete: attributes, with: parameters, into: collection, oncomplete: completionHandler)
			break
			
		case .select:
			self.runQuery(select: attributes, with: parameters, into: collection, oncomplete: completionHandler)
			break
			
		case .selectByID:
			self.runQuery(selectByID: attributes, with: parameters, into: collection, oncomplete: completionHandler)
			break
			
		case .selectBefore:
			self.runQuery(selectBefore: attributes, with: parameters, into: collection, oncomplete: completionHandler)
			break
			
		case .selectAfter:
			self.runQuery(selectAfter: attributes, with: parameters, into: collection, oncomplete: completionHandler)
			break
			
		case .selectBetween:
			self.runQuery(selectBetween: attributes, with: parameters, into: collection, oncomplete: completionHandler)
			break
			
		case .selectCount:
			self.runQuery(selectCount: attributes, with: parameters, into: collection, oncomplete: completionHandler)
			break
			
		}
	}
	
	open func runQuery(selectByNumericValue numericValue: Int, with parameters: ProtocolParametersCollection, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Override
	}
	
	open func runQuery(insert attributes: [String : Any], with parameters: inout ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Override
	}
	
	open func runQuery(update attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Override
	}
	
	open func runQuery(delete attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Override
	}
	
	open func runQuery(select attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Override
	}
	
	open func runQuery(selectByID attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Override
	}
	
	open func runQuery(selectBefore attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Override
	}
	
	open func runQuery(selectAfter attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Override
	}
	
	open func runQuery(selectBetween attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Override
	}
	
	open func runQuery(selectCount attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Override
	}
	
	/// Fills the collection
	///
	/// - Parameters:
	///   - collection: The collection
	///   - data: The data
	/// - Returns: The collection
	open func fillCollection(collection: ProtocolModelItemCollection, data: [Any]) -> ProtocolModelItemCollection? {
		
		return self.fillCollection(collection: collection, data: data, appendYN: false)
	}

	/// Fills the collection
	///
	/// - Parameters:
	///   - collection: The collection
	///   - data: The data
	///	  - appendYN: If true append the data
	/// - Returns: The collection
	open func fillCollection(collection: ProtocolModelItemCollection, data: [Any], appendYN: Bool) -> ProtocolModelItemCollection? {
		
		// Clear the collection
		if (!appendYN) { collection.clear() }
		
		// Go through each node in the data
		for dataNode in data {
			
			let dataNode = dataNode as! [String : Any]
			
			// Create the item
			var item: ProtocolModelItem = collection.getNewItem(dataNode: dataNode,
																fromDateFormatter: self.storageDateFormatter!)!
			item.status = ModelItemStatusTypes.unmodified
			
			// Add the item to the collection
			collection.addItem(item: item)
		}
		
		return collection
	}
	
}

// MARK: - Extension ProtocolModelAccessStrategy

extension ModelAccessStrategyBase: ProtocolModelAccessStrategy {
	
	// MARK: - Public Methods
	
	public func commit(collection: ProtocolModelItemCollection, insertRelationalItemsYN: Bool, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		var operationsCounter: 			Int = 0
		var operationsCompleteCounter: 	Int = 0
		
		// Create completion handler
		let insertCompletionHandler: ((String, Error?) -> Void) =
		{
			(id, error) -> Void in
			
			operationsCompleteCounter += 1

			if (operationsCompleteCounter >= operationsCounter) {
				
				// Call completion handler
				completionHandler(error)
				
			}
		}
		
		// Create completion handler
		let updateCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			operationsCompleteCounter += 1
			
			if (operationsCompleteCounter >= operationsCounter) {
				
				// Call completion handler
				completionHandler(error)
				
			}
		}
		
		// Create completion handler
		let deleteCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			operationsCompleteCounter += 1
			
			if (operationsCompleteCounter >= operationsCounter) {
				
				// Call completion handler
				completionHandler(error)
				
			}
		}

		// Go through each item
		for item in collection.items! {
			
			// Count how many operations to perform
			if (item.status == .new || item.status == .modified || item.status == .deleted) {
				
				operationsCounter += 1
				
			}
		}
		
		// Go through each item
		for item in collection.items! {
			
			// Check the status of the item to determine whether to perform an operation
			switch item.status {
				
			case ModelItemStatusTypes.new:
				
				// Insert the item
				self.insert(item: item, insertRelationalItemsYN: insertRelationalItemsYN, oncomplete: insertCompletionHandler)
				break
				
			case ModelItemStatusTypes.modified:
				// Update the item
				self.update(item: item, oncomplete: updateCompletionHandler)
				break
				
			case ModelItemStatusTypes.unmodified:
				break
				
			case ModelItemStatusTypes.deleted:
				// Delete the item
				self.delete(item: item, oncomplete: deleteCompletionHandler)
				break
				
			case ModelItemStatusTypes.obsolete:
				break
			}
		}
	}
	
	public func insert(item: ProtocolModelItem, insertRelationalItemsYN: Bool, oncomplete completionHandler:@escaping (String, Error?) -> Void) {
		
		var item = item
		
		// Get the query parameters
		var parameters: ProtocolParametersCollection? = self.buildParameters(item: item, outputParametersYN: true)

		// Check insertRelationalItemsYN
		if (insertRelationalItemsYN) {
			
			// Nb: This method adds a parameter to the database call using the relationalDataColumnName (ie. 'RelationalDataJSON'). The relational data is serialized into a DataJSONWrapper so that it can be sent in the parameter.
			
			// Get relationalDataWrapper
			let relationalDataWrapper: DataJSONWrapper? = self.getRelationalDataWrapper(fromItem: item)
			
			if (relationalDataWrapper != nil && parameters != nil) {

				// Set relational data parameter
				self.setRelationalDataParameter(wrapper: relationalDataWrapper!, parameters: parameters!)

			}
			
		}
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			if (data != nil && error == nil) {
				
				let originalID: 	String = item.id

				let dataNode: 		[String:Any] = data![self.rootKey] as! [String:Any]
				
				// Note: We are getting the primary key value from the data node returned in the completion handler instead of using the inout parameters collection. This is because the inout parameters collection causes access locking when the ModelAccessStrategy does not return from a thread like the Firebase strategy does.
				
				// Set the new primary key in the data item
				self.setPrimaryKeyOutput(item: item, data: dataNode)
				
				// Update the status of the item
				item.status = ModelItemStatusTypes.unmodified
				
				// Check insertRelationalItemsYN
				if (insertRelationalItemsYN) {
					
					// Get relationalDataWrapper
					let relationalDataWrapper: DataJSONWrapper? = self.getRelationalDataWrapper(fromData: dataNode)
					
					if (relationalDataWrapper != nil) {
					
						// Set relational items
						self.setRelationalItems(fromWrapper: relationalDataWrapper!, for: item, originalID: originalID)
						
					}

				}
				
			}
			
			// Call completion handler
			completionHandler(item.id, error)
		}
		
		// Setup the query attributes
		var attributes = [String : Any]()
		attributes["\(QueryAttributeKeys.tableName)"] = self.tableName
		
		// Run the query
		self.runQuery(type: QueryTypes.insert, attributes: attributes, with: &parameters, into: item.collection!, oncomplete: runQueryCompletionHandler)
		
	}
	
	public func update(item: ProtocolModelItem, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		var item = item
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			// Update the status of the item
			item.status = ModelItemStatusTypes.unmodified
			
			// Call completion handler
			completionHandler(error)
		}
		
		// Get the query parameters
		var parameters: ProtocolParametersCollection? = self.buildParameters(item: item, outputParametersYN: false)
		
		
		// TODO: Is this required here or at class level??
		// Setup the query attributes
		var attributes = [String : Any]()
		attributes["\(QueryAttributeKeys.tableName)"] = self.tableName
		
		// Run the query
		self.runQuery(type: QueryTypes.update, attributes: attributes, with: &parameters, into: item.collection!, oncomplete: runQueryCompletionHandler)
	
	}
	
	public func delete(item: ProtocolModelItem, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		var item = item
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			// Update the status of the item
			item.status = ModelItemStatusTypes.obsolete
			
			// Call completion handler
			completionHandler(error)
		}
		
		// Get the query parameters
		var parameters: ProtocolParametersCollection? = self.buildParameters(item: item, outputParametersYN: false)

		// Setup the query attributes
		var attributes = [String : Any]()
		attributes["\(QueryAttributeKeys.tableName)"] = self.tableName
		
		// Run the query
		self.runQuery(type: QueryTypes.delete, attributes: attributes, with: &parameters, into: item.collection!, oncomplete: runQueryCompletionHandler)
	
	}
	
	public func select(collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var collection = collection
			
			// Fill the collection with the loaded data
			collection = self.fillCollection(collection: collection, data: data![self.tableName] as! [Any])!
			
			// Call completion handler
			completionHandler(data, collection, error)
		}
		
		// Get the query parameters collection
		var parameters: ProtocolParametersCollection? = self.buildParameters()
		
		// Setup the query attributes
		var attributes = [String : Any]()
		attributes["\(QueryAttributeKeys.tableName)"] = self.tableName
		
		// Run the query
		self.runQuery(type: QueryTypes.select, attributes: attributes, with: &parameters, into: collection, oncomplete: runQueryCompletionHandler)
		
	}
	
	public func select(collection: ProtocolModelItemCollection, id: Int, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var collection = collection
			
			// Fill the collection with the loaded data
			collection = self.fillCollection(collection: collection, data: data![self.tableName] as! [Any])!
			
			// Call completion handler
			completionHandler(data, collection, error)
		}
		
		// Get the query parameters collection
		var parameters: ProtocolParametersCollection? = self.buildParameters()
		_ = parameters!.add(parameterName: self.primaryKeyColumnName, parameterValue: id)
		
		// Setup the query attributes
		var attributes = [String : Any]()
		attributes["\(QueryAttributeKeys.tableName)"] = self.tableName
		
		// Run the query
		self.runQuery(type: QueryTypes.selectByID, attributes: attributes, with: &parameters, into: collection, oncomplete: runQueryCompletionHandler)

	}
	
	public func selectBefore(collection: ProtocolModelItemCollection, beforeID: Int, includeBeforeIDItemYN: Bool, numberofItems: Int, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var collection = collection
			
			// Fill the collection with the loaded data
			collection = self.fillCollection(collection: collection, data: data![self.tableName] as! [Any])!
			
			// Call completion handler
			completionHandler(data, collection, error)
		}
		
		// Get the query parameters collection
		var parameters: ProtocolParametersCollection? = self.buildParameters()
		_ = parameters!.add(parameterName: "\(QueryParameterKeys.beforeID)",			parameterValue: beforeID)
		_ = parameters!.add(parameterName: "\(QueryParameterKeys.includeBeforeIDItem)", parameterValue: includeBeforeIDItemYN)
		_ = parameters!.add(parameterName: "\(QueryParameterKeys.rowCount)",			parameterValue: numberofItems)
		
		// Setup the query attributes
		var attributes = [String : Any]()
		attributes["\(QueryAttributeKeys.tableName)"] = self.tableName
		
		// Run the query
		self.runQuery(type: QueryTypes.selectBefore, attributes: attributes, with: &parameters, into: collection, oncomplete: runQueryCompletionHandler)
	
	}
	
	public func selectAfter(collection: ProtocolModelItemCollection, afterID: Int, includeAfterIDItemYN: Bool, numberofItems: Int, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var collection = collection
			
			// Fill the collection with the loaded data
			collection = self.fillCollection(collection: collection, data: data![self.tableName] as! [Any])!
			
			// Call completion handler
			completionHandler(data, collection, error)
		}
		
		// Get the query parameters collection
		var parameters: ProtocolParametersCollection? = self.buildParameters()
		_ = parameters!.add(parameterName: "\(QueryParameterKeys.afterID)",				parameterValue: afterID)
		_ = parameters!.add(parameterName: "\(QueryParameterKeys.includeAfterIDItem)",	parameterValue: includeAfterIDItemYN)
		_ = parameters!.add(parameterName: "\(QueryParameterKeys.rowCount)",			parameterValue: numberofItems)
		
		// Setup the query attributes
		var attributes = [String : Any]()
		attributes["\(QueryAttributeKeys.tableName)"] = self.tableName
		
		// Run the query
		self.runQuery(type: QueryTypes.selectAfter, attributes: attributes, with: &parameters, into: collection, oncomplete: runQueryCompletionHandler)
		
	}
	
	public func selectBetween(collection: ProtocolModelItemCollection, fromRowNumber: Int, toRowNumber: Int, sortBy: Int, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var collection = collection
			
			// Fill the collection with the loaded data
			collection = self.fillCollection(collection: collection, data: data![self.tableName] as! [Any])!
			
			// Call completion handler
			completionHandler(data, collection, error)
		}
		
		// Get the query parameters collection
		var parameters: ProtocolParametersCollection? = self.buildParameters()
		_ = parameters!.add(parameterName: "\(QueryParameterKeys.fromRowNumber)",	parameterValue: fromRowNumber)
		_ = parameters!.add(parameterName: "\(QueryParameterKeys.toRowNumber)",		parameterValue: toRowNumber)
		_ = parameters!.add(parameterName: "\(QueryParameterKeys.sortBy)",			parameterValue: sortBy)
		
		// Setup the query attributes
		var attributes = [String : Any]()
		attributes["\(QueryAttributeKeys.tableName)"] = self.tableName
		
		// Run the query
		self.runQuery(type: QueryTypes.selectBetween, attributes: attributes, with: &parameters, into: collection, oncomplete: runQueryCompletionHandler)

	}
	
	public func selectCount(collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping (Int, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			let count: Int = data!.first!.value as! Int
			
			// Call completion handler
			completionHandler(count, error)
		}
		
		var parameters: ProtocolParametersCollection? = self.buildParameters()
		
		// Setup the query attributes
		var attributes = [String : Any]()
		attributes["\(QueryAttributeKeys.tableName)"] = self.tableName
		
		// Run the query
		self.runQuery(type: QueryTypes.selectCount, attributes: attributes, with: &parameters, into: collection, oncomplete: runQueryCompletionHandler)
		
	}
	
	public func clearOmittedParameterKeys() {
		
		self.omittedParameterKeys = [String]()
	}
	
	public func setOmittedParameter(key: String) {
		
		if (self.omittedParameterKeys == nil) { self.omittedParameterKeys = [String]() }
		
		if (!self.isParameterOmitted(key: key)) { self.omittedParameterKeys!.append(key) }
	}
	
	public func isParameterOmitted(key: String) -> Bool {
		
		if ( self.omittedParameterKeys == nil) { return false }
		
		var result = false
		
		if (self.omittedParameterKeys!.contains(key)) { result = true }
		
		return result
	}

}
