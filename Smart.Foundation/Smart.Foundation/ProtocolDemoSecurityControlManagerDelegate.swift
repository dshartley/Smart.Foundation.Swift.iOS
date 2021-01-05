//
//  ProtocolDemoSecurityControlManagerDelegate.swift
//  Smart.Foundation
//
//  Created by David on 08/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSecurity

/// Defines a delegate for a DemoSecurityControlManager class
public protocol ProtocolDemoSecurityControlManagerDelegate {

	// MARK: - Methods
	
	func demoSecurityControlManager(signInSuccessful userProperties: UserProperties)
	
	func demoSecurityControlManager(signUpSuccessful userProperties: UserProperties)
	
}
