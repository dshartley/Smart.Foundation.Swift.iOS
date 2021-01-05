//
//  GridTileProperties.swift
//  PlayGridViewDemo
//
//  Created by David on 12/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a GridTileProperties item
public class GridTileProperties {

	// MARK: - Public Stored Properties
	
	public var cellCoord:					CellCoord?
	public var key:							String?
	public var tileWidth: 					CGFloat = 0
	public var tileHeight: 					CGFloat = 0
	public var position:					CellContentPositionTypes = .Center
	public var positionFixToCellRotationYN:	Bool = true
	public var rotationDegrees:				Int = 0
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
	
	public func copy() -> GridTileProperties {
		
		let result: 							GridTileProperties = GridTileProperties()
		
		result.cellCoord 						= nil
		
		if (self.cellCoord != nil) {
			
			result.cellCoord = CellCoord(column: self.cellCoord!.column, row: self.cellCoord!.row)
			
		}
		
		result.key 								= self.key
		result.tileWidth 						= self.tileWidth
		result.tileHeight 						= self.tileHeight
		result.position							= self.position
		result.positionFixToCellRotationYN		= self.positionFixToCellRotationYN
		result.rotationDegrees 					= self.rotationDegrees

		return result
		
	}
	
}
