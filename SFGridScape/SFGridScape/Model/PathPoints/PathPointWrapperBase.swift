//
//  PathPointWrapperBase.swift
//  SFGridScape
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

/// A base class for classes which are a wrapper for a PathPoint model item
open class PathPointWrapperBase {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var id:			String = ""
	public var pathID:		String = ""
	public var index:		Int = 0
	public var column:		Int = 0
	public var row:			Int = 0
	public var doneYN:		Bool = false

	
	// MARK: - Public Computed Properties
	
	public var cellCoord: CellCoord {
		get {
			
			return CellCoord(column: self.column, row: self.row)
			
		}
	}
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	open func dispose() {
		
	}
	
}
