//
//  BoolHelper.swift
//  SFCore
//
//  Created by David on 12/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// A helper for handling bools
public struct BoolHelper {
	
	/// Get boolean value to int
	///
	/// - Parameter value: The value
	/// - Returns: The int
	public static func toInt(value: Bool) -> Int {
		
		var result:	Int = 0
		
		result = NSNumber.init(booleanLiteral: value).intValue
		
		return result
	}

	public static func fromString(value: String) -> Bool {
		
		if (value == "1") { return true }
		if (value == "0") { return false }
		
		let result: Bool = Bool.init(value) ?? false
		
		return result
	}
	
}
