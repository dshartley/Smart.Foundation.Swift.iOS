//
//  CellWrapperBase.swift
//  SFGridScape
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

/// A base class for classes which are a wrapper for a Cell model item
open class CellWrapperBase {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var id:											String = ""
	public var cellTypeID:									String = ""
	public fileprivate(set) var cellTypeWrapper:			CellTypeWrapperBase? = nil
	public var column:										Int = 0
	public var row:											Int = 0
	public var rotationDegrees:								Int = 0
	public var imageName:									String = ""
	public var imageData:									Data?
	public fileprivate(set) var cellAttributesString:		String = ""
	public var cellAttributesWrapper:						CellAttributesWrapper = CellAttributesWrapper()
	public fileprivate(set)  var cellSideAttributesString:	String = ""
	public var cellSideAttributesWrapper:					CellSideAttributesWrapper = CellSideAttributesWrapper()
	public var tileWrapper:									TileWrapperBase? = nil
	public var tokenWrapper:								TokenWrapperBase? = nil
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func set(cellAttributesString: String) {
		
		self.cellAttributesString 	= cellAttributesString
		
		// Create CellAttributesWrapper
		self.cellAttributesWrapper 	= CellAttributesWrapper(cellAttributesString: cellAttributesString)
		
		self.refreshCellAttributesString()
		
	}
	
	public func refreshCellAttributesString() {
		
		self.cellAttributesString = self.cellAttributesWrapper.toString()
		
	}

	public func set(cellSideAttributesString: String) {
		
		self.cellSideAttributesString 	= cellSideAttributesString
		
		// Create CellSideAttributesWrapper
		self.cellSideAttributesWrapper 	= CellSideAttributesWrapper(cellSideAttributesString: cellSideAttributesString)
		
		self.refreshCellSideAttributesString()
		
	}
	
	public func refreshCellSideAttributesString() {
		
		self.cellSideAttributesString = self.cellSideAttributesWrapper.toString()
		
	}
	
	public func set(cellTypeWrapper: CellTypeWrapperBase) {
		
		self.cellTypeWrapper 	= cellTypeWrapper
		
		// Set properties from the cellTypeWrapper
		self.cellTypeID 		= cellTypeWrapper.id
		
		if (self.imageName.count == 0 && self.imageData == nil) {
			
			self.imageName 		= cellTypeWrapper.imageName
			self.imageData 		= cellTypeWrapper.imageData
			
		}

	}
	
}
