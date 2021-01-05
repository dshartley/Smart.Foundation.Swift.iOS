//
//  DemoSecurityControlManager.swift
//  Smart.Foundation
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSecurity
import SFController

/// Manages the DemoSecurity control layer
public class DemoSecurityControlManager: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	fileprivate var delegates	= [ProtocolDemoSecurityControlManagerDelegate]()
	public var viewManager:		DemoSecurityViewManager?
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager, viewManager: DemoSecurityViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager = viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func add(delegate: ProtocolDemoSecurityControlManagerDelegate) {
		
		self.delegates.append(delegate)
	}
	
	public func signInWithTwitter(attributes: [String : Any]?) {
		
		// Sign in
		self.authenticationManager!.signIn(withTwitter: attributes)
	}
	
	public func signInWithFacebook(attributes: [String : Any]?) {
		
		// Sign in
		self.authenticationManager!.signIn(withFacebook: attributes)
	}
	
	public func signInWithEmail() {
		
		let email		= self.viewManager!.getEmailValue()
		let password	= self.viewManager!.getPasswordValue()
		
		// Sign in
		self.authenticationManager!.signIn(withEmail: email, password: password)
	}
	
	public func signUp() {
		
		let email		= self.viewManager!.getEmailValue()
		let password	= self.viewManager!.getPasswordValue()
		
		// Sign up
		self.authenticationManager!.signUp(email: email, password: password)
	}
	
	public func checkIsSignedIn() {
	
		// Set buttons
		self.setButtons()
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setButtons() {
		
		// Get is signed in
		let isSignedInYN: Bool = self.authenticationManager!.isSignedInYN()
		
		self.viewManager!.setButtons(isSignedInYN: isSignedInYN)
	}
	
	fileprivate func displayError(_ error: Error?) {
	
		let message: String = "An error occurred: \(error.debugDescription)"
		
		self.viewManager!.displayUserInfo(message: message)
	}
	
	
	// MARK: - Override Methods
	
	public override func onSignInSuccessful(userProperties: UserProperties) {
		
		// Notify the delegates
		for delegate in delegates {
			
			delegate.demoSecurityControlManager(signInSuccessful: userProperties)
		}
	}

	public override func onSignInFailed(userProperties: UserProperties?, error: Error?) {
		
		// Set buttons
		self.setButtons()
		
		// Display error
		self.displayError(error)
	}
	
	public override func onSignUpSuccessful(userProperties: UserProperties) {
		
		// Notify the delegates
		for delegate in delegates {
			
			delegate.demoSecurityControlManager(signUpSuccessful: userProperties)
		}
	}
	
	public override func onSignUpFailed(userProperties: UserProperties?, error: Error?) {
		
		// Set buttons
		self.setButtons()
		
		// Display error
		self.displayError(error)
	}
	
}


