//
//  DemoSecurityHomeViewManager.swift
//  Smart.Foundation
//
//  Created by David on 07/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView

/// Manages the DemoSecurityHome view layer
public class DemoSecurityHomeViewManager: ViewManagerBase {

	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolDemoSecurityHomeViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolDemoSecurityHomeViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func setButtons(isSignedInYN: Bool) {
		
		self.viewAccessStrategy!.setButtons(isSignedInYN: isSignedInYN)
	}
	
	public func displayUserInfo(message: String) {
		
		self.viewAccessStrategy!.displayUserInfo(message: message)
	}
	
}
