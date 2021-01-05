//
//  GridScapeHelper.swift
//  SFGridScape
//
//  Created by David on 21/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit
import GLKit

/// A helper for handling GridScape
public final class GridScapeHelper {
	
	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Class Methods
	
	public class func calculateMarginFrame(gridProperties: GridProperties, gridState: GridState) {
		
		let t:				CGPoint = GridScapeHelper.toTrue(fromIndicated: CGPoint(x: 0, y: 0), gridState: gridState)
		
		// Get margin widths, heights
		let mlw: 			CGFloat = gridProperties.marginLeftWidth
		let mrw: 			CGFloat = gridProperties.marginRightWidth
		let mth: 			CGFloat = gridProperties.marginTopHeight
		let mbh: 			CGFloat = gridProperties.marginBottomHeight
		
		// Get marginFrame x, y
		let fx: 			CGFloat = t.x - gridProperties.marginLeftWidth
		let fy: 			CGFloat = t.y - gridProperties.marginTopHeight
		
		// Get marginFrame width, height
		let fw: 			CGFloat = mlw + gridProperties.displayWidth + mrw
		let fh: 			CGFloat = mth + gridProperties.displayHeight + mbh
		
		let marginFrame: 	CGRect = CGRect(x: fx, y: fy, width: fw, height: fh)
		
		gridState.marginFrame = marginFrame
		
	}
	
	public class func calculateBlockLayoutProperties(topLeftMarginBlockCoord: BlockCoord?,
													 bottomRightMarginBlockCoord: BlockCoord?,
													 gridProperties: GridProperties,
													 gridState: GridState) {
		
		if (topLeftMarginBlockCoord != nil) {
			
			// Get topLeftMargin blockCoord true
			let tlt: 				CGPoint = GridScapeHelper.toTrue(fromBlockCoord: topLeftMarginBlockCoord!, gridProperties: gridProperties)
			
			// firstBlockColumn
			gridState.firstBlockColumnIndex 	= topLeftMarginBlockCoord!.column
			gridState.firstBlockColumnTrueMinX 	= tlt.x
			gridState.firstBlockColumnTrueMaxX	= tlt.x + gridProperties.blockWidth
			
			// firstBlockRow
			gridState.firstBlockRowIndex 		= topLeftMarginBlockCoord!.row
			gridState.firstBlockRowTrueMinY		= tlt.y
			gridState.firstBlockRowTrueMaxY		= tlt.y + gridProperties.blockHeight
			
			// Get cellCoordRange
			let tlccr: 				CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: topLeftMarginBlockCoord!, gridProperties: gridProperties)
			
			// Check cellCoordRange with grid size
			self.checkGridSizeCellCoordRange(cellCoordRange: tlccr, gridProperties: gridProperties)
			
			// firstCellColumn
			gridState.firstCellColumnIndex 		= tlccr.topLeft.column
			
			// firstCellRow
			gridState.firstCellRowIndex 		= tlccr.topLeft.row
			
		}
		
		if (bottomRightMarginBlockCoord != nil) {
			
			// Get bottomRightMargin blockCoord true
			let brt: 				CGPoint = GridScapeHelper.toTrue(fromBlockCoord: bottomRightMarginBlockCoord!, gridProperties: gridProperties)
			
			// lastBlockColumn
			gridState.lastBlockColumnIndex 		= bottomRightMarginBlockCoord!.column
			gridState.lastBlockColumnTrueMinX 	= brt.x
			gridState.lastBlockColumnTrueMaxX	= brt.x + gridProperties.blockWidth
			
			// lastBlockRow
			gridState.lastBlockRowIndex			= bottomRightMarginBlockCoord!.row
			gridState.lastBlockRowTrueMinY		= brt.y
			gridState.lastBlockRowTrueMaxY		= brt.y + gridProperties.blockHeight
			
			// Get cellCoordRange
			let brccr: 				CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: bottomRightMarginBlockCoord!, gridProperties: gridProperties)
			
			// Check cellCoordRange with grid size
			self.checkGridSizeCellCoordRange(cellCoordRange: brccr, gridProperties: gridProperties)
			
			// lastCellColumn
			gridState.lastCellColumnIndex 		= brccr.bottomRight.column
			
