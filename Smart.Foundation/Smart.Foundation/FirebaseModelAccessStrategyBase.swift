//
//  FirebaseModelAccessStrategyBase.swift
//  Smart.Foundation
//
//  Created by David on 30/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel
import FirebaseDatabase

/// A base class for strategies for accessing model data using Firebase
public class FirebaseModelAccessStrategyBase: ModelAccessStrategyBase {
	
	// MARK: - Public Stored Properties
	
	public var databaseReference: DatabaseReference? = nil
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public override init(connectionString: String) {
		super.init(connectionString: connectionString)
	}
	
	public override init(connectionString: String, tableName: String) {
		super.init(connectionString: connectionString, tableName: tableName)
	}

	
	// MARK: - Override Methods
	
	public override func runQuery(insert attributes: [String : Any], with parameters: inout ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get database reference to new child
		let childReference = self.databaseReference!.childByAutoId()
		
		// Get the key of the child
		let key = childReference.key
		
		// Store the new key in the primary key column parameter
		let parameter: ModelAccessParameter = parameters!.get(parameterName: self.primaryKeyColumnName) as! ModelAccessParameter
		parameter.value = key
		
		// Create the node
		var node = [String:Any]()
		
		// Get a model item to use for iterating property keys
		let modelItem: ProtocolModelItem = collection.getNewItem()!
		
		// Iterate through the property keys
		for key in modelItem.getPropertyKeys() {
			
			// Get the parameter
			let parameter: ModelAccessParameter	= (parameters!.get(parameterName: key) as! ModelAccessParameter)
			
			// Put the property in the node
			node[key] = parameter.value
		}
		
		// Save node to child
		childReference.setValue(node) { (error, reference) -> Void in
			
			reference.removeAllObservers()
			
			// Call completion handler
			completionHandler([node], nil)
		}
	}
	
	public override func runQuery(update attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get a model item to use for iterating property keys
		let modelItem:		ProtocolModelItem	= collection.getNewItem()!
		
		var node								= [String:Any]()
		var modelItemKey:	String				= ""
		
		// Iterate through the property keys
		for key in modelItem.getPropertyKeys() {
			
			// Get the parameter
			let parameter: ModelAccessParameter	= (parameters!.get(parameterName: key) as! ModelAccessParameter)
			
			// Store the model item key
			if (key == self.primaryKeyColumnName) {
				
				modelItemKey = parameter.value as! String
			}
			
			// Put the property in the node
			node[key] = parameter.value
		}
		
		// Get database reference to child
		let childReference = self.databaseReference!.child(modelItemKey)
		
		// Save node to child
		childReference.updateChildValues(node) { (error, reference) -> Void in
			
			reference.removeAllObservers()
			
			// Call completion handler
			completionHandler([node], nil)
		}
		
	}
	
	public override func runQuery(delete attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get the model item key from the primary key column parameter
		let parameter:		ModelAccessParameter	= parameters!.get(parameterName: self.primaryKeyColumnName) as! ModelAccessParameter
		let modelItemKey:	String					= parameter.value as! String
		
		// Get database reference to child
		let childReference = self.databaseReference!.child(modelItemKey)
		
		// Remove the child
		childReference.removeValue{(error, reference) -> Void in
			
			reference.removeAllObservers()
			
			// Call completion handler
			completionHandler(nil, nil)
		}
	}
	
	public override func runQuery(select attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		// Get a model item to use for iterating property keys
		let modelItem: ProtocolModelItem = collection.getNewItem()!
		
		var data = [Any]()
		
		// Call Firebase query
		databaseReference!.queryOrdered(byChild: "id").observeSingleEvent(of: .value, with: { snapshot in
			
			self.databaseReference!.removeAllObservers()
			
			// Go through each node
			for node in snapshot.children {
				
				let node				= node as! DataSnapshot
				
				// Get the node properties
				let properties			= node.value as! [String: AnyObject]
				
				// Create the item
				var item				= [String: Any]()
				
				// Iterate through the property keys
				for key in modelItem.getPropertyKeys() {
					
					// Put the property in the item
					item[key] = properties[key]
				}
				
				// Add the item to the array
				data.append(item)
			}
			
			// Call completion handler
			completionHandler(data, nil)
		})
	}
	
	public override func runQuery(selectCount attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {

		// Call Firebase query
		databaseReference!.observeSingleEvent(of: .value, with: { snapshot in
		
			self.databaseReference!.removeAllObservers()
			
			let count: Int = Int(snapshot.childrenCount)
			
			// Call completion handler
			completionHandler([count], nil)
		})
		
	}
}
