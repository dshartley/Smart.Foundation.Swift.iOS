//
//  SettingsManager.swift
//  SFCore
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

// Manages settings
public struct SettingsManager {

	// MARK: - Private Stored Properties
	
	// MARK: - Private Static Properties
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Initializers
	
	fileprivate init() {
	}
	
	
	// MARK: - Public Static Methods
	
	public static func set(string value: String, forKey key: String) {

		UserDefaults.standard.setValue(value, forKey: key)
		
	}

	public static func set(string value: String, forKey key: String, prefix: String) {
		
		let k: String = "\(prefix)_\(key)"
		
		UserDefaults.standard.setValue(value, forKey: k)
		
	}
	
	public static func get(stringForKey key: String) -> String? {
		
		return UserDefaults.standard.string(forKey: key)
	}

	public static func get(stringForKey key: String, prefix: String) -> String? {
		
		let k: String = "\(prefix)_\(key)"
		
		return UserDefaults.standard.string(forKey: k)
	}
	
	public static func set(int value: Int, forKey key: String) {
		
		UserDefaults.standard.setValue(value, forKey: key)
	}

	public static func set(int value: Int, forKey key: String, prefix: String) {
		
		let k: String = "\(prefix)_\(key)"
		
		UserDefaults.standard.setValue(value, forKey: k)
	}
	
	public static func clear(forKey key: String, prefix: String) {
	
		let k: String = "\(prefix)_\(key)"
		
		UserDefaults.standard.removeObject(forKey: k)
	}
	
	public static func get(intForKey key: String) -> Int? {
		
		return UserDefaults.standard.integer(forKey: key)
	}

	public static func get(intForKey key: String, prefix: String) -> Int? {
		
		let k: String = "\(prefix)_\(key)"
		
		return UserDefaults.standard.integer(forKey: k)
	}
	
	public static func set(bool value: Bool, forKey key: String) {
		
		UserDefaults.standard.setValue(value, forKey: key)
	}

	public static func set(bool value: Bool, forKey key: String, prefix: String) {
		
		let k: String = "\(prefix)_\(key)"
		
		UserDefaults.standard.setValue(value, forKey: k)
	}
	
	public static func get(boolForKey key: String) -> Bool? {
		
		return UserDefaults.standard.bool(forKey: key)
	}

	public static func get(boolForKey key: String, prefix: String) -> Bool? {
		
		let k: String = "\(prefix)_\(key)"
		
		return UserDefaults.standard.bool(forKey: k)
	}
	
}
