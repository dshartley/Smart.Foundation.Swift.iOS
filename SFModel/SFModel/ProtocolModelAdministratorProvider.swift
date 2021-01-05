//
//  ProtocolModelAdministratorProvider.swift
//  SFModel
//
//  Created by David on 17/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a class which provides access to model administrators
public protocol ProtocolModelAdministratorProvider: class {
	
	// MARK: - Methods
	
	/// Get a model administrator
	///
	/// - Parameter key: The key
	/// - Returns: The model administrator
	func getModelAdministrator(key: String) -> ProtocolModelAdministrator?
}
