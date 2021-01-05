//
//  BlockCoord.swift
//  SFGridScape
//
//  Created by David on 13/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a BlockCoord item
public class BlockCoord {
	
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
	
}
