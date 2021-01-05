//
//  ParameterJSONWrapper.swift
//  SFSerialization
//
//  Created by David on 01/03/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

public class ParameterJSONWrapper: Codable {

	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var 	Key: String = ""
	public var 	Value: String = ""
	
	
	// MARK: - Initializers
	
	public init() {
		
	}

	public init(key: String, value: String) {
		
		self.Key 	= key
		self.Value 	= value
	}
	
	
	// MARK: - Public Methods
	
	
	
}
