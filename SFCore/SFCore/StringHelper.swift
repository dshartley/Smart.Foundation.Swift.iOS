//
//  StringHelper.swift
//  SFCore
//
//  Created by David on 16/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling strings
public struct StringHelper {

	// MARK: - Public Static Methods

	/// Get index of a first occurrence of a character in a string
	///
	/// - Parameters:
	///   - characterToFind: The character to find
	///   - source: The source string
	/// - Returns: The index
	public static func indexOf(character characterToFind:Character, in sourceString:String) -> Int {
		
		var result:	Int	= -1
		var i:		Int	= -1
		
		for character in sourceString {
			i += 1
			
			if character == characterToFind { result = i }
		}
		
		return result
	}

	/// Check if string is numeric
	///
	/// - Parameter sourceString: The sourceString
	/// - Returns: True if the string is numeric
	public static func isNumeric(_ sourceString: String) -> Bool {
		
		let c:				CharacterSet	= NSCharacterSet(charactersIn: sourceString) as CharacterSet
		
		let isNumericYN:	Bool			= NSCharacterSet.decimalDigits.isSuperset(of: c)
		
		return isNumericYN
	}
	
}
