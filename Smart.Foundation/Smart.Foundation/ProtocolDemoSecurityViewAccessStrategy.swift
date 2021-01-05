//
//  ProtocolDemoSecurityViewAccessStrategy.swift
//  Smart.Foundation
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a class which provides a strategy for accessing the DemoSecurity view
public protocol ProtocolDemoSecurityViewAccessStrategy {
	
	// MARK: - Methods
	
	/// Clears the text fields
	///
	func clearTextFields() -> Void
	
	/// Sets the buttons
	///
	/// - Parameter isSignedInYN: The isSignedInYN
	func setButtons(isSignedInYN: Bool) -> Void
	
	/// Displays user info
	///
	/// - Parameter message: The message
	func displayUserInfo(message: String) -> Void
	
	/// Gets the email
	///
	/// - Returns: The email
	func getEmailValue() -> String
	
	/// Gets the password
	///
	/// - Returns: The password
	func getPasswordValue() -> String
	
}
