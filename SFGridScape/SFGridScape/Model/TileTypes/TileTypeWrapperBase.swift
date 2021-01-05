//
//  TileTypeWrapperBase.swift
//  SFGridScape
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A base class for classes which are a wrapper for a TileType model item
open class TileTypeWrapperBase {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var id:											String = ""
	public var name:										String = ""
	public var isSpecialYN:									Bool = false
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
	
}
