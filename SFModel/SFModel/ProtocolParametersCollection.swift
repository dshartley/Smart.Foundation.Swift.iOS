//
//  ProtocolParametersCollection.swift
//  SFModel
//
//  Created by David on 19/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Specifies parameter directions
public enum ParameterDirections : Int {
	case inward = 1
	case outward = 2
}

/// Defines a class which provides a collection of parameters
public protocol ProtocolParametersCollection {

	// MARK: - Methods
	
	/// Gets an array of parameters
	///
	/// - Returns: The array of parameters
	func toArray() -> [Any]
	
	/// Adds a parameter to the collection
	///
	/// - Parameters:
	///   - parameterName: The parameter name
	///   - parameterValue: The parameter value
	/// - Returns: The parameter
	func add(parameterName: String, parameterValue: Any) -> Any
	
	/// Adds a parameter to the collection
	///
	/// - Parameters:
	///   - parameterName: The parameter name
	///   - parameterValue: The parameter value
	///   - direction: The parameter direction
	/// - Returns: The parameter
	func add(parameterName: String, parameterValue: Any, direction: ParameterDirections) -> Any
	
	/// Gets the specified parameter
	///
	/// - Parameter parameterName: The parameter name
	/// - Returns: The parameter
	func get(parameterName: String) -> Any?
	
	/// Removes the specified parameter
	///
	/// - Parameter parameterName: The parameter name
	func remove(parameterName: String)
}
