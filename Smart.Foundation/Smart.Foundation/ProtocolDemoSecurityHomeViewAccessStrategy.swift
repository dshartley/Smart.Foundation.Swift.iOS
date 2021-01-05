//
//  DemoSecurityHomeViewAccessStrategy.swift
//  Smart.Foundation
//
//  Created by David on 07/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a class which provides a strategy for accessing the DemoSecurityHome view
public protocol ProtocolDemoSecurityHomeViewAccessStrategy {

	// MARK: - Methods
	
	/// Sets the buttons
	///
	/// - Parameter isSignedInYN: The isSignedInYN
	func setButtons(isSignedInYN: Bool) -> Void
	
	/// Displays user info
	///
	/// - Parameter message: The message
	func displayUserInfo(message: String) -> Void
	
}
