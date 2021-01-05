//
//  DemoSecurityHomeControlManager.swift
//  Smart.Foundation
//
//  Created by David on 07/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFSecurity
import SFController

/// Manages the DemoSecurityHome control layer
public class DemoSecurityHomeControlManager: ControlManagerBase  {

	// MARK: - Public Stored Properties
	
	fileprivate var delegates	= [ProtocolDemoSecurityHomeControlManagerDelegate]()
	public var viewManager:		DemoSecurityHomeViewManager?

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager, viewManager: DemoSecurityHomeViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager = viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func add(delegate: ProtocolDemoSecurityHomeControlManagerDelegate) {
		
		self.delegates.append(delegate)
	}
	
	public func checkIsSignedIn() {
		
		// Load current user properties
		self.authenticationManager!.loadCurrentUserProperties()
		
		// Set buttons
		self.setButtons()
		
		// Display user info
		self.displayUserInfo()
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setButtons() {
		
		// Get is signed in
		let isSignedInYN: Bool = self.authenticationManager!.isSignedInYN()
		
		self.viewManager!.setButtons(isSignedInYN: isSignedInYN)
	}
	
	fileprivate func displayUserInfo() {
		
		var message = ""
		
		if (self.authenticationManager!.currentUserProperties != nil) {
			
			let userProperties = self.authenticationManager!.currentUserProperties!
			
			if (userProperties.displayName != nil) {
				message += "[displayname: \(userProperties.displayName!)]"
			}
			
			if (userProperties.email != nil) {
				message += "[email: \(userProperties.email!)]"
			}
			
			if (userProperties.id != nil) {
				message += "[id: \(userProperties.id!)]"
			}
		}
		
		self.viewManager!.displayUserInfo(message: message)
	}
	
	fileprivate func displayError(_ error: Error?) {
		
		let message: String = "An error occurred: \(error.debugDescription)"
		
		self.viewManager!.displayUserInfo(message: message)
	}
	
	
	// MARK: - Override Methods
	
	public override func onSignOutSuccessful(userProperties: UserProperties) {
		
		// Notify the delegates
		for delegate in delegates {
			
			delegate.demoSecurityHomeControlManager(signOutSuccessful: userProperties)
		}
	}
	
	public override func onSignOutFailed(userProperties: UserProperties?, error: Error?) {
		
		// Set buttons
		self.setButtons()
		
		// Display error
		self.displayError(error)
	}
	
}

