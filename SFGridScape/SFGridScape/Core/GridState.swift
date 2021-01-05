//
//  GridState.swift
//  PlayGridViewDemo
//
//  Created by David on 12/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a GridState item
public class GridState {

	// MARK: - Public Stored Properties

	public fileprivate(set) var indicatedOffsetX: 					CGFloat = 0
	public fileprivate(set) var indicatedOffsetY: 					CGFloat = 0
	public fileprivate(set) var indicatedOffsetTransform: 			CGAffineTransform = CGAffineTransform(translationX: 0, y: 0)
	public fileprivate(set) var selectedIndicatedPoint:				CGPoint?
	public fileprivate(set) var selectedTruePoint:					CGPoint?
	public fileprivate(set) var selectedCellCoord: 					CellCoord?
	public fileprivate(set) var selectedBlockCoord: 				BlockCoord?
	public var firstBlockColumnIndex:								Int = 0
	public var firstBlockColumnTrueMinX:							CGFloat = 0
	public var firstBlockColumnTrueMaxX:							CGFloat = 0
	public var lastBlockColumnIndex:								Int = -1
	public var lastBlockColumnTrueMinX:								CGFloat = 0
	public var lastBlockColumnTrueMaxX:								CGFloat = 0
	public var firstBlockRowIndex:									Int = 0
	public var firstBlockRowTrueMinY:								CGFloat = 0
	public var firstBlockRowTrueMaxY:								CGFloat = 0
	public var lastBlockRowIndex:									Int = -1
	public var lastBlockRowTrueMinY:								CGFloat = 0
	public var lastBlockRowTrueMaxY:								CGFloat = 0
	public var firstCellColumnIndex:								Int = 0
	public var lastCellColumnIndex:									Int = -1
	public var firstCellRowIndex:									Int = 0
	public var lastCellRowIndex:									Int = -1
	public fileprivate(set) var firstPopulatedCellColumnIndex:		Int? = nil
	public fileprivate(set) var firstPopulatedCellColumnMinX:		CGFloat? = nil
	public fileprivate(set) var firstPopulatedCellRowIndex:			Int? = nil
	public fileprivate(set) var firstPopulatedCellRowMinY:			CGFloat? = nil
	public fileprivate(set) var lastPopulatedCellColumnIndex:		Int? = nil
	public fileprivate(set) var lastPopulatedCellColumnMaxX:		CGFloat? = nil
	public fileprivate(set) var lastPopulatedCellRowIndex:			Int? = nil
	public fileprivate(set) var lastPopulatedCellRowMaxY:			CGFloat? = nil
	public var marginFrame: 										CGRect?
	public var isBuildingBlocksYN:									Bool = false
	public var gridScrollState:										GridScrollState? = nil
	public var gridSizeFirstCellColumnMinX:							CGFloat? = nil
	public var gridSizeFirstCellRowMinY:							CGFloat? = nil
	public var gridSizeLastCellColumnMaxX:							CGFloat? = nil
	public var gridSizeLastCellRowMaxY:								CGFloat? = nil
	public var gridDraggingState:									GridDraggingState? = nil
	
	
	// MARK: - Public Computed Properties
	
	public var numberofColumns: Int {
		get {
			
			return (self.lastBlockColumnIndex + 1) - self.firstBlockColumnIndex
			
		}
	}

	public var numberofRows: Int {
		get {
			
			return (self.lastBlockRowIndex + 1) - self.firstBlockRowIndex
			
		}
	}
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func set(indicatedOffsetX: CGFloat,
					indicatedOffsetY: CGFloat,
					indicatedOffsetTransform: CGAffineTransform) {
		
		self.indicatedOffsetX 			= indicatedOffsetX
		self.indicatedOffsetY			= indicatedOffsetY
		self.indicatedOffsetTransform 	= indicatedOffsetTransform
		
	}
	
	public func set(selectedIndicatedPoint: CGPoint,
					selectedTruePoint: CGPoint,
					selectedCellCoord: CellCoord,
					selectedBlockCoord: BlockCoord) {
		
		self.selectedIndicatedPoint = selectedIndicatedPoint
		self.selectedTruePoint 		= selectedTruePoint
		self.selectedCellCoord 		= selectedCellCoord
		self.selectedBlockCoord 	= selectedBlockCoord

	}
	
	public func set(firstPopulatedCellColumnIndex: Int?, gridProperties: GridProperties) {
		
		self.firstPopulatedCellColumnIndex = firstPopulatedCellColumnIndex
		
		if (firstPopulatedCellColumnIndex != nil) {
			
			// Get true from cellCoord
			let t: CGPoint = GridScapeHelper.toTrue(fromCellCoord: CellCoord(column: firstPopulatedCellColumnIndex!, row: 0), gridProperties: gridProperties)
			
			self.firstPopulatedCellColumnMinX = t.x
			
		} else {
			
			self.firstPopulatedCellColumnMinX = nil
			
		}
		
	}
	