			// lastCellRow
			gridState.lastCellRowIndex 			= brccr.bottomRight.row
			
		}
		
	}
	
	public class func checkGridLimits(gridProperties: GridProperties, gridState: GridState) {
		
		let mf: 		CGRect = gridState.marginFrame!
		
		var overMinX: 	CGFloat = 0
		var overMaxX: 	CGFloat = 0
		var overMinY: 	CGFloat = 0
		var overMaxY: 	CGFloat = 0
		
		if (gridProperties.gridLimitTrueMinX != nil) {
			
			// Calculate distance over gridLimitTrueMinX
			overMinX = (mf.minX + (gridProperties.marginLeftWidth)) - gridProperties.gridLimitTrueMinX!
			
		}
		
		if (gridProperties.gridLimitTrueMaxX != nil) {
			
			// Calculate distance over gridLimitTrueMaxX
			overMaxX = (mf.maxX - (gridProperties.marginRightWidth)) - gridProperties.gridLimitTrueMaxX!
			
		}
		
		if (gridProperties.gridLimitTrueMinY != nil) {
			
			// Calculate distance over gridLimitTrueMinY
			overMinY = (mf.minY + (gridProperties.marginTopHeight)) - gridProperties.gridLimitTrueMinY!
			
		}
		
		if (gridProperties.gridLimitTrueMaxY != nil) {
			
			// Calculate distance over gridLimitTrueMaxY
			overMaxY = (mf.maxY - (gridProperties.marginBottomHeight)) - gridProperties.gridLimitTrueMaxY!
			
		}
		
		var xCorrection: CGFloat = 0
		
		// Calculate x correction
		if (overMinX < 0 && abs(overMinX) > overMaxX) {
			
			xCorrection = abs(overMinX)		// Correct right
			
		} else if (overMaxX > 0 && (overMinX >= 0 || overMaxX > abs(overMinX))) {
			
			xCorrection = 0 - overMaxX		// Correct left
			
		}
		
		var yCorrection: CGFloat = 0
		
		// Calculate y correction
		if (overMinY < 0 && abs(overMinY) > overMaxY) {
			
			yCorrection = abs(overMinY)		// Correct down
			
		} else if (overMaxY > 0 && (overMinY >= 0 || overMaxY > abs(overMinY))) {
			
			yCorrection = 0 - overMaxY		// Correct up
			
		}
		
		if (xCorrection != 0 || yCorrection != 0) {
			
			let marginFrame: 	CGRect = CGRect(x: mf.minX + xCorrection,
												 y: mf.minY + yCorrection,
												 width: mf.width,
												 height: mf.height)
			
			// Correct marginFrame
			gridState.marginFrame = marginFrame
			
			// Correct indicatedOffset
			gridState.set(indicatedOffsetX: gridState.indicatedOffsetX - xCorrection,
						  indicatedOffsetY: gridState.indicatedOffsetY - yCorrection,
						  indicatedOffsetTransform: gridState.indicatedOffsetTransform.concatenating(CGAffineTransform(translationX: 0 - xCorrection, y: 0 - yCorrection)))
			
		}
		
	}
	
	public class func getLoadedCellCoordRange(gridProperties: GridProperties, gridState: GridState) -> CellCoordRange {
		
		let tlmbc: 		BlockCoord = BlockCoord()
		tlmbc.column 	= gridState.firstBlockColumnIndex
		tlmbc.row 		= gridState.firstBlockRowIndex
		
		let brmbc: 		BlockCoord = BlockCoord()
		brmbc.column 	= gridState.lastBlockColumnIndex
		brmbc.row 		= gridState.lastBlockRowIndex
		
		let result: 	CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: tlmbc, gridProperties: gridProperties)
		
		result.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: brmbc, gridProperties: gridProperties))
		
		return result
		
	}
	
	
	// MARK: - Class Methods; Grid Position Conversion
	
	public class func toIndicated(fromReferenceToType: GridPositionReferenceToTypes, fromIndicated point: CGPoint, gridProperties: GridProperties) -> CGPoint {

		// Get indicated x, y
		var ix: 		CGFloat = point.x
		var iy: 		CGFloat = point.y
		
		// Convert center to topLeft
		if (fromReferenceToType == .center) {
			
			let dw: 	CGFloat = gridProperties.displayWidth
			let dh: 	CGFloat = gridProperties.displayHeight

			ix = ix + (dw / 2)
			iy = iy + (dh / 2)
			
		}
		
		let result: CGPoint = CGPoint(x: ix, y: iy)
		
		return result
		
	}

	public class func toIndicated(toReferenceToType: GridPositionReferenceToTypes, fromIndicated point: CGPoint, gridProperties: GridProperties) -> CGPoint {
		
		// Get indicated x, y
		var ix: 		CGFloat = point.x
		var iy: 		CGFloat = point.y
		
		// Convert topLeft to center
		if (toReferenceToType == .center) {
			
			let dw: 	CGFloat = gridProperties.displayWidth
			let dh: 	CGFloat = gridProperties.displayHeight
			
			ix = ix - (dw / 2)
			iy = iy - (dh / 2)
			
		}
		
		let result: CGPoint = CGPoint(x: ix, y: iy)
		
		return result
		
	}

	
	// MARK: - Class Methods; Coordinate Conversion
	
	public class func toTrue(fromIndicated point: CGPoint, gridState: GridState) -> CGPoint {
		
		// Get true x, y
		let tx: 	CGFloat = point.x - gridState.indicatedOffsetX
		let ty: 	CGFloat = point.y - gridState.indicatedOffsetY
		
		let result: CGPoint = CGPoint(x: tx, y: ty)
		
		return result
		
	}
	
	public class func toIndicated(fromTrue point: CGPoint, gridState: GridState) -> CGPoint {
		
		// Get indicated x, y
		let ix: 	CGFloat = point.x + gridState.indicatedOffsetX
		let iy: 	CGFloat = point.y + gridState.indicatedOffsetY
		
		let result: CGPoint = CGPoint(x: ix, y: iy)
		
		return result
		
	}
	
	public class func toTrue(fromCellCoord cellCoord: CellCoord, gridProperties: GridProperties) -> CGPoint {
		
		let x: 		CGFloat = CGFloat(cellCoord.column) * gridProperties.cellWidth
		let y: 		CGFloat = CGFloat(cellCoord.row) * gridProperties.cellHeight
		
		let result: CGPoint = CGPoint(x: x, y: y)
		
		return result
		
	}
	
	public class func toTrue(fromCellCoord cellCoord: CellCoord, gridProperties: GridProperties, gridCellProperties: GridCellProperties, contentFrame: CGRect, contentPosition: CellContentPositionTypes, positionFixedToCellRotation: Bool) -> CGPoint {
		
		// Get true for cellCoord
		var result: 				CGPoint = GridScapeHelper.toTrue(fromCellCoord: cellCoord, gridProperties: gridProperties)
		
		// contentPositionPoint
		let contentPositionPoint: 	CGPoint = GridScapeHelper.toPoint(from: contentPosition, withRotation: gridCellProperties.rotationDegrees, positionFixedToCellRotation: positionFixedToCellRotation, cellWidth: gridCellProperties.cellWidth, cellHeight: gridCellProperties.cellHeight, contentWidth: contentFrame.width, contentHeight: contentFrame.width)

		// Adjust result by contentPositionPoint
		result.x += contentPositionPoint.x
		result.y += contentPositionPoint.y
		
		return result
		
	}
	
	public class func toTrue(fromBlockCoord blockCoord: BlockCoord, gridProperties: GridProperties) -> CGPoint {
		
		let w:		CGFloat = gridProperties.cellWidth * CGFloat(gridProperties.blockWidthCells)
		let h:		CGFloat = gridProperties.cellHeight * CGFloat(gridProperties.blockHeightCells)
		
		let x: 		CGFloat = CGFloat(blockCoord.column) * w
		let y: 		CGFloat = CGFloat(blockCoord.row) * h
		
		let result: CGPoint = CGPoint(x: x, y: y)
		
		return result
		
	}
	
	public class func toCellCoord(fromTrue point: CGPoint, gridProperties: GridProperties) -> CellCoord {
		
		let result: CellCoord = CellCoord()
		
		// Get column
		let xDiv: 		div_t = div(Int32(abs(point.x)), Int32(gridProperties.cellWidth))
		var c: 			Int = Int(xDiv.quot)
		if (point.x < 0) { c = -1 - c }
		
		// Get row
		let yDiv: 		div_t = div(Int32(abs(point.y)), Int32(gridProperties.cellHeight))
		var r: 			Int = Int(yDiv.quot)
		if (point.y < 0) { r = -1 - r }
		
		result.row 		= r
		result.column 	= c
		
		return result
		
	}
	
	public class func toBlockCoord(fromTrue point: CGPoint, gridProperties: GridProperties) -> BlockCoord {
		
		let result: 		BlockCoord = BlockCoord()
		
		let blockWidth: 	CGFloat = CGFloat(gridProperties.cellWidth) * CGFloat(gridProperties.blockWidthCells)
		let blockHeight: 	CGFloat = CGFloat(gridProperties.cellHeight) * CGFloat(gridProperties.blockHeightCells)
		
		// Get column
		let xDiv: 			div_t = div(Int32(abs(point.x)), Int32(blockWidth))
		var c: 				Int = Int(xDiv.quot)
		if (point.x < 0) { c = -1 - c }
		
		// Get row
		let yDiv: 			div_t = div(Int32(abs(point.y)), Int32(blockHeight))
		var r: 				Int = Int(yDiv.quot)
		if (point.y < 0) { r = -1 - r }
		
		result.row 			= r
		result.column 		= c
		
		return result
		
	}
	
	public class func toBlockCoord(fromCellCoord cellCoord: CellCoord, gridProperties: GridProperties) -> BlockCoord {
		
		let result: BlockCoord = BlockCoord()
		
		var cDiv: Int = abs(cellCoord.column)
		if (cellCoord.column < 0) { cDiv -= 1 }
		
		// Get column
		let xDiv: 		div_t = div(Int32(cDiv), Int32(gridProperties.blockWidthCells))
		var c: 			Int = Int(xDiv.quot)
		if (cellCoord.column < 0) { c = -1 - c }
		
		var rDiv: Int = abs(cellCoord.row)
		if (cellCoord.row < 0) { rDiv -= 1 }
		
		// Get row
		let yDiv: 		div_t = div(Int32(rDiv), Int32(gridProperties.blockHeightCells))
		var r: 			Int = Int(yDiv.quot)
		if (cellCoord.row < 0) { r = -1 - r }
		
		result.row 		= r
		result.column 	= c
		
		return result
		
	}
	
	public class func toCellCoordRange(fromBlockCoord blockCoord: BlockCoord, gridProperties: GridProperties) -> CellCoordRange {
		
		// Get topLeft column
		var c: 				Int = abs(blockCoord.column) * gridProperties.blockWidthCells
		if (blockCoord.column < 0) { c = 0 - c }
		
		// Get topLeft row
		var r: 				Int = abs(blockCoord.row) * gridProperties.blockHeightCells
		if (blockCoord.row < 0) { r = 0 - r }
		
		// Get topLeft
		let topLeft: 		CellCoord = CellCoord()
		topLeft.column 		= c
		topLeft.row 		= r
		
		// Get bottomRight
		let bottomRight: 	CellCoord = CellCoord()
		bottomRight.column 	= topLeft.column + (gridProperties.blockWidthCells - 1)
		bottomRight.row 	= topLeft.row + (gridProperties.blockHeightCells - 1)
		
		let result: 		CellCoordRange = CellCoordRange(topLeft: topLeft, bottomRight: bottomRight)
		
		return result
		
	}
	
	public class func toCellCoords(fromBlockCoord blockCoord: BlockCoord, gridProperties: GridProperties) -> [CellCoord] {
		
		var result: [CellCoord] = [CellCoord]()
		
		// Get CellCoordRange
		let range: CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: blockCoord, gridProperties: gridProperties)
		
		// Go through each column
		for c in range.topLeft.column...range.bottomRight.column {
		
			// Go through each row
			for r in range.topLeft.row...range.bottomRight.row {
				
				// Create cellCoord
				let cellCoord: 		CellCoord = CellCoord()
				cellCoord.column 	= c
				cellCoord.row 		= r
				
				result.append(cellCoord)
				
			}
			
		}
		
		return result
		
	}
	
	public class func toCellCoord(fromString value: String) -> CellCoord? {
		
		var result: 	CellCoord? = nil
		
		let parts 		= value.split(separator: ",")
		
		guard (parts.count == 2) else { return nil }
		
		// Get column
		let column: 	Int? = Int(parts[0])
		
		guard (column != nil) else { return nil }

		// Get row
		let row: 		Int? = Int(parts[1])
		
		guard (row != nil) else { return nil }
		
		result = CellCoord(column: column!, row: row!)
		
		return result
		
	}
	
	
	// MARK: - Class Methods; Cell Rotation
	
	public class func toIndicatedDegrees(from side: CellSideTypes) -> Int {
		
		switch side {
		case .top:
			return 0
		case .right:
			return 90
		case .bottom:
			return 180
		case .left:
			return 270
		}
		
	}
	
	public class func toTrueDegrees(from side: CellSideTypes, withRotation rotation: Int) -> Int {
		
		// Get indicatedDegrees
		var indicatedDegrees: 	Int = GridScapeHelper.toIndicatedDegrees(from: side)
		
		var r: 			Int = rotation
		
		if (rotation > 360 || rotation < 0) { r = GridScapeHelper.toValidRotation(rotation: rotation) }
		
		if (r > indicatedDegrees) { indicatedDegrees += 360 }
		
		let result: 	Int = indicatedDegrees - rotation
		
		return result
		
	}
	
	public class func toSide(from trueDegrees: Int, withRotation rotation: Int) -> CellSideTypes? {
		
		var r: 			Int = rotation
		
		if (rotation > 360 || rotation < 0) { r = GridScapeHelper.toValidRotation(rotation: rotation) }
		
		// Get indicatedDegrees
		var indicatedDegrees: 	Int = trueDegrees + r
		
		if (indicatedDegrees >= 360) {
			
			let iDiv: 		div_t = div(Int32(indicatedDegrees), Int32(360))
			indicatedDegrees = Int(iDiv.rem)
			
			
		}
		
		let result: CellSideTypes = GridScapeHelper.toSide(from: indicatedDegrees)
		
		return result
		
	}

	public class func toSide(from indicatedDegrees: Int) -> CellSideTypes {
		
		var result: CellSideTypes = .top
		
		switch indicatedDegrees {
		case 0:
			result = .top
		case 90:
			result = .right
		case 180:
			result = .bottom
		case 270:
			result = .left
		default:
			result = .top
		}
		
		return result
		
	}
	
	public class func toSide(from side: String) -> CellSideTypes? {
		
		var result: CellSideTypes? = nil
		
		switch side.lowercased() {
		case "left" :
			result = .left
			
		case "right" :
			result = .right
			
		case "top" :
			result = .top
			
		case "bottom" :
			result = .bottom
			
		default :
			result = nil
			
		}
		
		return result
	}
	
	public class func toValidRotation(rotation: Int) -> Int {
		
		var result: 	Int = rotation
		
		if (rotation > 360) {
			
			let rDiv: 	div_t = div(Int32(rotation), 360)
			result 		= Int(rDiv.quot)
			
		} else if (rotation < 0) {
			
			let rDiv: 	div_t = div(Int32(abs(rotation)), 360)
			result 		= 360 - Int(rDiv.quot)
			
		}
		
		return result
		
	}

	
	// MARK: - Class Methods; Cell Content Position
	
	public class func toPoint(from position: CellContentPositionTypes, withRotation rotation: Int, positionFixedToCellRotation: Bool, cellWidth: CGFloat, cellHeight: CGFloat, contentWidth: CGFloat, contentHeight: CGFloat) -> CGPoint {

		// Get indicatedPosition
		var indicatedPosition: CellContentPositionTypes = position
			
		if (positionFixedToCellRotation) {
			
			// Set indicatedPosition for rotation
			indicatedPosition = GridScapeHelper.toIndicatedPosition(from: position, withRotation: rotation)
			
		}
		
		let xl: Int = 0
		let xc: Int = Int((cellWidth / 2) - (contentWidth / 2))
		let xr: Int = Int(cellWidth - contentWidth)

		let yt: Int = 0
		let yc: Int = Int((cellHeight / 2) - (contentHeight / 2))
		let yb: Int = Int(cellHeight - contentHeight)
		
		var x: 	Int = 0
		var y: 	Int = 0

		switch indicatedPosition {
		case .Unspecified:
			x = xc
			y = yc
		case .Center:
			x = xc
			y = yc
		case .TopCenter:
			x = xc
			y = yt
		case .TopRight:
			x = xr
			y = yt
		case .RightCenter:
			x = xr
			y = yc
		case .BottomRight:
			x = xr
			y = yb
		case .BottomCenter:
			x = xc
			y = yb
		case .BottomLeft:
			x = xl
			y = yb
		case .LeftCenter:
			x = xl
			y = yc
		case .TopLeft:
			x = xl
			y = yt
		}
		
		return CGPoint(x: x, y: y)
		
	}
	
	
	// MARK: - Class Methods; Cells
	
	public class func isAlternate(cellCoord: CellCoord) -> Bool {
		
		var result: 	Bool = false
		
		let c: 			Int = cellCoord.column
		let r: 			Int = cellCoord.row
		
		// Check row is odd
		if (r % 2 != 0) {
			
			// Check row is even
			if (c % 2 == 0) {
				
				result = true
				
			}
			
		} else {
			
			// Check row is odd
			if (c % 2 != 0) {
				
				result = true
				
			}
			
		}
		
		return result
	}
	
	public class func calculatePopulatedCells(afterPresentCellViewsIn blockView: GridBlockView, gridProperties: GridProperties, gridState: GridState) {
		
		let bs: 	GridBlockState = blockView.blockState
		let gs: 	GridState = gridState
		
		// firstPopulatedCellColumnIndex
		if (gs.firstPopulatedCellColumnIndex == nil || bs.firstPopulatedCellColumnIndex! < gs.firstPopulatedCellColumnIndex!) {
			
			gs.set(firstPopulatedCellColumnIndex: bs.firstPopulatedCellColumnIndex, gridProperties: gridProperties)
	
		}
		
		// lastPopulatedCellColumnIndex
		if (gs.lastPopulatedCellColumnIndex == nil || bs.lastPopulatedCellColumnIndex! > gs.lastPopulatedCellColumnIndex!) {
			
			gs.set(lastPopulatedCellColumnIndex: bs.lastPopulatedCellColumnIndex, gridProperties: gridProperties)
		}
		
		// firstPopulatedCellRowIndex
		if (gs.firstPopulatedCellRowIndex == nil || bs.firstPopulatedCellRowIndex! < gs.firstPopulatedCellRowIndex!) {

			gs.set(firstPopulatedCellRowIndex: bs.firstPopulatedCellRowIndex, gridProperties: gridProperties)
		}
		
		// lastPopulatedCellRowIndex
		if (gs.lastPopulatedCellRowIndex == nil || bs.lastPopulatedCellRowIndex! > gs.lastPopulatedCellRowIndex!) {

			gs.set(lastPopulatedCellRowIndex: bs.lastPopulatedCellRowIndex, gridProperties: gridProperties)
		}
		
	}
	
	public class func calculatePopulatedCells(blockViews: [String: GridBlockView], gridProperties: GridProperties, gridState: GridState) {
		
		let gs: 			GridState = gridState
		
		var firstColumn: 	Int? = nil
		var lastColumn: 	Int? = nil
		var firstRow: 		Int? = nil
		var lastRow: 		Int? = nil
		
		// Go through each item
		for blockView in blockViews.values {
			
			let bs: GridBlockState = blockView.blockState
			
			if (bs.firstPopulatedCellColumnIndex != nil
				&& bs.lastPopulatedCellColumnIndex != nil
				&& bs.firstPopulatedCellRowIndex != nil
				&& bs.lastPopulatedCellRowIndex != nil) {
				
				if (firstColumn == nil || bs.firstPopulatedCellColumnIndex! < firstColumn!) { firstColumn = bs.firstPopulatedCellColumnIndex }
				if (lastColumn == nil || bs.lastPopulatedCellColumnIndex! > lastColumn!) { lastColumn = bs.lastPopulatedCellColumnIndex }
				if (firstRow == nil || bs.firstPopulatedCellRowIndex! < firstRow!) { firstRow = bs.firstPopulatedCellRowIndex }
				if (lastRow == nil || bs.lastPopulatedCellRowIndex! > lastRow!) { lastRow = bs.lastPopulatedCellRowIndex }
				
			}
			
		}
		
		gs.set(firstPopulatedCellColumnIndex: firstColumn, gridProperties: gridProperties)
		gs.set(firstPopulatedCellRowIndex: firstRow, gridProperties: gridProperties)
		gs.set(lastPopulatedCellColumnIndex: lastColumn, gridProperties: gridProperties)
		gs.set(lastPopulatedCellRowIndex: lastRow, gridProperties: gridProperties)
		
	}
	
	public class func checkGridSizeCellCoordRange(cellCoordRange: CellCoordRange, gridProperties: GridProperties) {
		
		guard (gridProperties.gridWidthCells != nil || gridProperties.gridHeightCells != nil) else { return }
		
		if (gridProperties.gridWidthCells != nil && gridProperties.gridWidthCells! > 0) {
			
			if (cellCoordRange.bottomRight.column > (gridProperties.gridWidthCells! - 1)
				&& cellCoordRange.topLeft.column <= (gridProperties.gridWidthCells! - 1)) {
				
				cellCoordRange.bottomRight.column = (gridProperties.gridWidthCells! - 1)
				
			}
			
		}

		if (gridProperties.gridHeightCells != nil && gridProperties.gridHeightCells! > 0) {
			
			if (cellCoordRange.bottomRight.row > (gridProperties.gridHeightCells! - 1)
				&& cellCoordRange.topLeft.row <= (gridProperties.gridHeightCells! - 1)) {
				
				cellCoordRange.bottomRight.row = (gridProperties.gridHeightCells! - 1)
				
			}
			
		}

		
	}
	
	public class func isValidCellCoord(cellCoord: CellCoord, gridProperties: GridProperties, buildProperties: GridBuildProperties) -> Bool {
		
		let result: Bool = true
		
		let gp: 	GridProperties = gridProperties
		let gbp: 	GridBuildProperties = buildProperties
		
		// Check gridSizeMinCellColumnIndex
		if (gbp.gridSizeMinCellColumnIndex != nil) {
			
			if (cellCoord.column < gbp.gridSizeMinCellColumnIndex!) { return false }
			
		}
		
		// Check gridSizeMaxCellColumnIndex
		if (gbp.gridSizeMaxCellColumnIndex != nil) {
			
			if (cellCoord.column > gbp.gridSizeMaxCellColumnIndex!) { return false }
			
		}
		
		// Check gridSizeMinCellRowIndex
		if (gbp.gridSizeMinCellRowIndex != nil) {
			
			if (cellCoord.row < gbp.gridSizeMinCellRowIndex!) { return false }
			
		}
		
		// Check gridSizeMaxCellRowIndex
		if (gbp.gridSizeMaxCellRowIndex != nil) {
			
			if (cellCoord.row > gbp.gridSizeMaxCellRowIndex!) { return false }
			
		}
		
		// Get true point of cellCoord
		let t: 		CGPoint = GridScapeHelper.toTrue(fromCellCoord: cellCoord, gridProperties: gp)
		
		// Check gridLimitTrueMinX
		if (gp.gridLimitTrueMinX != nil) {
			
			if (t.x < gp.gridLimitTrueMinX!) { return false }
			
		}
		
		// Check gridLimitTrueMaxX
		if (gp.gridLimitTrueMaxX != nil) {
			
			if (t.x > gp.gridLimitTrueMaxX!) { return false }
			
		}
		
		// Check gridLimitTrueMinY
		if (gp.gridLimitTrueMinY != nil) {
			
			if (t.y < gp.gridLimitTrueMinY!) { return false }
			
		}
		
		// Check gridLimitTrueMaxY
		if (gp.gridLimitTrueMaxY != nil) {
			
			if (t.y > gp.gridLimitTrueMaxY!) { return false }
			
		}
		
		return result
		
	}
	
	public class func isOffGridYN(cellCoord: CellCoord, gridState: GridState) -> Bool {
		
		let result: Bool = false
		
		if (cellCoord.column < gridState.firstCellColumnIndex ||
			cellCoord.column > gridState.lastCellColumnIndex) {
			
			return true
			
		}

		if (cellCoord.row < gridState.firstCellRowIndex ||
			cellCoord.row > gridState.lastCellRowIndex) {
			
			return true
			
		}
		
		return result
		
	}
	
	public class func isOffScreenYN(cellCoord: CellCoord, gridState: GridState, gridProperties: GridProperties) -> Bool {

		let result: Bool = false
		
		
		// cellCoordTrue
		let cellCoordTrue: 					CGPoint = GridScapeHelper.toTrue(fromCellCoord: cellCoord, gridProperties: gridProperties)
		
		// cellCoordIndicated
		let cellCoordIndicated: 			CGPoint = GridScapeHelper.toIndicated(fromTrue: cellCoordTrue, gridState: gridState)
		
		let cellMinXIndicated: 				CGFloat = cellCoordIndicated.x
		let cellMaxXIndicated: 				CGFloat = cellCoordIndicated.x + gridProperties.cellWidth
		let cellMinYIndicated: 				CGFloat = cellCoordIndicated.y
		let cellMaxYIndicated: 				CGFloat = cellCoordIndicated.y + gridProperties.cellHeight
		
		// displayTopLeftIndicated
		let displayTopLeftIndicated: 		CGPoint = CGPoint(x: 0, y: 0)
		
		// displayBottomRightIndicated
		let displayBottomRightIndicated: 	CGPoint = CGPoint(x: gridProperties.displayWidth, y: gridProperties.displayHeight)
		
		if (cellMinXIndicated < displayTopLeftIndicated.x ||
			cellMaxXIndicated > displayBottomRightIndicated.x) {
			
			return true
			
		}
		
		if (cellMinYIndicated < displayTopLeftIndicated.y ||
			cellMaxYIndicated > displayBottomRightIndicated.y) {
			
			return true
			
		}
		
		return result
		
	}
	
	
	// MARK: - Private Class Methods; Cell Content Position
	
	fileprivate class func toIndicatedPosition(from truePosition: CellContentPositionTypes, withRotation rotation: Int) -> CellContentPositionTypes {
		
		guard (truePosition != .Center && truePosition != .Unspecified) else { return truePosition }
		
		// Get numberOfRotations
		let numberOfRotations: 	Int = GridScapeHelper.toNumberOfRotations(rotation: rotation)
		
		guard (numberOfRotations > 0) else { return truePosition }

		var result: 			CellContentPositionTypes = truePosition
		
		// Go through each item
		for _ in 1...numberOfRotations {
			
			// Get next position
			result 				= GridScapeHelper.nextPositionAfterRotation(position: result)
			
		}
		
		return result
		
	}
	
	fileprivate class func toNumberOfRotations(rotation: Int) -> Int {
		
		var r: 			Int = rotation
		
		if (rotation > 360 || rotation < 0) { r = GridScapeHelper.toValidRotation(rotation: rotation) }
		
		// Determine number of rotations
		var result: 	Int = 0
		
		switch r {
		case 90:
			result = 1
		case 180:
			result = 2
		case 270:
			result = 3
		default:
			result = 0
		}
		
		return result
		
	}
	
	fileprivate class func nextPositionAfterRotation(position: CellContentPositionTypes) -> CellContentPositionTypes {
		
		var result: CellContentPositionTypes = position

		switch position {
		case .Unspecified:
			result = .Unspecified
		case .Center:
			result = .Center
		case .TopCenter:
			result = .RightCenter
		case .TopRight:
			result = .BottomRight
		case .RightCenter:
			result = .BottomCenter
		case .BottomRight:
			result = .BottomLeft
		case .BottomCenter:
			result = .LeftCenter
		case .BottomLeft:
			result = .TopLeft
		case .LeftCenter:
			result = .TopCenter
		case .TopLeft:
			result = .TopRight
		}
		
		return result
		
	}
	
}
