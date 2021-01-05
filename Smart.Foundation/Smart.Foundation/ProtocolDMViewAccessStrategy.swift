//
//  ProtocolDMViewAccessStrategy.swift
//  Smart.Foundation
//
//  Created by David on 24/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a class which provides a strategy for accessing the DM view
public protocol ProtocolDMViewAccessStrategy {

	// MARK: - Methods
	
	/// Gets the ID
	///
	/// - Returns: The ID
	func getID() -> String
	
	/// Gets the stringValue
	///
	/// - Returns: The stringValue
	func getStringValue() -> String
	
	/// Gets the numericValue
	///
	/// - Returns: The numericValue
	func getNumericValue() -> String
}
