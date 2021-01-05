//
//  SFCollectionViewLayoutAttributes.swift
//  SFView
//
//  Created by David on 29/06/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Encapsulates attributes for a SFCollectionViewLayout item
public class SFCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

	// MARK: - Public Stored Properties
	
	public var items: [String:Any] = [:]
	
	
	// MARK: - Override Methods
	
	/// Returns a new instance that’s a copy of the receiver.
	///
	/// - Parameter zone: The zone
	/// - Returns: The copy
	public override func copy(with zone: NSZone? = nil) -> Any {
		
		let copy = super.copy(with: zone) as! SFCollectionViewLayoutAttributes
		
		// Copy the items
		copy.items = items
		
		return copy
	}
	
	/// Returns a Boolean value that indicates whether the receiver and a given object are equal.
	///
	/// - Parameter object: The object
	/// - Returns: true if the receiver and anObject are equal, otherwise false.
	public override func isEqual(_ object: Any?) -> Bool {
		
		if let attributes = object as? SFCollectionViewLayoutAttributes {
			
			var isEqualYN: Bool = true
			
			// Go through each item in the dictionary
			for (key, value) in self.items {
				
				// Check there is a value to compare
				if let checkValue = attributes.items[key] {
	
					// Check String
					if let value = value as? String, let checkValue = checkValue as? String {
						if (value != checkValue) { isEqualYN = false }
					}
					
					// Check Float
					if let value = value as? Float, let checkValue = checkValue as? Float {
						if (value != checkValue) { isEqualYN = false }
					}

					// Check NSInteger
					if let value = value as? NSInteger, let checkValue = checkValue as? NSInteger {
						if (value != checkValue) { isEqualYN = false }
					}
					
				} else {
					isEqualYN = false
				}
			}
			
			// Check isEqual
			if (isEqualYN) {
				return super.isEqual(object)
			}
		}
		
		return false
	}
	
}
