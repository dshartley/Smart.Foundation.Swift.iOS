//
//  ProtocolHasValidations.swift
//  SFModel
//
//  Created by David on 26/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Specifies validation result types
public enum ValidationResultTypes {
	case passed
	case warning
	case failed
}

// Defines a class that has validations
public protocol ProtocolHasValidations {

	// MARK: - Methods
	
	/// Determines whether the specified property enum value is valid
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - value: The value
	/// - Returns: The resultType
	func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes
	
	/// Performed after the validation has passed
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - message: The message
	///   - resultType: The resultType
	func afterValidationPassed(propertyEnum: Int, message: String, resultType: ValidationResultTypes)
	
	/// Performed after the validation has failed
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - message: The message
	///   - resultType: The resultType
	func afterValidationFailed(propertyEnum: Int, message: String, resultType: ValidationResultTypes)
	
	
	// MARK: - Delegate Notifications
	
	/// Occurs when a validation has passed
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - message: The message
	///   - resultType: The resultType
	func onValidationPassed(propertyEnum: Int, message: String, resultType: ValidationResultTypes)
	
	/// Occurs when a validation has passed
	///
	/// - Parameters:
	///   - propertyEnum: The propertyEnum
	///   - message: The message
	///   - resultType: The resultType
	func onValidationFailed(propertyEnum: Int, message: String, resultType: ValidationResultTypes)
}

