//
//  ApplicationVariables.swift
//  SFCore
//
//  Created by David on 16/08/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A singleton class for managing application variables
public class ApplicationVariables {
	
	// MARK: - Private Static Stored Properties
	
	fileprivate static var singleton:		ApplicationVariables? = nil
	
	
	// MARK: - Private Stored Properties

	fileprivate var values:					[String:String] = [String:String]()
	
	
	// MARK: - Private Class Computed Properties
	
	fileprivate class var shared: ApplicationVariables {
		get {
			
			if (ApplicationVariables.singleton == nil) {
				ApplicationVariables.singleton = ApplicationVariables()
			}
			
			return ApplicationVariables.singleton!
		}
	}
	
	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func get(key: String) -> String? {
		
		return ApplicationVariables.shared.values[key]
		
	}
	
	public class func set(key: String, value: String) {
		
		ApplicationVariables.shared.values[key] = value
		
	}
	
	
	// MARK: - Private Methods
	
}
