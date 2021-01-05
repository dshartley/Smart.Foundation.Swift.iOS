//
//  ProtocolDemoSecurityHomeControlManagerDelegate.swift
//  Smart.Foundation
//
//  Created by David on 08/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSecurity

/// Defines a delegate for a ProtocolDemoSecurityHomeControlManager class
public protocol ProtocolDemoSecurityHomeControlManagerDelegate {

	// MARK: - Methods
	
	func demoSecurityHomeControlManager(signOutSuccessful userProperties: UserProperties)
}
