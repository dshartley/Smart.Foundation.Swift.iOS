//
//  HasValidationsBase.swift
//  SFModel
//
//  Created by David on 26/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFCore

/// A base class for classes that have validations
open class HasValidationsBase {

	// MARK: - Private Stored Properties

	
	// MARK: - Public Stored Properties
	
	public weak var hasValidationsDelegate:	ProtocolHasValidationsDelegate?
	public var validationMessage:			String?
	
	
	// MARK: - Initializers
	
	public init() {
	}

	
	// MARK: - Open [Overridable] Methods
	
	open func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		// Override
		
		return ValidationResultTypes.passed
	}
	
	
	// MARK: - Public Methods
	
	public func checkNumeric(value: String, propertyName: String) -> ValidationResultTypes {

		var result:	ValidationResultTypes = .passed
		
		// Check is numeric
		guard (StringHelper.isNumeric(value)) else {
			
			result = .failed
			
			// Get localized message
			let localizedMessage = NSLocalizedString("mustBeNumeric", comment: "")
			
			self.validationMessage = String(format: localizedMessage, propertyName)
			
			return result
		}
		
		return result
	}

	public func checkGreaterThanZero(value: String, propertyName: String) -> ValidationResultTypes {

		var result:	ValidationResultTypes = .passed
		
		// Check is decimal
		guard let d = Decimal.init(string: value) else {
			
			result = .failed
			
			// Get localized message
			let localizedMessage = NSLocalizedString("incorrectValueType", comment: "")
			
			self.validationMessage = String(format: localizedMessage, propertyName)
			
			return result
		}
		
		// Check > 0
		guard (d > 0) else {
			
			result = .failed
			
			// Get localized message
			let localizedMessage = NSLocalizedString("mustBeGreaterThanZero", comment: "")
			
			self.validationMessage = String(format: localizedMessage, propertyName)
			
			return result
		}
		
		return result
	}

	public func checkGreaterThanOrEqualToZero(value: String, propertyName: String) -> ValidationResultTypes {

		var result:	ValidationResultTypes = .passed
		
		// Check is decimal
		guard let d = Decimal.init(string: value) else {
			
			result = .failed
			
			// Get localized message
			let localizedMessage = NSLocalizedString("incorrectValueType", comment: "")
			
			self.validationMessage = String(format: localizedMessage, propertyName)
			
			return result
		}
		
		// Check >= 0
		guard (d >= 0) else {
			
			result = .failed
			
			// Get localized message
			let localizedMessage = NSLocalizedString("mustBeZeroOrGreater", comment: "")
			
			self.validationMessage = String(format: localizedMessage, propertyName)
			
			return result
		}
		
		return result
	}
	
	public func checkIsLength(value: String, length: Int, propertyName: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = .passed
		
		// Check is length
		guard (value.count == length) else {
			
			result = .failed
			
			// Get localized message
			let localizedMessage = NSLocalizedString("mustBeLength", comment: "")
			
			self.validationMessage = String(format: localizedMessage, propertyName, String(length))
			
			return result
		}
		
		return result
	}
	
	public func checkMaxLength(value: String, maxLength: Int, propertyName: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = .passed
		
		// Check max length
		guard (value.count <= maxLength) else {
			
			result = .failed
			
			// Get localized message
			let localizedMessage = NSLocalizedString("mustBeUpToMaxLength", comment: "")
			
			self.validationMessage = String(format: localizedMessage, propertyName, String(maxLength))
			
			return result
		}
		
		return result
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func reset() {
		self.validationMessage = ""
	}
}

// MARK: - Extension ProtocolHasValidations

extension HasValidationsBase: ProtocolHasValidations {
	
	// MARK: - Public Methods
	
	public func afterValidationPassed(propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		self.onValidationPassed(propertyEnum: propertyEnum, message: message, resultType: resultType)
		
		self.reset()
	}
	
	public func afterValidationFailed(propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		self.onValidationFailed(propertyEnum: propertyEnum, message: message, resultType: resultType)
		
		self.reset()
	}
	
	
	// MARK: - Delegate Notifications
	
	public func onValidationPassed(propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		// Notify the delegate
		hasValidationsDelegate?.hasValidations(item: self, validationPassedFor: propertyEnum, message: message, resultType: resultType)

	}
	
	public func onValidationFailed(propertyEnum: Int, message: String, resultType: ValidationResultTypes) {
		
		// Notify the delegate
		hasValidationsDelegate?.hasValidations(item: self, validationFailedFor: propertyEnum, message: message, resultType: resultType)

	}
	
}
