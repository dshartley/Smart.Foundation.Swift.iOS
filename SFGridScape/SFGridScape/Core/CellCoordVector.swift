//
//  CellCoordVector.swift
//  SFGridScape
//
//  Created by David on 22/12/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a CellCoordVector item
public class CellCoordVector {

	// MARK: - Public Stored Properties
	
	public var from: 	CellCoord
	public var to: 		CellCoord
	
	
	// MARK: - Public Computed Properties
	
	
	// MARK: - Initializers

	public init(from: CellCoord, to: CellCoord) {
		
		self.from 	= from
		self.to 	= to
		
	}
	
	
	// MARK: - Public Methods
	
}
