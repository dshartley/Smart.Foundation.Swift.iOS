//
//  ApplicationFlags.swift
//  SFCore
//
//  Created by David on 04/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A singleton class for managing application flags
public class ApplicationFlags {
	
	// MARK: - Private Static Stored Properties
	
	fileprivate static var singleton:		ApplicationFlags? = nil

	
	// MARK: - Private Stored Properties
	
	fileprivate var flags:					[String:Bool] = [String:Bool]()
	
	
	// MARK: - Private Class Computed Properties
	
	fileprivate class var shared: ApplicationFlags {
		get {
			
			if (ApplicationFlags.singleton == nil) {
				ApplicationFlags.singleton = ApplicationFlags()
			}
			
			return ApplicationFlags.singleton!
		}
	}

	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func flag(key: String) -> Bool {
		
		return ApplicationFlags.shared.flags[key] ?? false
		
	}
	
	public class func flag(key: String, value: Bool) {
		
		ApplicationFlags.shared.flags[key] = value
		
	}
	
	
	// MARK: - Private Methods

}
