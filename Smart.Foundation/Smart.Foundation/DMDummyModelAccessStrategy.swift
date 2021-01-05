//
//  DMDummyModelAccessStrategy.swift
//  Smart.Foundation
//
//  Created by David on 22/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Specifies query parameter keys
fileprivate enum QueryParameterKeys : Int {
	case numericValue
}

fileprivate struct DMData {
	
	var json: [String: Any] =
		[
			"pktable" :
			[
				[
					"id" : 1,
					"stringvalue" : "val1",
					"numericvalue" : 1
				],
				[
					"id" : 2,
					"stringvalue" : "val2",
					"numericvalue" : 2
				]
			],
			"fktable" :
			[
				[
					"id" : 1,
					"stringvalue" : "val1",
					"numericvalue" : 1
				],
				[
					"id" : 2,
					"stringvalue" : "val2",
					"numericvalue" : 2
				]
			]
		]
}

/// A strategy for accessing the DM model data using dummy data from a JSON variable
public class DMDummyModelAccessStrategy : ModelAccessStrategyBase {
	
	// MARK: - Private Stored Properties
	
	fileprivate var data = DMData()
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(connectionString: String) {
		super.init(connectionString: connectionString, tableName: "DMs")
	}

	
	// MARK: - Override Methods
	
	public override func runQuery(selectByNumericValue numericValue: Int, with parameters: ProtocolParametersCollection, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get tableName
		//let tableName:		String			= attributes["tableName"] as! String
		
		// Get the table
		let jsonTable:		[Any]			= self.data.json["pktable"] as! [Any]
		
		// Get the items
		var jsonItems = [Any]()
		
		for item in jsonTable {
			let item					= item as! [String : Any]
			let itemnumericValue: Int	= item["numericvalue"] as! Int
			
			if (itemnumericValue == numericValue) { jsonItems.append(item) }
		}
		
		// Call completion handler
		completionHandler(jsonItems, nil)
	}
	
	public override func runQuery(insert attributes: [String : Any], with parameters: inout ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get tableName
		//let tableName:		String			= attributes["tableName"] as! String
		
		// Get parameters
		let pid:			ModelAccessParameter	= (parameters!.get(parameterName: "id") as! ModelAccessParameter)
		let id:				Int						= Int(pid.value as! String)!
		
		let pstringValue:	ModelAccessParameter	= (parameters!.get(parameterName: "stringvalue") as! ModelAccessParameter)
		let stringValue:	String					= pstringValue.value as! String
		
		let pnumericValue:	ModelAccessParameter	= (parameters!.get(parameterName: "numericvalue") as! ModelAccessParameter)
		let numericValue:	Int						= Int(pnumericValue.value as! String)!
	
		// Get a copy of the table
		var jsonTable:		[Any]					= self.data.json["pktable"] as! [Any]
		
		// Create the item
		let jsonItem:		[String: Any]			=
			[
				"id" :				id,
				"stringvalue" :		stringValue,
				"numericvalue" :	numericValue
			]
		
		// Insert the item into the table
		jsonTable.append(jsonItem)
		
		// Copy the table back to the data
		self.data.json["pktable"] = jsonTable
		
		// Call completion handler
		completionHandler([jsonItem], nil)
	}
	
	public override func runQuery(update attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get tableName
		//let tableName:		String			= attributes["tableName"] as! String
		
		// Get parameters
		let pid:			ModelAccessParameter	= (parameters!.get(parameterName: "id") as! ModelAccessParameter)
		let id:				Int						= Int(pid.value as! String)!
		
		let pstringValue:	ModelAccessParameter	= (parameters!.get(parameterName: "stringvalue") as! ModelAccessParameter)
		let stringValue:	String					= pstringValue.value as! String
		
		let pnumericValue:	ModelAccessParameter	= (parameters!.get(parameterName: "numericvalue") as! ModelAccessParameter)
		let numericValue:	Int						= Int(pnumericValue.value as! String)!
		
		// Get a copy of the table
		var jsonTable:		[Any]			= self.data.json["pktable"] as! [Any]
		
		// Get the item
		var jsonItem:		[String : Any]? = nil
		var foundIndex:		Int = -1
		
		jsonTableLoop: for (index, item) in jsonTable.enumerated() {
			let item			= item as! [String : Any]
			let itemid: Int		= item["id"] as! Int
			
			if (itemid == id) {
				jsonItem		= item
				foundIndex		= index
				break jsonTableLoop
				
			}
		}
		
		// Update the item
		if (jsonItem != nil) {
			
			jsonItem!["stringvalue"]	= stringValue
			jsonItem!["numericvalue"]	= numericValue
			
			// Copy the item back to the table
			jsonTable[foundIndex]		= jsonItem!
			
			// Copy the table back to the data
			self.data.json["pktable"]	= jsonTable
		}
		
		// Call completion handler
		completionHandler([jsonItem as Any], nil)
	}
	
