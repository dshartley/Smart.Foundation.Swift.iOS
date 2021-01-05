//
//  GridCellNeighbour.swift
//  SFGridScape
//
//  Created by David on 27/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a GridCellNeighbour item
public class GridCellNeighbour {
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var cellView:			ProtocolGridCellView?
	public fileprivate(set) var position: 			CellNeighbourPositionTypes = .top
	public fileprivate(set) var myTouchingSide: 	CellSideTypes? = nil
	public fileprivate(set) var isTouchingYN:		Bool = false

	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}

	public init(cellView: ProtocolGridCellView) {
		
		self.cellView = cellView
		
	}

	public init(cellView: ProtocolGridCellView, position: CellNeighbourPositionTypes) {
		
		self.cellView = cellView
		
		self.set(position: position)
	}
	
	
	// MARK: - Public Methods
	
	public func set(position: CellNeighbourPositionTypes) {
		
		self.position 			= position
		
		// Set myTouchingSide
		self.myTouchingSide 	= GridCellNeighbour.toMyTouchingSide(myPosition: position)
		
		self.isTouchingYN		= (self.myTouchingSide != nil)
		
	}
	
	public func getMyTouchingSideAttributes() -> [String: String] {
		
		var result: 	[String: String] = [String: String]()
		
		guard (self.myTouchingSide != nil) else { return result }
		
		// Get attributes
		result 			= self.cellView!.get(cellSideAttributes: self.myTouchingSide!)
		
		return result
		
	}
	
	public func getYourTouchingSideAttributes(for cellView: ProtocolGridCellView) -> [String: String] {
		
		var result: 			[String: String] = [String: String]()
		
		// Get yourTouchingSide
		let yourTouchingSide: 	CellSideTypes? = GridCellNeighbour.toYourTouchingSide(myPosition: self.position)
		
		guard (yourTouchingSide != nil) else { return result }
		
		// Get attributes
		result = cellView.get(cellSideAttributes: yourTouchingSide!)
		
		return result
		
	}
	
	
	// MARK: - Private Methods
	
	public class func toMyTouchingSide(myPosition: CellNeighbourPositionTypes) -> CellSideTypes? {
		
		var result: CellSideTypes? = nil
		
		switch myPosition {
		case .top:
			result = .bottom
		case .right:
			result = .left
		case .bottom:
			result = .top
		case .left:
			result = .right
		default:
			result = nil
		}
		
		return result

	}

	public class func toYourTouchingSide(myPosition: CellNeighbourPositionTypes) -> CellSideTypes? {
		
		var result: CellSideTypes? = nil
		
		switch myPosition {
		case .top:
			result = .top
		case .right:
			result = .right
		case .bottom:
			result = .bottom
		case .left:
			result = .left
		default:
			result = nil
		}
		
		return result
		
	}
	
}
