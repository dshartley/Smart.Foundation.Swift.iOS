//
//  DemoSecurityViewAccessStrategy.swift
//  Smart.Foundation
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A strategy for accessing the DemoSecurity view
public class DemoSecurityViewAccessStrategy {

	// MARK: - Private Stored Properties
	
	fileprivate var emailTextField:			UITextField?
	fileprivate var passwordTextField:		UITextField?
	fileprivate var signInButton:			UIButton?
	fileprivate var signUpButton:			UIButton?
	fileprivate var userInfoLabel:			UILabel?
	
	// MARK: - Initializers
	
	private init() {
		
	}
	
	public init(_ emailTextField: UITextField, _ passwordTextField: UITextField, _ signInButton: UIButton, _ signUpButton: UIButton, _ userInfoLabel: UILabel) {
		
		self.emailTextField			= emailTextField
		self.passwordTextField		= passwordTextField
		self.signInButton			= signInButton
		self.signUpButton			= signUpButton
		self.userInfoLabel			= userInfoLabel
	}
	
}

// MARK: - Extension ProtocolDemoSecurityViewAccessStrategy

extension DemoSecurityViewAccessStrategy: ProtocolDemoSecurityViewAccessStrategy {

	// MARK: - Public Methods
	
	public func clearTextFields() {
		
		self.emailTextField!.text		= ""
		self.passwordTextField!.text	= ""
	}
	
	public func setButtons(isSignedInYN: Bool) {
		
		if (isSignedInYN) {
			
			signInButton!.isEnabled		= false
			signUpButton!.isEnabled		= false
		}
		else {
			
			signInButton!.isEnabled		= true
			signUpButton!.isEnabled		= true
		}
	}
	
	public func displayUserInfo(message: String) {
		
		self.userInfoLabel!.text = message
	}
	
	public func getEmailValue() -> String {
		
		guard self.emailTextField!.text != nil else {
			return ""
		}
		
		return self.emailTextField!.text!
	}
	
	public func getPasswordValue() -> String {
		
		guard self.passwordTextField!.text != nil else {
			return ""
		}
		
		return self.passwordTextField!.text!
	}
}
