//
//  LocalizationHelper.swift
//  SFGlobalization
//
//  Created by David on 17/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Specifies localized resource types
public enum LocalizedResourceTypes : Int {
	case strings = 1
	case plist = 2
}

/// A helper for handling localization
public struct LocalizationHelper {

	// MARK: - Private Stored Properties
	
	fileprivate var bundle: Bundle?
	
	
	// MARK: - Initializers
	
	fileprivate init () {}
	
	public init(bundle: Bundle) {
		
		self.bundle = bundle
	}
	
	
	// MARK: - Public Methods
	
	public func localizedString(forKey key: String) -> String? {
		
		guard (self.bundle != nil) else { return nil }

		return self.localizedString(forKey: key, from: .strings)
		
	}
	
	public func localizedString(forKey key: String, from resourceType: LocalizedResourceTypes) -> String? {
		
		guard (self.bundle != nil) else { return nil }
		
		var result: String? = nil

		if (resourceType == .strings) {
			
			// Use Localizable.strings
			result = self.bundle!.localizedString(forKey: key, value: nil, table: nil)
			
		} else if (resourceType == .plist) {
			
			var plistDictionary: NSDictionary? = nil
			
			// Get path to Localizable.plist
			if let plistPath = self.bundle!.path(forResource: "Localizable", ofType: "plist") {
				
				// Get plistDictionary
				plistDictionary = NSDictionary(contentsOfFile: plistPath)
				
				// Get plistItem
				let plistItem: NSDictionary? = plistDictionary!.value(forKey: key) as? NSDictionary
				
				result = plistItem?.value(forKey: "value") as? String
				
			}
			
		}
		
		return result
	}
	
}
