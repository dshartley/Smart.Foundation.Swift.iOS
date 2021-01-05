//
//  MathHelper.swift
//  SFCore
//
//  Created by David on 28/11/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import GLKit

/// A helper for handling math
public final class MathHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods
	
	public class func toRadians(degrees: CGFloat) -> CGFloat {

		let radians: Float = GLKMathDegreesToRadians(Float(degrees))
		
		return CGFloat(radians)
		
	}

	public class func random(_ n:Int) -> Int {
		
		return Int(arc4random_uniform(UInt32(n)))
		
	}
	
	public class func random(_ range:Range<Int>) -> Int {
		
		return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
		
	}
	
	public class func isEven(value: Int) -> Bool {
	
		let result: Bool = ((value % 2) == 0)
		
		return result
		
	}
	
}

