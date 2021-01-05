//
//  ProtocolAuthenticationManagerDelegate.swift
//  SFSecurity
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a AuthenticationManager class
public protocol ProtocolAuthenticationManagerDelegate: class {

	// MARK: - Methods
	
	func authenticationManager(signInSuccessful userProperties: UserProperties)
	
	func authenticationManager(signInFailed userProperties: UserProperties?,
							   error: 	Error?,
							   code: 	AuthenticationErrorCodes?)
	
	func authenticationManager(signOutSuccessful userProperties: UserProperties)
	
	func authenticationManager(signOutFailed userProperties: UserProperties?,
	                           error: 	Error?,
	                           code: 	AuthenticationErrorCodes?)
	
	func authenticationManager(signUpSuccessful	userProperties: UserProperties)
	
	func authenticationManager(signUpFailed userProperties: UserProperties?,
	                           error: 	Error?,
	                           code: 	AuthenticationErrorCodes?)
	
	func authenticationManager(recoverPasswordSuccessful sender: AuthenticationManager)
	
	func authenticationManager(recoverPasswordFailed error: Error?,
	                           code: 	AuthenticationErrorCodes?)

	func authenticationManager(userPropertiesPhotoLoaded userProperties: UserProperties)
	
	func authenticationManager(loadUserPropertiesPhoto userProperties: UserProperties, oncomplete completionHandler:@escaping (Data?, UserProperties?, Error?) -> Void)
	
	func authenticationManager(updatePasswordSuccessful sender: AuthenticationManager)
	
	func authenticationManager(updatePasswordFailed error: Error?,
							   code: 	AuthenticationErrorCodes?)
	
}
