//
//  AuthenticationStrategyBase.swift
//  SFSecurity
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A base class for authentication strategy classes
open class AuthenticationStrategyBase {

	// MARK: - Public Stored Properties
	
	public weak var delegate:			ProtocolAuthenticationStrategyDelegate?
	public var credentialProviderKey:	CredentialProviderKeys = .app
	
	
	// MARK: - Initializers
	
	public init() {
	}
	
	
	// MARK: - Open [Overridable] Methods
	
	open func getCurrentUserId() -> String? {
		
		// Override
		
		return nil
	}
	
	open func getCurrentUserProperties() -> UserProperties? {
		
		// Override
		
		return nil
	}
	
	open func isSignedInYN() -> Bool {
		
		// Override
		
		return false
	}
	
	open func signUp(withEmail email: String, password: String, oncomplete completionHandler:@escaping (UserProperties?, Error?, AuthenticationErrorCodes?) -> Void) {
		
		// Override
	}
	
	open func signIn(withEmail email: String, password: String, oncomplete completionHandler:@escaping (UserProperties?, Error?, AuthenticationErrorCodes?) -> Void) {
		
		// Override
	}
	
	open func signIn(withCredential credential: Any, credentialProviderKey: CredentialProviderKeys, oncomplete completionHandler:@escaping (UserProperties?, Error?, AuthenticationErrorCodes?) -> Void) {
		
		// Override
	}
	
	open func signOut(oncomplete completionHandler:@escaping (Error?, AuthenticationErrorCodes?) -> Void) {
		
		// Override
	}

	open func recoverPassword(withEmail email: String, oncomplete completionHandler:@escaping (Error?, AuthenticationErrorCodes?) -> Void) {
		
		// Override
	}
	
	open func updatePassword(withEmail email: String, fromPassword: String, toPassword: String, oncomplete completionHandler:@escaping (Error?, AuthenticationErrorCodes?) -> Void) {
		
		// Override
	}
	
}

// MARK: - Extension ProtocolAuthenticationStrategy

extension AuthenticationStrategyBase: ProtocolAuthenticationStrategy {

	// MARK: - Public Methods

}
