//
//  DemoSecurityHomeViewManager.swift
//  Smart.Foundation
//
//  Created by David on 07/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A strategy for accessing the DemoSecurityHome view
public class DemoSecurityHomeViewAccessStrategy {

	// MARK: - Private Stored Properties
	
	fileprivate var signOutButton:			UIButton?
	fileprivate var userInfoLabel:			UILabel?
	
	
	// MARK: - Initializers
	
	private init() {
		
	}
	
	public init(_ signOutButton: UIButton, _ userInfoLabel: UILabel) {

		self.signOutButton			= signOutButton
		self.userInfoLabel			= userInfoLabel
	}
	
}

// MARK: - Extension ProtocolDemoSecurityHomeViewAccessStrategy

extension DemoSecurityHomeViewAccessStrategy: ProtocolDemoSecurityHomeViewAccessStrategy {
	
	// MARK: - Public Methods
	
	public func setButtons(isSignedInYN: Bool) {
		
		if (isSignedInYN) {
			
			signOutButton!.isEnabled	= true
		}
		else {
			
			signOutButton!.isEnabled	= false
		}
	}
	
	public func displayUserInfo(message: String) {
		
		DispatchQueue.main.async {
			
			self.userInfoLabel!.text = message
		}
	}

}
