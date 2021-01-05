//
//  GridBuildProperties.swift
//  SFGridScape
//
//  Created by David on 24/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit
import SFView

/// A wrapper for a GridBuildProperties item
public class GridBuildProperties {
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var numberofColumns: 				Int = 0
	public fileprivate(set) var numberofRows: 					Int = 0
	public fileprivate(set) var topLeftBlockCoord:				BlockCoord? = nil
	public fileprivate(set) var topLeftMarginBlockCoord:		BlockCoord? = nil
	public fileprivate(set) var bottomRightBlockCoord:			BlockCoord? = nil
	public fileprivate(set) var bottomRightMarginBlockCoord:	BlockCoord? = nil
	public fileprivate(set) var cellCoordRange:					CellCoordRange? = nil
	public fileprivate(set) var gridSizeMinBlockColumnIndex:	Int? = nil
	public fileprivate(set) var gridSizeMinBlockRowIndex:		Int? = nil
	public fileprivate(set) var gridSizeMaxBlockColumnIndex:	Int? = nil
	public fileprivate(set) var gridSizeMaxBlockRowIndex:		Int? = nil
	public fileprivate(set) var gridSizeMinCellColumnIndex:		Int? = nil
	public fileprivate(set) var gridSizeMinCellRowIndex:		Int? = nil
	public fileprivate(set) var gridSizeMaxCellColumnIndex:		Int? = nil
	public fileprivate(set) var gridSizeMaxCellRowIndex:		Int? = nil
	
	
	// MARK: - Private Stored Properties

	
	// MARK: - Public Computed Properties
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods

	public func calculateBuildSize(gridProperties: GridProperties, gridState: GridState) {
	
		// How many columns to make? (ie. l-margin + display + r-margin)
		self.numberofColumns 	= gridProperties.marginLeftBlocks + gridProperties.displayWidthBlocks + gridProperties.marginRightBlocks
		
		// How many rows to make? (ie. t-margin + display + b-margin)
		self.numberofRows 		= gridProperties.marginTopBlocks + gridProperties.displayHeightBlocks + gridProperties.marginBottomBlocks
		
		// Calculate maximum grid size if required
		self.calculateMaxGridSize(gridProperties: gridProperties, gridState: gridState)
		
	}
	
	public func calculateBlockCoords(gridProperties: GridProperties, gridState: GridState) {
		
		let gp: 		GridProperties = gridProperties
		
		// What is the indicated position of the display
		let i:			CGPoint = CGPoint(x: 0, y: 0)
		
		// What is the true position??
		let t:			CGPoint = GridScapeHelper.toTrue(fromIndicated: i, gridState: gridState)
		
		// What is the topLeftDisplay blockCoord (ie. first displayed block)
		self.topLeftBlockCoord 						= GridScapeHelper.toBlockCoord(fromTrue: t, gridProperties: gp)
		
		// What is the topLeftMargin blockCoord (ie. first margin block)
		self.topLeftMarginBlockCoord 				= BlockCoord()
		self.topLeftMarginBlockCoord!.column 		= self.topLeftBlockCoord!.column - gp.marginLeftBlocks
		self.topLeftMarginBlockCoord!.row 			= self.topLeftBlockCoord!.row - gp.marginTopBlocks
		
		// What is the bottomRightDisplay blockCoord (ie. last displayed block)
		self.bottomRightBlockCoord 					= BlockCoord()
		self.bottomRightBlockCoord!.column 			= self.topLeftBlockCoord!.column + (self.numberofColumns - (gp.marginLeftBlocks + gp.marginRightBlocks + 1))
		self.bottomRightBlockCoord!.row 			= self.topLeftBlockCoord!.row + (self.numberofRows - (gp.marginTopBlocks + gp.marginBottomBlocks + 1))
		
		// What is the bottomRightMargin blockCoord (ie. last margin block)
		self.bottomRightMarginBlockCoord 			= BlockCoord()
		self.bottomRightMarginBlockCoord!.column 	= bottomRightBlockCoord!.column + gp.marginRightBlocks
		self.bottomRightMarginBlockCoord!.row 		= bottomRightBlockCoord!.row + gp.marginBottomBlocks
		
		// Check max grid size and adjust block coords if required
		self.checkMaxGridSizeBlockCoords(gridProperties: gp)
		
	}

	public func calculateCellCoordRange(gridProperties: GridProperties) -> CellCoordRange? {
		
		guard (self.topLeftMarginBlockCoord != nil
			&& self.bottomRightMarginBlockCoord != nil) else { return nil }
		
		let tlmbc: 	BlockCoord = self.topLeftMarginBlockCoord!
		let brmbc: 	BlockCoord = self.bottomRightMarginBlockCoord!
		
		let ccr: 	CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: tlmbc, gridProperties: gridProperties)
		
