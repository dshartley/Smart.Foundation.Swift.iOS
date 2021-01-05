//
//  DMViewAccessStrategy.swift
//  Smart.Foundation
//
//  Created by David on 25/07/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A strategy for accessing the DM view
public class DMViewAccessStrategy {

	// MARK: - Private Stored Properties
	
	fileprivate var idTextField:				UITextField?
	fileprivate var stringValueTextField:		UITextField?
	fileprivate var numericValueTextField:		UITextField?
	
	
	// MARK: - Initializers
	
	private init() {
		
	}
	
	public init(_ idTextField: UITextField, _ stringValueTextField: UITextField, _ numericValueTextField: UITextField) {
		
		self.idTextField			= idTextField
		self.stringValueTextField	= stringValueTextField
		self.numericValueTextField	= numericValueTextField
	}
	
}

// MARK: - Extension ProtocolDMViewAccessStrategy

extension DMViewAccessStrategy: ProtocolDMViewAccessStrategy {
	
	// MARK: - Public Methods
	
	public func getID() -> String {
		
		guard self.idTextField!.text != nil else {
			return ""
		}
		
		return self.idTextField!.text!
	}
	
	public func getStringValue() -> String {
		
		guard self.stringValueTextField!.text != nil else {
			return ""
		}
		
		return self.stringValueTextField!.text!
	}
	
	public func getNumericValue() -> String {
		
		guard self.numericValueTextField!.text != nil else {
			return ""
		}
		
		return self.numericValueTextField!.text!
	}
	
}
