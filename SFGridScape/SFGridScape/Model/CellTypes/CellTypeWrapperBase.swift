//
//  CellTypeWrapperBase.swift
//  SFGridScape
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import Foundation

/// A base class for classes which are a wrapper for a CellType model item
open class CellTypeWrapperBase {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var id:												String = ""
	public var name:											String = ""
	public var isSpecialYN:										Bool = false
	public var imageName:										String = ""
	public var imageData:										Data?
	public fileprivate(set) var blockedContentPositionsString:	String = ""
	public fileprivate(set) var blockedContentPositions:		[CellContentPositionTypes]?
	public fileprivate(set) var cellAttributesString:			String = ""
	public var cellAttributesWrapper:							CellAttributesWrapper = CellAttributesWrapper()
	public fileprivate(set)  var cellSideAttributesString:		String = ""
	public var cellSideAttributesWrapper:						CellSideAttributesWrapper = CellSideAttributesWrapper()
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods

	public func set(blockedContentPositionsString: String) {
		
		self.blockedContentPositions = [CellContentPositionTypes]()
		
		// Split string to array
		let items 			= blockedContentPositionsString.split(separator: ",")
		
		// Go through each item
		for s in items {
			
			let i: 			Int? = Int(s)

			guard (i != nil) else { continue }
			
			// Get position
			let position: 	CellContentPositionTypes? = CellContentPositionTypes(rawValue: i!)
			
			guard (position != nil) else { continue }
			
			// Add to array
			self.blockedContentPositions!.append(position!)
			
		}
		
	}
	
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
	
}
