//
//  FacebookCredentialProvider.swift
//  Smart.Foundation
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSecurity
import FirebaseAuth
import FacebookLogin
import FacebookCore

/// Specifies Facebook credential attribute keys
public enum FacebookCredentialAttributeKeys : String {
	case accessToken
}

/// A strategy for providing a credential using Facebook
public class FacebookCredentialProvider {

	// MARK: - Private Stored Properties
	
	fileprivate var signInCompletionHandler: ((_ attributes: [String : Any]?, Error?) -> Void)?
	
	
	// MARK: - Initializers
	
	public init() {
	}
	
	
	// MARK: - Public Methods
	
	public func getSignInButton(signInCompletion completionHandler:@escaping (_ attributes: [String : Any]?, Error?) -> Void) -> UIView {
		
		// Keep the completion handler
		self.signInCompletionHandler	= completionHandler
		
		// Create the button
		let button						= LoginButton(readPermissions: [ .publicProfile ])
		
		// Set delegate
		button.delegate = self

		return button
	}
	
}

// MARK: - Extension ProtocolCredentialProvider

extension FacebookCredentialProvider: ProtocolCredentialProvider {
	
	// MARK: - Public Methods
	
	public func getCredential(attributes: [String : Any]?, oncomplete completionHandler:@escaping (_ credential: Any?, Error?) -> Void) {
		
		// Get accessToken
		let accessToken	= attributes?[FacebookCredentialAttributeKeys.accessToken.rawValue] as? AccessToken
		
		if (accessToken != nil) {
			
			// Get the credential
			let credential = FacebookAuthProvider.credential(withAccessToken: accessToken!.authenticationToken)
			
			// Call completion handler
			completionHandler(credential, nil)
		}
	}
	
}

// MARK: - Extension LoginButtonDelegate

extension FacebookCredentialProvider: LoginButtonDelegate {

	// MARK: - Public Methods
	
	public func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
		
		// Create attributes
		var attributes = [String : Any]()
		
		switch result {
			
		case .failed(let error):

			// Call completion handler
			self.signInCompletionHandler?(attributes, error)
			
			break
			
		case .cancelled:
			// TODO:
			break
			
		case .success( _, _, let accessToken):
			
			attributes[FacebookCredentialAttributeKeys.accessToken.rawValue] = accessToken
			
			// Call completion handler
			self.signInCompletionHandler?(attributes, nil)
			
			break
		}
		
	}
	
	public func loginButtonDidLogOut(_ loginButton: LoginButton) {
		
		// Not implemented
	}
}
