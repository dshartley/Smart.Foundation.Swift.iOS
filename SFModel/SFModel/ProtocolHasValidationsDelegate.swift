//
//  ProtocolHasValidationsDelegate.swift
//  SFModel
//
//  Created by David on 13/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a ProtocolHasValidations class
public protocol ProtocolHasValidationsDelegate: class {

	func hasValidations(item: ProtocolHasValidations, validationPassedFor propertyEnum: Int, message: String, resultType: ValidationResultTypes)
	
	func hasValidations(item: ProtocolHasValidations, validationFailedFor propertyEnum: Int, message: String, resultType: ValidationResultTypes)
}
