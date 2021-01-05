//
//  FirebaseAuthenticationStrategy.swift
//  Smart.Foundation
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSecurity
import FirebaseAuth

/// A strategy for managing user authentication using Firebase
public class FirebaseAuthenticationStrategy: AuthenticationStrategyBase {
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	
	// MARK: - Override Methods
	
	public override func getCurrentUserId() -> String? {
		
		var result: String? = nil
		
		if Auth.auth().currentUser != nil {
			result = Auth.auth().currentUser!.uid
		}
		
		return result
	}
	
	public override func isSignedInYN() -> Bool {
		
		var result = false
		
		if Auth.auth().currentUser != nil {
			result = true
		}
		
		return result
	}
	
	public override func getCurrentUserProperties() -> UserProperties? {
		
		var userProperties: UserProperties? = nil

		// Get the current user
		if let user = Auth.auth().currentUser {
			
			userProperties = self.getUserProperties(from: user)
		}
	
		return userProperties
	}
	
	public override func signUp(withEmail email: String, password: String, oncomplete completionHandler:@escaping (UserProperties?, Error?) -> Void) {
		
		// Sign up
		Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in

			// Create user properties
			var userProperties: UserProperties? = nil
			
			if (error == nil && user != nil) {
				
				// Get user properties
				userProperties = self.getUserProperties(from: user!)
			}
			
			// Call completion handler
			completionHandler(userProperties, error)
		})
		
	}
	
	public override func signIn(withEmail email: String, password: String, oncomplete completionHandler:@escaping (UserProperties?, Error?) -> Void) {
		
		// Sign in
		Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
			
			// Create user properties
			var userProperties: UserProperties? = nil
			
			if (error == nil && user != nil) {
				
				// Get user properties
				userProperties = self.getUserProperties(from: user!)
			}
			
			// Call completion handler
			completionHandler(userProperties, error)
		})
		
	}
	
	public override func signIn(withCredential credential: Any, oncomplete completionHandler:@escaping (UserProperties?, Error?) -> Void) {
		
		// Sign in
		Auth.auth().signIn(with: credential as! AuthCredential, completion: { (user, error) in
			
			// Create user properties
			var userProperties: UserProperties? = nil
			
			if (error == nil && user != nil) {
				
				// Get user properties
				userProperties = self.getUserProperties(from: user!)
			}
			
			// Call completion handler
			completionHandler(userProperties, error)
		})
	}
	
	public override func signOut(oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		do {
			try Auth.auth().signOut()
			
			// Call completion handler
			completionHandler(nil)
			
		} catch let error as NSError {
			
			// Call completion handler
			completionHandler(error)
		}
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func getUserProperties(from user: User!) -> UserProperties {
		
		let userProperties = UserProperties()
		
		userProperties.id			= user.uid
		userProperties.email		= user.email
		userProperties.displayName	= user.displayName
		userProperties.photoURL		= user.photoURL
		
		return userProperties
	}
}


