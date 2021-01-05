//
//  GridTokenProperties.swift
//  PlayGridViewDemo
//
//  Created by David on 12/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a GridTokenProperties item
public class GridTokenProperties {

	// MARK: - Public Stored Properties
	
	public var cellCoord:			CellCoord?
	public var key:					String?
	public var tokenWidth: 			CGFloat = 0
	public var tokenHeight: 		CGFloat = 0
	public var canDragYN: 			Bool = true
	public var canTapYN: 			Bool = true
	public var canLongPressYN: 		Bool = true
	
	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}
	
	public init(cellCoord: CellCoord) {
		
		self.cellCoord = cellCoord
		
	}
	
	
	// MARK: - Public Methods
	
	public func copy() -> GridTokenProperties {
		
		let result: 		GridTokenProperties = GridTokenProperties()
		
		result.cellCoord 	= nil
		
		if (self.cellCoord != nil) {
			
			result.cellCoord = CellCoord(column: self.cellCoord!.column, row: self.cellCoord!.row)
			
		}
		
		result.key 			= self.key
		result.tokenWidth 	= self.tokenWidth
		result.tokenHeight 	= self.tokenHeight

		return result
		
	}
	
}
