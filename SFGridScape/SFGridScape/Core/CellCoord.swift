//
//  CellCoord.swift
//  SFGridScape
//
//  Created by David on 12/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a CellCoord item
public class CellCoord {

	// MARK: - Public Stored Properties
	
	public var row: 	Int = 0
	public var column: 	Int = 0
	

	// MARK: - Initializers
	
	public init() {
		
	}

	public init(column: Int, row: Int) {
		
		self.column 	= column
		self.row 		= row
		
	}
	
	
	// MARK: - Public Methods
	
	public func equals(cellCoord: CellCoord) -> Bool {
		
		var result: Bool = false
		
		if (self.column == cellCoord.column && self.row == cellCoord.row) {
			
			result = true
			
		}
			
		return result
		
	}
	
	public func copy() -> CellCoord {
		
		let result: CellCoord = CellCoord(column: self.column, row: self.row)
		
		return result
		
	}
}
