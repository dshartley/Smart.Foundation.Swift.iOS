//
//  TileWrapperBase.swift
//  SFGridScape
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

/// A base class for classes which are a wrapper for a Tile model item
open class TileWrapperBase {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var id:											String = ""
	public var tileTypeID:									String = ""
	public fileprivate(set) var tileTypeWrapper:			TileTypeWrapperBase? = nil
	public var column:										Int = 0
	public var row:											Int = 0
	public var rotationDegrees:								Int = 0
	public var imageName:									String = ""
	public var imageData:									Data?
	public var widthPixels:									Int = 0
	public var heightPixels:								Int = 0
	public var position:									CellContentPositionTypes = .Center
	public var positionFixToCellRotationYN:					Bool = true
	public fileprivate(set) var tileAttributesString:		String = ""
	public var tileAttributesWrapper:						TileAttributesWrapper = TileAttributesWrapper()
	public fileprivate(set)  var tileSideAttributesString:	String = ""
	public var tileSideAttributesWrapper:					TileSideAttributesWrapper = TileSideAttributesWrapper()

	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func set(tileAttributesString: String) {
		
		self.tileAttributesString 	= tileAttributesString
		
		// Create TileAttributesWrapper
		self.tileAttributesWrapper 	= TileAttributesWrapper(tileAttributesString: tileAttributesString)
		
		self.refreshTileAttributesString()
		
	}
	
	public func refreshTileAttributesString() {
		
		self.tileAttributesString = self.tileAttributesWrapper.toString()
		
	}
	
	public func set(tileSideAttributesString: String) {
		
		self.tileSideAttributesString 	= tileSideAttributesString
		
		// Create TileSideAttributesWrapper
		self.tileSideAttributesWrapper 	= TileSideAttributesWrapper(tileSideAttributesString: tileSideAttributesString)
		
		self.refreshTileSideAttributesString()
		
	}
	
	public func refreshTileSideAttributesString() {
		
		self.tileSideAttributesString = self.tileSideAttributesWrapper.toString()
		
	}
	
	public func set(tileTypeWrapper: TileTypeWrapperBase) {
		
		self.tileTypeWrapper 	= tileTypeWrapper
		
		// Set properties from the tileTypeWrapper
		self.tileTypeID 		= tileTypeWrapper.id
		
		// Set imageName, imageData
		if (self.imageName.count == 0 && self.imageData == nil) {
			
			self.imageName 		= tileTypeWrapper.imageName
			self.imageData 		= tileTypeWrapper.imageData
			
		}
		
		// Set widthPixels
		if (self.widthPixels == 0) {
			
			self.widthPixels 	= tileTypeWrapper.widthPixels
			
		}
		
		// Set heightPixels
		if (self.heightPixels == 0) {
			
			self.heightPixels 	= tileTypeWrapper.heightPixels
			
		}
		
	}
	
}
