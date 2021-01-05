//
//  DemoSecurityViewManager.swift
//  Smart.Foundation
//
//  Created by David on 01/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView

/// Manages the DemoSecurity view layer
public class DemoSecurityViewManager : ViewManagerBase {

	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolDemoSecurityViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolDemoSecurityViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func clearTextFields() {
		
		self.viewAccessStrategy!.clearTextFields()
	}
	
	public func setButtons(isSignedInYN: Bool) {
		
		self.viewAccessStrategy!.setButtons(isSignedInYN: isSignedInYN)
	}
	
	public func displayUserInfo(message: String) {
		
		self.viewAccessStrategy!.displayUserInfo(message: message)
	}
	
	public func getEmailValue() -> String {
		
		return self.viewAccessStrategy!.getEmailValue()
	}
	
	public func getPasswordValue() -> String {
		
		return self.viewAccessStrategy!.getPasswordValue()
	}
	
}
