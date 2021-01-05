//
//  DMFirebaseModelAccessStrategy.swift
//  Smart.Foundation
//
//  Created by David on 20/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel
import FirebaseDatabase

/// Specifies query parameter keys
fileprivate enum QueryParameterKeys : Int {
	case numericValue
}

/// A strategy for accessing the DM model data using Firebase
public class DMFirebaseModelAccessStrategy: FirebaseModelAccessStrategyBase {
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(connectionString: String) {
		super.init(connectionString: connectionString, tableName: "DMs")
		
		self.databaseReference = Database.database().reference(withPath: "pktable")
	}
	
}

// MARK: - Extension ProtocolDMModelAccessStrategy

extension DMFirebaseModelAccessStrategy: ProtocolDMModelAccessStrategy {
	
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
