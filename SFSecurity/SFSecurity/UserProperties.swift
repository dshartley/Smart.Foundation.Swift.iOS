//
//  User.swift
//  SFSecurity
//
//  Created by David on 09/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Encapsulates user properties
public class UserProperties {

	// MARK: - Public Stored Properties
	
	public var id:						String?
	public var email:					String?
	public var displayName:				String?
	public var photoURL:				URL?
	public var photoData:				Data?
	public var credentialProviderKey:	CredentialProviderKeys = .app
	
	
	// MARK: - Initializers
	
	public init() {
	}
	
	public init(id: String, email: String) {
		
		self.id		= id
		self.email	= email
	}
	
}