		ccr.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: brmbc, gridProperties: gridProperties))
		
		// Check cellCoordRange for grid size
		GridScapeHelper.checkGridSizeCellCoordRange(cellCoordRange: ccr, gridProperties: gridProperties)
		
		self.cellCoordRange = ccr
		
		return self.cellCoordRange
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func calculateMaxGridSize(gridProperties: GridProperties, gridState: GridState) {
		
		self.gridSizeMinBlockColumnIndex 	= nil
		self.gridSizeMinCellColumnIndex 	= nil
		self.gridSizeMaxBlockColumnIndex	= nil
		self.gridSizeMaxCellColumnIndex		= nil
		self.gridSizeMinBlockRowIndex 		= nil
		self.gridSizeMinCellRowIndex 		= nil
		self.gridSizeMaxBlockRowIndex		= nil
		self.gridSizeMaxCellRowIndex		= nil
		
		// Check grid size properties set
		guard ((gridProperties.gridWidthCells != nil && gridProperties.gridWidthCells! > 0)
			|| (gridProperties.gridHeightCells != nil && gridProperties.gridHeightCells! > 0)) else {
				
			return
		}
		
		let wc: 	Int = gridProperties.gridWidthCells ?? 0
		let hc: 	Int = gridProperties.gridHeightCells ?? 0
		
		// Get blockCoord for maximum cell coords
		let bc: 	BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: CellCoord(column: wc - 1, row: hc - 1), gridProperties: gridProperties)
		
		// Check if width set
		if (wc > 0) {
			
			self.gridSizeMinBlockColumnIndex 	= 0
			self.gridSizeMinCellColumnIndex 	= 0
			self.gridSizeMaxBlockColumnIndex	= bc.column
			self.gridSizeMaxCellColumnIndex		= wc - 1

		}
		
		// Check if height set
		if (hc > 0) {
			
			self.gridSizeMinBlockRowIndex 		= 0
			self.gridSizeMinCellRowIndex 		= 0
			self.gridSizeMaxBlockRowIndex		= bc.row
			self.gridSizeMaxCellRowIndex		= hc - 1

		}
		
		// Set in gridState
		gridState.set(gridSizeFirstCellColumnIndex: self.gridSizeMinCellColumnIndex, gridProperties: gridProperties)
		gridState.set(gridSizeLastCellColumnIndex: self.gridSizeMaxCellColumnIndex, gridProperties: gridProperties)
		gridState.set(gridSizeFirstCellRowIndex: self.gridSizeMinCellRowIndex, gridProperties: gridProperties)
		gridState.set(gridSizeLastCellRowIndex: self.gridSizeMaxCellRowIndex, gridProperties: gridProperties)
		
	}
	
	fileprivate func checkMaxGridSizeBlockCoords(gridProperties: GridProperties) {
		
		guard (self.gridSizeMinBlockColumnIndex != nil || self.gridSizeMinBlockRowIndex != nil) else { return }
		
		let tlbc: 	BlockCoord = self.topLeftBlockCoord!
		let tlmbc: 	BlockCoord = self.topLeftMarginBlockCoord!
		let brbc: 	BlockCoord = self.bottomRightBlockCoord!
		let brmbc: 	BlockCoord = self.bottomRightMarginBlockCoord!
		
		// Check if width set
		if (self.gridSizeMinBlockColumnIndex != nil && self.gridSizeMaxBlockColumnIndex != nil) {
			
			// Check topLeftBlockCoord outside grid size
			if (tlbc.column < self.gridSizeMinBlockColumnIndex!) {
				
				tlbc.column = self.gridSizeMinBlockColumnIndex!
				
			}
			
			// Check topLeftMarginBlockCoord outside grid size
			if (tlmbc.column < self.gridSizeMinBlockColumnIndex!) {
				
				tlmbc.column = self.gridSizeMinBlockColumnIndex!
				
			}

			// Check bottomRightBlockCoord outside grid size
			if (brbc.column > self.gridSizeMaxBlockColumnIndex!) {
				
				brbc.column = self.gridSizeMaxBlockColumnIndex!
				
			}
			
			// Check bottomRightMarginBlockCoord outside grid size
			if (brmbc.column > self.gridSizeMaxBlockColumnIndex!) {
				
				brmbc.column = self.gridSizeMaxBlockColumnIndex!
				
			}
			
		}

		// Check if height set
		if (self.gridSizeMinBlockRowIndex != nil && self.gridSizeMaxBlockRowIndex != nil) {
			
			// Check topLeftBlockCoord outside grid size
			if (tlbc.row < self.gridSizeMinBlockRowIndex!) {
				
				tlbc.row = self.gridSizeMinBlockRowIndex!
				
			}
			
			// Check topLeftMarginBlockCoord outside grid size
			if (tlmbc.row < self.gridSizeMinBlockRowIndex!) {
				
				tlmbc.row = self.gridSizeMinBlockRowIndex!
				
			}
			
			// Check bottomRightBlockCoord outside grid size
			if (brbc.row > self.gridSizeMaxBlockRowIndex!) {
				
				brbc.row = self.gridSizeMaxBlockRowIndex!
				
			}
			
			// Check bottomRightMarginBlockCoord outside grid size
			if (brmbc.row > self.gridSizeMaxBlockRowIndex!) {
				
				brmbc.row = self.gridSizeMaxBlockRowIndex!
				
			}
			
		}

	}
}

