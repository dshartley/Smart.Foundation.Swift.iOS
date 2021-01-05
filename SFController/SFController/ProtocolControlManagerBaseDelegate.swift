//
//  ProtocolControlManagerBaseDelegate.swift
//  SFController
//
//  Created by David on 19/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSecurity

/// Defines a delegate for a ControlManagerBase class
public protocol ProtocolControlManagerBaseDelegate: class {

	// MARK: - Methods
	
	func controlManagerBase(loadUserPropertiesPhoto userProperties: UserProperties, oncomplete completionHandler:@escaping (Data?, UserProperties?, Error?) -> Void)
	
}
