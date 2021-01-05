//
//  ProtocolCredentialProvider.swift
//  SFSecurity
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a credential provider
public protocol ProtocolCredentialProvider {
	
	// MARK: - Methods
	
	func getCredential(attributes: [String : Any]?, oncomplete completionHandler:@escaping (_ credential: Any?, _ error: Error?) -> Void)
	
}
