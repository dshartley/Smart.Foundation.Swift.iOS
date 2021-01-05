//
//  GridBlockProperties.swift
//  PlayGridViewDemo
//
//  Created by David on 12/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a GridBlockProperties item
public class GridBlockProperties {

	// MARK: - Public Stored Properties
	
	public var blockCoord:			BlockCoord?
	public var cellCoordRange:		CellCoordRange?

	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}
	
	public init(blockCoord: BlockCoord) {
		
		self.blockCoord = blockCoord
		
	}
	
}