	public func set(firstPopulatedCellRowIndex: Int?, gridProperties: GridProperties) {
		
		self.firstPopulatedCellRowIndex = firstPopulatedCellRowIndex
		
		if (firstPopulatedCellRowIndex != nil) {
			
			// Get true from cellCoord
			let t: CGPoint = GridScapeHelper.toTrue(fromCellCoord: CellCoord(column: 0, row: firstPopulatedCellRowIndex!), gridProperties: gridProperties)
			
			self.firstPopulatedCellRowMinY = t.y
			
		} else {
			
			self.firstPopulatedCellRowMinY = nil
			
		}
		
	}
	
	public func set(lastPopulatedCellColumnIndex: Int?, gridProperties: GridProperties) {
		
		self.lastPopulatedCellColumnIndex = lastPopulatedCellColumnIndex
		
		if (lastPopulatedCellColumnIndex != nil) {
			
			// Get true from cellCoord
			let t: CGPoint = GridScapeHelper.toTrue(fromCellCoord: CellCoord(column: lastPopulatedCellColumnIndex!, row: 0), gridProperties: gridProperties)
			
			self.lastPopulatedCellColumnMaxX = t.x + gridProperties.cellWidth
			
		} else {
			
			self.lastPopulatedCellColumnMaxX = nil
			
		}
		
	}
	
	public func set(lastPopulatedCellRowIndex: Int?, gridProperties: GridProperties) {
		
		self.lastPopulatedCellRowIndex = lastPopulatedCellRowIndex
		
		if (lastPopulatedCellRowIndex != nil) {
			
			// Get true from cellCoord
			let t: CGPoint = GridScapeHelper.toTrue(fromCellCoord: CellCoord(column: 0, row: lastPopulatedCellRowIndex!), gridProperties: gridProperties)
			
			self.lastPopulatedCellRowMaxY = t.y + gridProperties.cellHeight
			
		} else {
			
			self.lastPopulatedCellRowMaxY = nil
			
		}
		
	}
	
	public func set(gridSizeFirstCellColumnIndex: Int?, gridProperties: GridProperties) {

		if (gridSizeFirstCellColumnIndex != nil) {
			
			// Get true from cellCoord
			let t: CGPoint = GridScapeHelper.toTrue(fromCellCoord: CellCoord(column: gridSizeFirstCellColumnIndex!, row: 0), gridProperties: gridProperties)
			
			self.gridSizeFirstCellColumnMinX 	= t.x
			
		} else {
			
			self.gridSizeFirstCellColumnMinX 	= nil
			
		}
		
	}

	public func set(gridSizeFirstCellRowIndex: Int?, gridProperties: GridProperties) {
		
		if (gridSizeFirstCellRowIndex != nil) {
			
			// Get true from cellCoord
			let t: CGPoint = GridScapeHelper.toTrue(fromCellCoord: CellCoord(column: 0, row: gridSizeFirstCellRowIndex!), gridProperties: gridProperties)
			
			self.gridSizeFirstCellRowMinY 	= t.y
			
		} else {
			
			self.gridSizeFirstCellRowMinY 	= nil
			
		}
		
	}
	
	public func set(gridSizeLastCellColumnIndex: Int?, gridProperties: GridProperties) {
		
		if (gridSizeLastCellColumnIndex != nil) {
			
			// Get true from cellCoord
			let t: CGPoint = GridScapeHelper.toTrue(fromCellCoord: CellCoord(column: gridSizeLastCellColumnIndex!, row: 0), gridProperties: gridProperties)
			
			self.gridSizeLastCellColumnMaxX 	= t.x + gridProperties.cellWidth
			
		} else {
			
			self.gridSizeLastCellColumnMaxX 	= nil
			
		}
		
	}
	
	public func set(gridSizeLastCellRowIndex: Int?, gridProperties: GridProperties) {
		
		if (gridSizeLastCellRowIndex != nil) {
			
			// Get true from cellCoord
			let t: CGPoint = GridScapeHelper.toTrue(fromCellCoord: CellCoord(column: 0, row: gridSizeLastCellRowIndex!), gridProperties: gridProperties)
			
			self.gridSizeLastCellRowMaxY 	= t.y + gridProperties.cellHeight
			
		} else {
			
			self.gridSizeLastCellRowMaxY 	= nil
			
		}
		
	}
	
}