	public override func runQuery(delete attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get tableName
		//let tableName:		String			= attributes["tableName"] as! String
		
		// Get parameters
		let pid:			ModelAccessParameter	= (parameters!.get(parameterName: "id") as! ModelAccessParameter)
		let id:				Int						= pid.value as! Int
		
		// Get a copy of the table
		var jsonTable:		[Any]					= self.data.json["pktable"] as! [Any]
		
		// Get the item index
		var foundIndex:		Int						= -1
		
		jsonTableLoop: for (index, item) in jsonTable.enumerated() {
			let item			= item as! [String : Any]
			let itemid: Int		= item["id"] as! Int
			
			if (itemid == id) {
				foundIndex		= index
				break jsonTableLoop
				
			}
		}
		
		if (foundIndex >= 0) {
			// Remove the item from the table
			jsonTable.remove(at: foundIndex)
			
			// Copy the table back to the data
			self.data.json["pktable"]	= jsonTable
		}
		
		// Call completion handler
		completionHandler([Any](), nil)
	}
	
	public override func runQuery(select attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get tableName
		//let tableName:		String			= attributes["tableName"] as! String
		
		// Get the table
		let jsonTable:		[Any]			= self.data.json["pktable"] as! [Any]
		
		// Call completion handler
		completionHandler(jsonTable, nil)
	}
	
	public override func runQuery(selectByID attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get tableName
		//let tableName:		String			= attributes["tableName"] as! String
		
		// Get parameters
		let pid:			ModelAccessParameter	= (parameters!.get(parameterName: "id") as! ModelAccessParameter)
		let id:				Int						= Int(pid.value as! String)!
		
		// Get the table
		let jsonTable:		[Any]					= self.data.json["pktable"] as! [Any]
		
		// Get the items
		var jsonItems = [Any]()
		
		for item in jsonTable {
			let item			= item as! [String : Any]
			let itemid:	Int		= item["id"] as! Int
			
			if (itemid == id) { jsonItems.append(item) }
		}
		
		// Call completion handler
		completionHandler(jsonItems, nil)
	}
	
	public override func runQuery(selectBefore attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// TODO: Run query
		
		// Call completion handler
		completionHandler(nil, nil)
	}
	
	public override func runQuery(selectAfter attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// TODO: Run query
		
		// Call completion handler
		completionHandler(nil, nil)
	}
	
	public override func runQuery(selectBetween attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// TODO: Run query
		
		// Call completion handler
		completionHandler(nil, nil)
	}
	
	public override func runQuery(selectCount attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get tableName
		//let tableName:		String			= attributes["tableName"] as! String
		
		// Get the table
		let jsonTable:		[Any]			= self.data.json["pktable"] as! [Any]
		
		// Call completion handler
		completionHandler([jsonTable.count], nil)
	}
	
}

// MARK: - Extension ProtocolDMModelAccessStrategy

extension DMDummyModelAccessStrategy: ProtocolDMModelAccessStrategy {
	
	// MARK: - Public Methods
	
	public func selectByNumericValue(collection: ProtocolModelItemCollection, numericValue: Int, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var collection = collection
			
			// Fill the collection with the loaded data
			collection = self.fillCollection(collection: collection, data: data!)!
			
			// Call the completion handler
			completionHandler(data, collection, nil)
		}
		
		// Get the parameters collection
		let parameters: ProtocolParametersCollection = self.getParametersCollection()!
		_ = parameters.add(parameterName: "\(QueryParameterKeys.numericValue)", parameterValue: numericValue)
		
		// Run the query
		self.runQuery(selectByNumericValue: numericValue, with: parameters, into: collection, oncomplete: runQueryCompletionHandler)
	}
	
}


