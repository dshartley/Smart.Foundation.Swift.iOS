//
//  ProtocolDMModelAccessStrategy.swift
//  Smart.Foundation
//
//  Created by David on 20/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the DM model data
public protocol ProtocolDMModelAccessStrategy {
	
	/// Select items by numeric value
	///
	/// - Parameters:
	///   - collection: The collection
	///   - numericValue: The numericValue
	///	  - completionHandler: The completionHandler
	func selectByNumericValue(collection: ProtocolModelItemCollection, numericValue: Int, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void)

}
