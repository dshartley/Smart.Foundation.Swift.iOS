//
//  ProtocolAuthenticationStrategy.swift
//  SFSecurity
//
//  Created by David on 09/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// An authentication strategy
public protocol ProtocolAuthenticationStrategy {
	
	// MARK: - Methods
	
	/// Gets the current user id
	///
	/// - Returns: The user id
	func getCurrentUserId() -> String?
	
	/// Gets if the user is signed in
	///
	/// - Returns: True if the user is signed in
	func isSignedInYN() -> Bool
	
	/// Gets the current user properties
	///
	/// - Returns: The current user properties
	func getCurrentUserProperties() -> UserProperties?
	
	/// Signs up the user
	///
	/// - Parameters:
	///   - email: The email
	///   - password: The password
	///   - completionHandler: The completionHandler
	func signUp(withEmail email: String, password: String, oncomplete completionHandler:@escaping (UserProperties?, Error?, AuthenticationErrorCodes?) -> Void)
	
	/// Signs in the user
	///
	/// - Parameters:
	///   - email: The email
	///   - password: The password
	///   - completionHandler: The completionHandler
	func signIn(withEmail email: String, password: String, oncomplete completionHandler:@escaping (UserProperties?, Error?, AuthenticationErrorCodes?) -> Void)
	
	/// Signs in the user
	///
	/// - Parameters:
	///   - credential: The credential
	///   - credentialProviderKey: The credentialProviderKey
	///   - completionHandler: The completionHandler
	func signIn(withCredential credential: Any, credentialProviderKey: CredentialProviderKeys, oncomplete completionHandler:@escaping (UserProperties?, Error?, AuthenticationErrorCodes?) -> Void)
	
	/// Signs out the user
	///
	/// - Parameters:
	/// - completionHandler: The completionHandler
	func signOut(oncomplete completionHandler:@escaping (Error?, AuthenticationErrorCodes?) -> Void)
	
	/// Recovers password
	///
	/// - Parameters:
	/// - email: The email
	/// - completionHandler: The completionHandler
	func recoverPassword(withEmail email: String, oncomplete completionHandler:@escaping (Error?, AuthenticationErrorCodes?) -> Void)
	
	/// Updates password
	///
	/// - Parameters:
	/// - email: The email
	/// - fromPassword: The fromPassword
	/// - toPassword: The toPassword
	/// - completionHandler: The completionHandler
	func updatePassword(withEmail email: String, fromPassword: String, toPassword: String, oncomplete completionHandler:@escaping (Error?, AuthenticationErrorCodes?) -> Void)
}
