//
//  ProtocolAuthenticationStrategyDelegate.swift
//  SFSecurity
//
//  Created by David on 09/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a ProtocolAuthenticationStrategy class
public protocol ProtocolAuthenticationStrategyDelegate: class {

	// MARK: - Methods
	
	func authenticationStrategy(userSignedIn	userProperties: UserProperties)
	
	func authenticationStrategy(userSignedOut	userProperties: UserProperties)
	
}
