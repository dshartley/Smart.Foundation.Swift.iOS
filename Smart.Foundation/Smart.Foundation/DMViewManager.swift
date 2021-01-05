//
//  DMViewManager.swift
//  Smart.Foundation
//
//  Created by David on 23/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView

/// Manages the DM view layer
public class DMViewManager : ViewManagerBase {
	
	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolDMViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolDMViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func getID() -> String {
		
		return self.viewAccessStrategy!.getID()
	}

	public func getStringValue() -> String {
		
		return self.viewAccessStrategy!.getStringValue()
	}

	public func getNumericValue() -> String {
		
		return self.viewAccessStrategy!.getNumericValue()
	}
	
}
