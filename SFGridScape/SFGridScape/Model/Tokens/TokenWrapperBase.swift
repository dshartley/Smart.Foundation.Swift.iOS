//
//  TokenWrapperBase.swift
//  SFGridScape
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

/// A base class for classes which are a wrapper for a Token model item
open class TokenWrapperBase {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var id:											String = ""
	public var column:										Int = 0
	public var row:											Int = 0
	public var imageName:									String = ""
	public var imageData:									Data?
	public fileprivate(set) var tokenAttributesString:		String = ""
	public var tokenAttributesWrapper:						TokenAttributesWrapper = TokenAttributesWrapper()

	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func set(tokenAttributesString: String) {
		
		self.tokenAttributesString 	= tokenAttributesString
		
		// Create TokenAttributesWrapper
		self.tokenAttributesWrapper 	= TokenAttributesWrapper(tokenAttributesString: tokenAttributesString)
		
		self.refreshTokenAttributesString()
		
	}
	
	public func refreshTokenAttributesString() {
		
		self.tokenAttributesString = self.tokenAttributesWrapper.toString()
	
	}
	
}
