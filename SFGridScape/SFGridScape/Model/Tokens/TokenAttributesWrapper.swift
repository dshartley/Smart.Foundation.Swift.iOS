//
//  TokenAttributesWrapper.swift
//  SFGridScape
//
//  Created by David on 27/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// A wrapper for a TokenAttributesWrapper model item
public class TokenAttributesWrapper {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var wrapper: DataJSONWrapper = DataJSONWrapper()
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	public init(tokenAttributesString: String) {
		
		self.set(tokenAttributesString: tokenAttributesString)
		
	}
	
	
	// MARK: - Public Methods
	
	public func toString() -> String {
		
		var result: String = ""

		// Get DataJSONWrapper from contentData
		result = JSONHelper.SerializeDataJSONWrapper(dataWrapper: self.wrapper) ?? ""
		
		return result
		
	}
	
	public func set(attribute key: String, value: String?) {
		
		if (value != nil) {
			
			self.wrapper.setParameterValue(key: key, value: value!)
			
		} else {
			
			self.wrapper.deleteParameterValue(key: key)
			
		}
		
	}
	
	public func get(attribute key: String) -> String? {
		
		var result: String? = nil
		
		result 		= self.wrapper.getParameterValue(key: key)
		
		return result
		
	}
	
	public func get() -> [String: String] {
		
		var result: [String: String] = [String: String]()
		
		for pw in self.wrapper.Params {
			
			result[pw.Key] = pw.Value
			
		}
		
		return result
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func set(tokenAttributesString: String) {
		
		var result: DataJSONWrapper = DataJSONWrapper()
		
		if (tokenAttributesString.count > 0) {
			
			// Get DataJSONWrapper from tokenAttributesString
			result = JSONHelper.DeserializeDataJSONWrapper(dataString: tokenAttributesString) ?? DataJSONWrapper()
			
		}
		
		self.wrapper = result
		
	}
	
}
