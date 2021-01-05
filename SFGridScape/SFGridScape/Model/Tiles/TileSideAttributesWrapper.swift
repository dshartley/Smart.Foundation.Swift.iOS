//
//  TileSideAttributesWrapper.swift
//  SFGridScape
//
//  Created by David on 27/09/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// A wrapper for a TileSideAttributesWrapper model item
public class TileSideAttributesWrapper {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var wrapper: DataJSONWrapper = DataJSONWrapper()
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	public init(tileSideAttributesString: String) {
		
		self.set(tileSideAttributesString: tileSideAttributesString)
		
	}
	
	
	// MARK: - Public Methods
	
	public func toString() -> String {
		
		var result: String = ""
		
		// Get DataJSONWrapper from contentData
		result = JSONHelper.SerializeDataJSONWrapper(dataWrapper: self.wrapper) ?? ""

		return result
		
	}
	
	public func set(attribute key: String, value: String?, forSideByTrueDegrees trueDegrees: Int) {

		// Get wrapper for side attributes
		var w: 		DataJSONWrapper? = self.wrapper.getItem(id: "\(trueDegrees)")

		if (w == nil && value != nil) {

			w 		= DataJSONWrapper()
			w!.ID 	= "\(trueDegrees)"
			self.wrapper.Items.append(w!)

		}

		if (value != nil) {

			w!.setParameterValue(key: key, value: value!)

		} else {

			w!.deleteParameterValue(key: key)

		}

	}

	public func get(attribute key: String, forSideByTrueDegrees trueDegrees: Int) -> String? {
		
		var result: 	String? = nil
		
		// Get wrapper for side attributes
		let w: 			DataJSONWrapper? = self.wrapper.getItem(id: "\(trueDegrees)")
		
		result 			= w?.getParameterValue(key: key)
		
		return result
		
	}
	
	public func get(forSideByTrueDegrees trueDegrees: Int) -> [String: String] {
		
		var result: 	[String: String] = [String: String]()
		
		// Get wrapper for side attributes
		let w: 			DataJSONWrapper? = self.wrapper.getItem(id: "\(trueDegrees)")
		
		guard (w != nil) else { return result }
		
		for pw in w!.Params {
			
			result[pw.Key] = pw.Value
			
		}
		
		return result
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func set(tileSideAttributesString: String) {
		
		var result: DataJSONWrapper = DataJSONWrapper()
		
		if (tileSideAttributesString.count > 0) {
			
			// Get DataJSONWrapper from tileSideAttributesString
			result = JSONHelper.DeserializeDataJSONWrapper(dataString: tileSideAttributesString) ?? DataJSONWrapper()
			
		}
		
		self.wrapper = result
		
	}
	
}

