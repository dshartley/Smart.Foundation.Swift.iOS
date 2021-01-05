//
//  AuthenticationManager.swift
//  SFSecurity
//
//  Created by David on 09/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFNet

/// Specifies query attribute keys
public enum CredentialProviderKeys : String {
	case app
	case twitter
	case facebook
	case google
}

/// Specifies authentication error codes
public enum AuthenticationErrorCodes : String {
	case invalidEmail
	case emailAlreadyInUse
	case weakPassword
	case wrongPassword
	case wrongConfirmPassword
	case userNotFound
	case notSignedIn
	case notConnected
	case unspecified
}

/// Manages authentication
public class AuthenticationManager {

	// MARK: - Private Stored Properties
	
	fileprivate var authenticationStrategy:				ProtocolAuthenticationStrategy?
	fileprivate var credentialProviders:				[CredentialProviderKeys : ProtocolCredentialProvider]?
	
	
	// MARK: - Private Static Properties
	
	fileprivate static var singleton:					AuthenticationManager?
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:							ProtocolAuthenticationManagerDelegate?
	public fileprivate(set) var currentUserProperties:	UserProperties? = nil
	
	
	// MARK: - Initializers
	
	fileprivate init() {
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var shared: AuthenticationManager {
		get {
			
			if (AuthenticationManager.singleton == nil) {
				AuthenticationManager.singleton = AuthenticationManager()
			}
			
			return AuthenticationManager.singleton!
		}
	}
	
	
	// MARK: - Public Methods
	
	public func set(authenticationStrategy: ProtocolAuthenticationStrategy) {
		
		self.authenticationStrategy		= authenticationStrategy
		
		(self.authenticationStrategy as? AuthenticationStrategyBase)?.delegate = self

	}

	public func add(credentialProvider: ProtocolCredentialProvider, key: CredentialProviderKeys) {
		
		if (self.credentialProviders == nil) {
			
			self.credentialProviders = [CredentialProviderKeys : ProtocolCredentialProvider]()
		}
		
		self.credentialProviders![key] = credentialProvider
	}
	
	public func loadCurrentUserProperties() {
		
		// Get the current user properties
		self.currentUserProperties = self.authenticationStrategy!.getCurrentUserProperties()
		
		guard (self.currentUserProperties != nil) else { return }
		
		// Create completion handler
		let completionHandler: ((Data?, UserProperties?, Error?) -> Void) =
		{
			(data, userProperties, error) -> Void in
			
			if (error == nil) {
				
				// Notify the delegate
				self.delegate?.authenticationManager(userPropertiesPhotoLoaded: userProperties!)
				
			}

		}
		
		// Load photo
		self.loadUserPropertiesPhoto(userProperties: self.currentUserProperties!, oncomplete: completionHandler)
		
	}
	
	public func getCurrentUserId() -> String? {
		
		var result: String? = nil
		
		// Check current user properties
		if (self.currentUserProperties == nil) {
			
			self.loadCurrentUserProperties()
		}
		
		if (self.currentUserProperties != nil) {
			
			result = self.currentUserProperties!.id
		}
		
		return result
	}
	
	public func isSignedInYN() -> Bool {
		
		let result: Bool = self.authenticationStrategy!.isSignedInYN()
		
		// Check current user properties
		if (result && self.currentUserProperties == nil) {
			
			self.loadCurrentUserProperties()
		}
		
		return result
	}
	
	public func signIn(withTwitter attributes: [String : Any]?) {

		// checkIsConnected
		if (!self.checkIsConnected()) {
			
			self.onSignInFailed(userProperties: nil, error: nil, code: .notConnected)
			return
		}
		
		// Create completion handler
		let loadUserPropertiesPhotoCompletionHandler: ((Data?, UserProperties?, Error?) -> Void) =
		{
			(data, userProperties, error) -> Void in
			
			self.onSignInSuccessful(userProperties: userProperties!)
			
		}
		
		// Create completion handler
		let signInCompletionHandler: ((UserProperties?, Error?, AuthenticationErrorCodes?) -> Void) =
		{
			(userProperties, error, code) -> Void in
			
			if (error == nil) {
				
				// Check photoURL is set
				if (userProperties!.photoURL != nil) {
					
					// Load photo
					self.loadUserPropertiesPhoto(userProperties: userProperties!, oncomplete: loadUserPropertiesPhotoCompletionHandler)
					
				} else {
					
					self.onSignInSuccessful(userProperties: userProperties!)
					
				}

			} else {
				
				self.onSignInFailed(userProperties: userProperties, error: error, code: code)
			}
		}
		
		// Create completion handler
		let getCredentialCompletionHandler: ((Any?, Error?) -> Void) =
		{
			(credential, error) -> Void in
			
			if (error == nil && credential != nil) {
			
				// Sign in
				self.authenticationStrategy!.signIn(withCredential: credential!, credentialProviderKey: .twitter, oncomplete: signInCompletionHandler)

			}
			else {
				self.onSignInFailed(userProperties: nil, error: error, code: nil)
			}
		}
		
		// Get Twitter credential provider
		let twitterCredentialProvider	= self.credentialProviders?[CredentialProviderKeys.twitter]
		
		if (twitterCredentialProvider != nil) {
			
			// Get the credential
			twitterCredentialProvider?.getCredential(attributes: attributes, oncomplete: getCredentialCompletionHandler)
		}

	}

	public func signIn(withFacebook attributes: [String : Any]?) {
		
		// checkIsConnected
		if (!self.checkIsConnected()) {
			
			self.onSignInFailed(userProperties: nil, error: nil, code: .notConnected)
			return
		}
		
		// Create completion handler
		let loadUserPropertiesPhotoCompletionHandler: ((Data?, UserProperties?, Error?) -> Void) =
		{
			(data, userProperties, error) -> Void in
			
			self.onSignInSuccessful(userProperties: userProperties!)
			
		}
		
		// Create completion handler
		let signInCompletionHandler: ((UserProperties?, Error?, AuthenticationErrorCodes?) -> Void) =
		{
			(userProperties, error, code) -> Void in
			
			if (error == nil) {
				
				// Check photoURL is set
				if (userProperties!.photoURL != nil) {
					
					// Load photo
					self.loadUserPropertiesPhoto(userProperties: userProperties!, oncomplete: loadUserPropertiesPhotoCompletionHandler)
					
				} else {
					
					self.onSignInSuccessful(userProperties: userProperties!)
					
				}

			} else {
				
				self.onSignInFailed(userProperties: userProperties, error: error, code: code)
			}
		}
		
		// Create completion handler
		let getCredentialCompletionHandler: ((Any?, Error?) -> Void) =
		{
			(credential, error) -> Void in
			
			if (error == nil && credential != nil) {
				
				// Sign in
				self.authenticationStrategy!.signIn(withCredential: credential!, credentialProviderKey: .facebook, oncomplete: signInCompletionHandler)

			}
			else {
				self.onSignInFailed(userProperties: nil, error: error, code: nil)
			}
		}
		
		// Get Facebook credential provider
		let facebookCredentialProvider		= self.credentialProviders?[CredentialProviderKeys.facebook]
		
		if (facebookCredentialProvider != nil) {
			
			// Get the credential
			facebookCredentialProvider?.getCredential(attributes: attributes, oncomplete: getCredentialCompletionHandler)
		}

	}
	
	public func signIn(withEmail email: String, password: String) {
		
		// checkIsConnected
		if (!self.checkIsConnected()) {
			
			self.onSignInFailed(userProperties: nil, error: nil, code: .notConnected)
			return
		}
		
		// Create completion handler
		let signInCompletionHandler: ((UserProperties?, Error?, AuthenticationErrorCodes?) -> Void) =
		{
			(userProperties, error, code) -> Void in
			
			if (error == nil) {
				self.onSignInSuccessful(userProperties: userProperties!)
			}
			else {
				self.onSignInFailed(userProperties: userProperties, error: error, code: code)
			}
		}
		
		// Sign in
		self.authenticationStrategy!.signIn(withEmail: email, password: password, oncomplete: signInCompletionHandler)
		
	}
	
	public func signOut() {
		
		// Check isSignedInYN
		if (!self.authenticationStrategy!.isSignedInYN()) {
			
			self.onSignOutFailed(userProperties: self.currentUserProperties, error: nil, code: .notSignedIn)
			return
			
		}
		
		// Check current user properties
		if (self.currentUserProperties == nil) {
			
			// Get the current user properties
			self.currentUserProperties = self.authenticationStrategy!.getCurrentUserProperties()
		}
		
		if (self.currentUserProperties == nil) {
			
			self.onSignOutFailed(userProperties: self.currentUserProperties, error: nil, code: .notSignedIn)
			return
			
		}
		
		// Create completion handler
		let signOutCompletionHandler: ((Error?, AuthenticationErrorCodes?) -> Void) =
		{
			(error, code) -> Void in
			
			if (error == nil) {
				self.onSignOutSuccessful(userProperties: self.currentUserProperties!)
			}
			else {
				self.onSignOutFailed(userProperties: self.currentUserProperties, error: error, code: code)
			}
		}
		
		// Sign in
		self.authenticationStrategy!.signOut(oncomplete: signOutCompletionHandler)
		
	}
	
	public func signUp(email: String, password: String) {
		
		// checkIsConnected
		if (!self.checkIsConnected()) {
			
			self.onSignUpFailed(userProperties: nil, error: nil, code: .notConnected)
			return
		}
		
		// Create completion handler
		let signUpCompletionHandler: ((UserProperties?, Error?, AuthenticationErrorCodes?) -> Void) =
		{
			(userProperties, error, code) -> Void in
			
			if (error == nil) {
				self.onSignUpSuccessful(userProperties: userProperties!)
			}
			else {
				self.onSignUpFailed(userProperties: userProperties, error: error, code: code)
			}
		}
		
		// Sign in
		self.authenticationStrategy!.signUp(withEmail: email, password: password, oncomplete: signUpCompletionHandler)
		
	}

	public func recoverPassword(withEmail email: String) {
		
		// checkIsConnected
		if (!self.checkIsConnected()) {
			
			self.onRecoverPasswordFailed(error: nil, code: .notConnected)
			return
		}
		
		// Create completion handler
		let recoverPasswordCompletionHandler: ((Error?, AuthenticationErrorCodes?) -> Void) =
		{
			(error, code) -> Void in
			
			if (error == nil) {
				self.onRecoverPasswordSuccessful()
			}
			else {
				self.onRecoverPasswordFailed(error: error, code: code)
			}
		}
		
		// Sign in
		self.authenticationStrategy!.recoverPassword(withEmail: email, oncomplete: recoverPasswordCompletionHandler)
		
	}

	public func updatePassword(withEmail email: String, fromPassword: String, toPassword: String) {
		
		// checkIsConnected
		if (!self.checkIsConnected()) {
			
			self.onUpdatePasswordFailed(error: nil, code: .notConnected)
			return
		}
		
		// Create completion handler
		let updatePasswordCompletionHandler: ((Error?, AuthenticationErrorCodes?) -> Void) =
		{
			(error, code) -> Void in
			
			if (error == nil) {
				self.onUpdatePasswordSuccessful()
			}
			else {
				self.onUpdatePasswordFailed(error: error, code: code)
			}
		}
		
		// Update password
		self.authenticationStrategy!.updatePassword(withEmail: email, fromPassword: fromPassword, toPassword: toPassword, oncomplete: updatePasswordCompletionHandler)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func onSignInSuccessful(userProperties: UserProperties) {
		
		self.currentUserProperties = userProperties
		
		// Notify the delegate
		self.delegate?.authenticationManager(signInSuccessful: userProperties)

	}

	fileprivate func onSignInFailed(userProperties: UserProperties?, error: Error?, code: AuthenticationErrorCodes?) {
		
		self.currentUserProperties = nil
		
		// Notify the delegate
		self.delegate?.authenticationManager(signInFailed: userProperties, error: error, code: code)
		
	}
	
	fileprivate func onSignOutSuccessful(userProperties: UserProperties) {
		
		self.currentUserProperties = nil
		
		// Notify the delegate
		self.delegate?.authenticationManager(signOutSuccessful: userProperties)

	}

	fileprivate func onSignOutFailed(userProperties: UserProperties?, error: Error?, code: AuthenticationErrorCodes?) {
		
		// Check whether signed in
		if (self.authenticationStrategy!.isSignedInYN()) {
			
			self.currentUserProperties = userProperties
			
		} else {
			
			self.currentUserProperties = nil
		}
		
		// Notify the delegate
		self.delegate?.authenticationManager(signOutFailed: userProperties, error: error, code: code)

	}

	fileprivate func onSignUpSuccessful(userProperties: UserProperties) {
		
		// Check whether signed in
		if (self.authenticationStrategy!.isSignedInYN()) {
			
			self.currentUserProperties = userProperties
			
		} else {
			
			self.currentUserProperties = nil
		}
		
		// Notify the delegate
		self.delegate?.authenticationManager(signUpSuccessful: userProperties)
		
	}
	
	fileprivate func onSignUpFailed(userProperties: UserProperties?, error: Error?, code: AuthenticationErrorCodes?) {
		
		// Check whether signed in
		if (self.authenticationStrategy!.isSignedInYN()) {
			
			self.currentUserProperties = userProperties
			
		} else {
			
			self.currentUserProperties = nil
		}
		
		// Notify the delegate
		self.delegate?.authenticationManager(signUpFailed: userProperties, error: error, code: code)

	}

	fileprivate func onRecoverPasswordSuccessful() {
		
		// Notify the delegate
		self.delegate?.authenticationManager(recoverPasswordSuccessful: self)
		
	}
	
	fileprivate func onRecoverPasswordFailed(error: Error?, code: AuthenticationErrorCodes?) {
		
		// Notify the delegate
		self.delegate?.authenticationManager(recoverPasswordFailed: error, code: code)
		
	}
	
	fileprivate func onUpdatePasswordSuccessful() {
		
		// Notify the delegate
		self.delegate?.authenticationManager(updatePasswordSuccessful: self)
		
	}
	
	fileprivate func onUpdatePasswordFailed(error: Error?, code: AuthenticationErrorCodes?) {
		
		// Notify the delegate
		self.delegate?.authenticationManager(updatePasswordFailed: error, code: code)
		
	}
	
	fileprivate func loadUserPropertiesPhoto(userProperties: UserProperties, oncomplete completionHandler:@escaping (Data?, UserProperties?, Error?) -> Void) {

		guard (self.delegate != nil) else {
			
			// Call completion handler
			completionHandler(nil, userProperties, NSError())
			
			return
		}
		
		guard (userProperties.photoURL != nil) else {
			
			// Call completion handler
			completionHandler(nil, userProperties, nil)
			
			return
		}
		
		self.delegate?.authenticationManager(loadUserPropertiesPhoto: userProperties, oncomplete: completionHandler)
		
	}
	
	fileprivate func checkIsConnected() -> Bool {
		
		var result = false
		
		result = ReachabilityHelper.isConnectedToNetwork()
		
		return result
	}
	
}

// MARK: - Extension ProtocolAuthenticationStrategyDelegate

extension AuthenticationManager: ProtocolAuthenticationStrategyDelegate {
	
	// MARK: - Public Methods
	
	public func authenticationStrategy(userSignedIn		userProperties: UserProperties) {
		
		// Propagate the notification
		self.onSignInSuccessful(userProperties: userProperties)
	}
	
	public func authenticationStrategy(userSignedOut	userProperties: UserProperties) {
		
		// Propagate the notification
		self.onSignOutSuccessful(userProperties: userProperties)
	}
	
}


