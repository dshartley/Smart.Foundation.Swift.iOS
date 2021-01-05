//
//  TwitterCredentialProvider.swift
//  Smart.Foundation
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSecurity
import FirebaseAuth
import TwitterKit

/// Specifies Twitter credential attribute keys
public enum TwitterCredentialAttributeKeys : String {
	case session
}

/// A strategy for providing a credential using Twitter
public class TwitterCredentialProvider {
	
	// MARK: - Initializers
	
	public init() {
	}
	
	
	// MARK: - Public Methods
	
	public func getSignInButton(signInCompletion completionHandler:@escaping (_ attributes: [String : Any]?, Error?) -> Void) -> UIButton {
		
		// Create completion handler
		let signInCompletionHandler: ((TWTRSession?, Error?) -> Void) =
		{
			(session, error) -> Void in
			
			// Create attributes
			var attributes = [String : Any]()
			
			if (session != nil) {
				attributes[TwitterCredentialAttributeKeys.session.rawValue] = session!
			}
			
			// Call completion handler
			completionHandler(attributes, error)
		}
		
		let button = TWTRLogInButton(logInCompletion: signInCompletionHandler)
		
		return button
	}
}

// MARK: - Extension ProtocolCredentialProvider

extension TwitterCredentialProvider: ProtocolCredentialProvider {
	
	// MARK: - Public Methods
	
	public func getCredential(attributes: [String : Any]?, oncomplete completionHandler:@escaping (_ credential: Any?, Error?) -> Void) {
		
		// Get session
		let session	= attributes?[TwitterCredentialAttributeKeys.session.rawValue] as? TWTRSession
		
		if (session != nil) {
			
			// Get the credential
			let credential = TwitterAuthProvider.credential(withToken: session!.authToken, secret: session!.authTokenSecret)
			
			// Call completion handler
			completionHandler(credential, nil)
		}
		
	}

}
