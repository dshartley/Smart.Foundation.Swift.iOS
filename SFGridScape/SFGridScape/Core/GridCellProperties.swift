//
//  GridCellProperties.swift
//  PlayGridViewDemo
//
//  Created by David on 12/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a GridCellProperties item
public class GridCellProperties {

	// MARK: - Public Stored Properties
	
	public var cellCoord:					CellCoord?
	public var cellWidth: 					CGFloat = 0
	public var cellHeight: 					CGFloat = 0
	public var rotationDegrees:				Int = 0
	public var backgroundColor:				UIColor? = nil
	public var borderColor:					UIColor? = nil
	public var borderWidth:					CGFloat? = nil
	public var highlightBackgroundColor:	UIColor? = nil
	public var highlightFilterColor:		UIColor? = nil
	public var highlightBorderColor:		UIColor? = nil
	public var highlightBorderWidth:		CGFloat? = nil
	public var canDragYN: 					Bool = true
	public var canTapYN: 					Bool = true
	public var canLongPressYN: 				Bool = true
	
	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}

	public init(cellCoord: CellCoord) {
		
		self.cellCoord = cellCoord
		
	}
	
	
	// MARK: - Public Methods
	
	public func copy() -> GridCellProperties {
	
		let result: GridCellProperties = GridCellProperties()
		
		result.cellCoord 					= nil
		
		if (self.cellCoord != nil) {
			
			result.cellCoord = CellCoord(column: self.cellCoord!.column, row: self.cellCoord!.row)
			
		}
		
		result.cellWidth 					= self.cellWidth
		result.cellHeight 					= self.cellHeight
		result.rotationDegrees 				= self.rotationDegrees
		result.backgroundColor 				= self.backgroundColor
		result.borderColor 					= self.borderColor
		result.borderWidth 					= self.borderWidth
		result.highlightBackgroundColor 	= self.highlightBackgroundColor
		result.highlightFilterColor			= self.highlightFilterColor
		result.highlightBorderColor 		= self.highlightBorderColor
		result.highlightBorderWidth 		= self.highlightBorderWidth
		
		return result
		
	}
	
}
