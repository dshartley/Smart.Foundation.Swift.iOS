//
//  IntHelper.swift
//  SFCore
//
//  Created by David on 24/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

public struct IntHelper {

	/// Get random number in specified range. Usage; var aRandomInt = Int.random(-500...100)
	///
	/// - Parameter range: The range
	/// - Returns: The random number
	public static func random(range: CountableClosedRange<Int> ) -> Int {
		var offset = 0
		
		if range.lowerBound < 0   // Allow negative ranges
		{
			offset = abs(range.lowerBound)
		}
		
		let mini = UInt32(range.lowerBound	+ offset)
		let maxi = UInt32(range.upperBound  + offset)
		
		return Int(mini + arc4random_uniform(maxi - mini)) - offset
	}
}
