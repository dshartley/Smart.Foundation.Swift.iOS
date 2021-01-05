//
//  CellCoordRange.swift
//  SFGridScape
//
//  Created by David on 18/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a CellCoordRange item
public class CellCoordRange {
	
	// MARK: - Public Stored Properties
	
	public var topLeft: 		CellCoord
	public var bottomRight: 	CellCoord
	
	
	// MARK: - Initializers
	
	public init(topLeft: CellCoord, bottomRight: CellCoord) {
	
		self.topLeft 		= topLeft
		self.bottomRight 	= bottomRight
		
	}
	
	
	// MARK: - Public Methods
	
	public func add(range: CellCoordRange) {
	
		if (range.topLeft.column < self.topLeft.column) {
			
			self.topLeft.column = range.topLeft.column
			
		}

		if (range.topLeft.row < self.topLeft.row) {
			
			self.topLeft.row = range.topLeft.row
			
		}

		if (range.bottomRight.column > self.bottomRight.column) {
			
			self.bottomRight.column = range.bottomRight.column
			
		}
		
		if (range.topLeft.row > self.topLeft.row) {
			
			self.bottomRight.row = range.bottomRight.row
			
		}
		
	}
	
	public func toCellCoords() -> [CellCoord] {
	
		var result: [CellCoord] = [CellCoord]()
		
		// Go through each column
		for ci in self.topLeft.column...self.bottomRight.column {
			
			// Go through each row
			for ri in self.topLeft.row...self.bottomRight.row {
				
				// Create cellCoord
				let cellCoord: CellCoord = CellCoord(column: ci, row: ri)
				
				result.append(cellCoord)
				
			}
			
		}
		
		return result
		
	}
	
	public func contains(cellCoord: CellCoord) -> Bool {
		
		var result: Bool = false
		
		if (cellCoord.column >= self.topLeft.column && cellCoord.column <= self.bottomRight.column
			&& cellCoord.row >= self.topLeft.row && cellCoord.row <= self.bottomRight.row) {
			
			result = true
			
		}
		
		return result
		
	}
	
}
