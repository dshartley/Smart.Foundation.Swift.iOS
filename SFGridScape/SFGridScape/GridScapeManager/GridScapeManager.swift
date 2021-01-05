//
//  GridScapeManager.swift
//  SFGridScape
//
//  Created by David on 20/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit
import SFView
import SFSerialization

//. Manages a grid scape
public class GridScapeManager {

	// MARK: - Private Stored Properties
	
	fileprivate var blockViews:						[String: GridBlockView] = [String: GridBlockView]()
	fileprivate var gridState:						GridState = GridState()
	fileprivate var buildProperties: 				GridBuildProperties? = nil
	fileprivate var cellAttributesIndex:			GridCellAttributesIndex = GridCellAttributesIndex()
	

	// MARK: - Public Stored Properties
	
	public weak var delegate: 						ProtocolGridScapeManagerDelegate?
	public fileprivate(set) var gridProperties:		GridProperties = GridProperties()
	public fileprivate(set) var gridScapeView: 		GridScapeView?
	
	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}
	
	public init(gridScapeView: GridScapeView) {
		
		self.gridScapeView = gridScapeView
		
		self.gridScapeView!.delegate = self
		
	}
	
	
	// MARK: - Public Computed Properties
	
	public var gridPosition: CGPoint {
		get {
			
			// Nb: As this is a public method, expects indicatedOffsetX and indicatedOffsetY referenced to current gridPositionReferenceToType
			
			let gp: 				GridProperties = self.gridProperties
			
			let fromIndicated: 		CGPoint = CGPoint(x: self.gridState.indicatedOffsetX, y: self.gridState.indicatedOffsetY)
			
			// Convert to indicatedPoint to gridPositionReferenceToType
			let result: 			CGPoint = GridScapeHelper.toIndicated(toReferenceToType: gp.gridPositionReferenceToType, fromIndicated: fromIndicated, gridProperties: gp)
			
			return result
			
		}
	}
	
	
	// MARK: - Public Methods
	
	public func clear() {
	
		guard (!self.gridState.isBuildingBlocksYN) else { return }
		
		self.set(isBuildingBlocksYN: true, notifyDelegate: true)
		
		// Get loaded cellCoordRange
		let cellCoordRange:		CellCoordRange = GridScapeHelper.getLoadedCellCoordRange(gridProperties: self.gridProperties, gridState: self.gridState)
		
		// Go through each item
		for blockView in self.blockViews.values {

			// hide blockView
			self.hideGridBlockView(blockView: blockView)
			
		}
		
		self.gridState 			= GridState()
		self.blockViews 		= [String: GridBlockView]()
		
		// Clear cellAttributesIndex
		self.cellAttributesIndex.clear()
		
		// Notify the delegate
		self.delegate?.gridScapeManager(unloadedCells: cellCoordRange)
		
		self.set(isBuildingBlocksYN: false, notifyDelegate: true)
		
	}
	
	public func build() {
		
		guard (!self.gridState.isBuildingBlocksYN) else { return }
		
		self.set(isBuildingBlocksYN: true, notifyDelegate: true)
		
		// Prepare build
		self.doPrepareBuild()
		
		if (self.blockViews.count > 0) {
			
			// Fill to fit with blocks
			self.fillToFitWithBlocks(buildProperties: self.buildProperties!, fillCells: false)
			
		} else {
			
			// Fill with blocks
			self.fillWithBlocks(buildProperties: self.buildProperties!, fillCells: false)
			
		}
		
		self.gridScapeView!.displayBlocksProperties(numberofBlocks: self.blockViews.count, gridState: self.gridState)

		self.set(isBuildingBlocksYN: false, notifyDelegate: true)
		
		// Notify the delegate
		self.delegate!.gridScapeManager(loadCells: self, cellCoordRange: self.buildProperties!.calculateCellCoordRange(gridProperties: self.gridProperties)!)
		
	}
	
	public func build(oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		guard (!self.gridState.isBuildingBlocksYN
			&& self.delegate != nil) else {
			
			// Call the completion handler
			completionHandler(NSError())
			
			return
			
		}
		
		self.set(isBuildingBlocksYN: true, notifyDelegate: true)
		
		// Prepare build
		self.doPrepareBuild()
		
		// Create completion handler
		let loadCellsCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			if (self.blockViews.count > 0) {
				
				// Fill to fit with blocks
				self.fillToFitWithBlocks(buildProperties: self.buildProperties!, fillCells: true)
				
			} else {
				
				// Fill with blocks
				self.fillWithBlocks(buildProperties: self.buildProperties!, fillCells: true)
				
			}
			
			self.gridScapeView!.displayBlocksProperties(numberofBlocks: self.blockViews.count, gridState: self.gridState)
			
			self.set(isBuildingBlocksYN: false, notifyDelegate: false)
			
			// Call the completion handler
			completionHandler(error)

		}
		
		// Notify the delegate
		self.delegate!.gridScapeManager(loadCells: self, cellCoordRange: self.buildProperties!.calculateCellCoordRange(gridProperties: self.gridProperties)!, oncomplete: loadCellsCompletionHandler)
		
	}
	
	public func setDisplaySize() {
		
		guard (self.gridScapeView != nil) else { return }
		
		//DispatchQueue.main.async {
			
			self.gridScapeView!.layoutIfNeeded()
			
			let v = self.gridScapeView! as UIView
			
			self.gridProperties.displayWidth	= v.frame.width
			self.gridProperties.displayHeight	= v.frame.height
		
		//}
		
	}
	
	public func set(gridPositionAt cellCoord: CellCoord, animateYN: Bool, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		guard (!self.gridState.isBuildingBlocksYN) else { return }
		
		self.setDisplaySize()
		
		let gp: 				GridProperties = self.gridProperties
		
		// Get true point for cellCoord
		let cct: 				CGPoint = GridScapeHelper.toTrue(fromCellCoord: cellCoord, gridProperties: gp)
		
		// Calculate indicatedOffset
		let indicatedOffsetX: 	CGFloat = ((gp.displayWidth / 2) - (gp.cellWidth / 2)) - cct.x
		let indicatedOffsetY: 	CGFloat = ((gp.displayHeight / 2) - (gp.cellHeight / 2)) - cct.y
		let fromIndicated: 		CGPoint = CGPoint(x: indicatedOffsetX, y: indicatedOffsetY)
		
		// Convert to indicatedPoint for current gridPositionReferenceToType. Nb: We need to do this as we are going back through a public method
		let indicatedPoint: 	CGPoint = GridScapeHelper.toIndicated(toReferenceToType: gp.gridPositionReferenceToType, fromIndicated: fromIndicated, gridProperties: gp)
		
		self.set(gridPositionAt: indicatedPoint.x,
				 indicatedOffsetY: indicatedPoint.y,
				 animateYN: animateYN,
				 oncomplete: completionHandler)
		
	}
	
	public func set(gridPositionAt cellCoord: CellCoord) {
		
		// Create completion handler
		let setGridPositionAtCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Not required
			
		}
		
		self.set(gridPositionAt: cellCoord, animateYN: false, oncomplete: setGridPositionAtCompletionHandler)
		
	}
	
	public func set(gridPositionAt indicatedOffsetX: CGFloat, indicatedOffsetY: CGFloat, animateYN: Bool, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Nb: As this is a public method, expects indicatedOffsetX and indicatedOffsetY referenced to current gridPositionReferenceToType
		
		guard (!self.gridState.isBuildingBlocksYN) else { return }
		
		self.setDisplaySize()
		
		let gp: 				GridProperties = self.gridProperties
		let fromIndicated: 		CGPoint = CGPoint(x: indicatedOffsetX, y: indicatedOffsetY)
		
		// Convert to indicatedPoint for gridPositionReferenceToType
		let indicatedPoint: 	CGPoint = GridScapeHelper.toIndicated(fromReferenceToType: gp.gridPositionReferenceToType, fromIndicated: fromIndicated, gridProperties: gp)
		
		if (self.blockViews.count > 0) {

			// Create completion handler
			let setGridPositionAtCompletionHandler: ((Error?) -> Void) =
			{
				(error) -> Void in

				// Rebuild
				self.rebuildAfterPanningStopped()
				
				// Nb: As this is a public delegate method, expects indicatedOffsetX and indicatedOffsetY referenced to current gridPositionReferenceToType
				// Notify the delegate
				self.delegate?.gridScapeManager(scrolled: self, indicatedOffsetX: indicatedOffsetX, indicatedOffsetY: indicatedOffsetX)
				
				// Call the completion handler
				completionHandler(nil)
				
			}

			// Set gridScape indicatedOffset
			self.doSetGridScapeIndicatedOffset(indicatedOffsetX: indicatedPoint.x,
											   indicatedOffsetY: indicatedPoint.y,
											   indicatedOffsetTransform: CGAffineTransform(translationX: indicatedPoint.x, y: indicatedPoint.y),
											   animateYN: animateYN,
											   oncomplete: setGridPositionAtCompletionHandler)
			
		} else {
			
			// Set gridState
			self.gridState.set(indicatedOffsetX: indicatedPoint.x,
							   indicatedOffsetY: indicatedPoint.y,
							   indicatedOffsetTransform: CGAffineTransform(translationX: indicatedPoint.x, y: indicatedPoint.y))
			
			// Call the completion handler
			completionHandler(nil)
			
		}
		
	}
	
	public func set(gridPositionAt indicatedOffsetX: CGFloat, indicatedOffsetY: CGFloat) {
		
		// Nb: As this is a public method, expects indicatedOffsetX and indicatedOffsetY referenced to current gridPositionReferenceToType
		
		guard (!self.gridState.isBuildingBlocksYN) else { return }
		
		self.setDisplaySize()
		
		let gp: 				GridProperties = self.gridProperties
		let fromIndicated: 		CGPoint = CGPoint(x: indicatedOffsetX, y: indicatedOffsetY)
		
		// Convert to indicatedPoint from gridPositionReferenceToType
		let indicatedPoint: 	CGPoint = GridScapeHelper.toIndicated(fromReferenceToType: gp.gridPositionReferenceToType, fromIndicated: fromIndicated, gridProperties: gp)
		
		if (self.blockViews.count > 0) {
			
			// Clear gridScape
			self.clear()
			
			// Set gridScape indicatedOffset
			self.doSetGridScapeIndicatedOffset(indicatedOffsetX: indicatedPoint.x,
											   indicatedOffsetY: indicatedPoint.y,
											   indicatedOffsetTransform: CGAffineTransform(translationX: indicatedPoint.x, y: indicatedPoint.y))
			
			// Build gridScape
			self.build()
			
		} else {
			
			// Set gridState
			self.gridState.set(indicatedOffsetX: indicatedPoint.x,
							   indicatedOffsetY: indicatedPoint.y,
							   indicatedOffsetTransform: CGAffineTransform(translationX: indicatedPoint.x, y: indicatedPoint.y))
			
		}
		
		// Nb: As this is a public delegate method, expects indicatedOffsetX and indicatedOffsetY referenced to current gridPositionReferenceToType
		// Notify the delegate
		self.delegate?.gridScapeManager(scrolled: self, indicatedOffsetX: indicatedOffsetX, indicatedOffsetY: indicatedOffsetY)
		
	}

	
	// MARK: - Public Methods; Grid
	
	public func set(blockCoordsVisible visibleYN: Bool) {
		
		// Set in gridProperties
		self.gridProperties.blockCoordsVisibleYN = visibleYN
		
		// Go through each item
		for blockView in self.blockViews.values {
			
			blockView.set(blockCoordsVisible: visibleYN)
			
		}
		
	}
	
	public func set(gridLinesVisible visibleYN: Bool) {
		
		// Set in gridProperties
		self.gridProperties.gridLinesVisibleYN = visibleYN
		
		// Go through each item
		for blockView in self.blockViews.values {
			
			blockView.set(gridLinesVisible: visibleYN)
			
		}
		
	}
	
	public func set(blockBackgroundColorOn onYN: Bool) {
		
		// Set in gridProperties
		self.gridProperties.blockBackgroundColorOnYN = onYN
		
		// Go through each item
		for blockView in self.blockViews.values {
			
			blockView.set(backgroundColorOn: onYN)
			
		}
		
	}
	
	public func set(alternatingCellBackgroundColorON onYN: Bool) {
		
		// Set in gridProperties
		self.gridProperties.alternatingCellBackgroundColorOnYN = onYN
		
		// Go through each item
		for blockView in self.blockViews.values {
			
			blockView.set(alternatingCellBackgroundColorON: onYN)
			
		}
		
	}
	
	public func set(verticalScroll onYN: Bool) {
		
		// Set in gridProperties
		self.gridProperties.verticalScrollYN = onYN
		
		self.gridScapeView!.setScrollDirection()
		
	}
	
	public func set(horizontalScroll onYN: Bool) {
		
		// Set in gridProperties
		self.gridProperties.horizontalScrollYN = onYN
		
		self.gridScapeView!.setScrollDirection()
		
	}

	public func set(scrollLimitToPopulatedCells onYN: Bool) {
		
		// Set in gridProperties
		self.gridProperties.scrollLimitToPopulatedCellsYN = onYN

	}
	
	
	// MARK: - Public Methods; Cells
	
	public func get(cellView cellCoord: CellCoord) -> ProtocolGridCellView? {
		
		var result: 		ProtocolGridCellView? = nil
		
		// Get blockCoord
		let blockCoord:		BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: cellCoord, gridProperties: self.gridProperties)
		
		// Get blockView
		let blockView: 		GridBlockView? = self.get(gridBlockView: blockCoord)
		
		guard (blockView != nil) else { return nil }
		
		// Get  cellView
		result = blockView!.get(cellView: cellCoord)
		
		return result
		
	}
	
	public func get(cellView id: String) -> ProtocolGridCellView? {
		
		var result: 		ProtocolGridCellView? = nil
		
		// Go through each blockView
		for bv in self.blockViews.values {
		
			result = bv.get(cellView: id)
			
			if (result != nil) { return result }
			
		}
		
		return result
		
	}
	
	public func get(cellViews groups: [CellGroupTypes], byRelationOf cellView: ProtocolGridCellView?, data: DataJSONWrapper?) -> [ProtocolGridCellView] {
	
		var result: [ProtocolGridCellView] = [ProtocolGridCellView]()
		
		// Go through each item
		for group in groups {
		
			switch group {
			case .LineUp:

				guard (cellView != nil) else { return result }
				
				result.append(contentsOf: self.getCellViewsLineUp(byRelationOf: cellView!))
				
			case .LineUpRight:

				guard (cellView != nil) else { return result }
				
				result.append(contentsOf: self.getCellViewsLineUpRight(byRelationOf: cellView!))
				
			case .LineRight:

				guard (cellView != nil) else { return result }
				
				result.append(contentsOf: self.getCellViewsLineRight(byRelationOf: cellView!))
				
			case .LineDownRight:

				guard (cellView != nil) else { return result }
				
				result.append(contentsOf: self.getCellViewsLineDownRight(byRelationOf: cellView!))
				
			case .LineDown:

				guard (cellView != nil) else { return result }
				
				result.append(contentsOf: self.getCellViewsLineDown(byRelationOf: cellView!))
			
			case .LineDownLeft:
				
				guard (cellView != nil) else { return result }
				
				result.append(contentsOf: self.getCellViewsLineDownLeft(byRelationOf: cellView!))
				
			case .LineLeft:
				
				guard (cellView != nil) else { return result }
				
				result.append(contentsOf: self.getCellViewsLineLeft(byRelationOf: cellView!))
				
			case .LineUpLeft:
				
				guard (cellView != nil) else { return result }
				
				result.append(contentsOf: self.getCellViewsLineUpLeft(byRelationOf: cellView!))
				
			case .Alternate:

				result.append(contentsOf: self.getCellViewsAlternate(alternateYN: true))
				
			case .NonAlternate:
				
				result.append(contentsOf: self.getCellViewsAlternate(alternateYN: false))
				
			case .DisplayEdge:
				
				result.append(contentsOf: self.getCellViewsDisplayEdge())
			
			case .Columns:
			
				let cs: 			String? = data?.getParameterValue(key: "Columns")
				
				let columnStrings 	= cs!.split(separator: ",")
				var columns: 		[Int] = [Int]()
				for c in columnStrings {
					columns.append(Int(c)!)
				}
				
				result.append(contentsOf: self.getCellViewsColumns(columns: columns))

			case .Rows:
		
				let rs: 			String? = data?.getParameterValue(key: "Rows")
				
				let rowStrings 		= rs!.split(separator: ",")
				var rows: 			[Int] = [Int]()
				for r in rowStrings {
					rows.append(Int(r)!)
				}
				
				result.append(contentsOf: self.getCellViewsRows(rows: rows))
		
			}
	
		}
		
		return result
		
	}
	
	public func get(cellViews attributeKey: String, withAttributeValue value: String) -> [ProtocolGridCellView] {

		var result: 		[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		// Get from index
		let indexResult: 	[String : Any?]? = self.cellAttributesIndex.find(key: attributeKey, value: value)
		
		guard (indexResult != nil) else { return result }
		
		// Go through each item
		for id in indexResult!.keys {
			
			// Get cellView
			let cv: ProtocolGridCellView? = self.get(cellView: id)
			
			if (cv != nil) {
				
				result.append(cv!)
				
			}
			
		}
		
		return result
		
	}

	public func get(cellViews side: CellSideTypes, attributeKey: String, withAttributeValue value: String) -> [ProtocolGridCellView] {
		
		var result: 		[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		// Get from index
		let indexResult: 	[String : Any?]? = self.cellAttributesIndex.find(key: attributeKey, side: side, value: value)
		
		guard (indexResult != nil) else { return result }
		
		// Go through each item
		for id in indexResult!.keys {
			
			// Get cellView
			let cv: ProtocolGridCellView? = self.get(cellView: id)
			
			if (cv != nil) {
				
				result.append(cv!)
				
			}
			
		}
		
		return result
		
	}
	
	public func present(cellView: ProtocolGridCellView, at cellCoord: CellCoord) {
		
		let cellView: ProtocolGridCellView = cellView
		
		cellView.set(delegate: self)
		
		// Set gridCellProperties
		self.setGridCellProperties(cellView: cellView, cellCoord: cellCoord)
		
		// get blockCoord
		let blockCoord: 	BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: cellCoord, gridProperties: self.gridProperties)
		
		// Get blockView
		let blockView: 		GridBlockView? = self.get(gridBlockView: blockCoord)
		
		guard (blockView != nil) else { return }
		
		// Present cellView
		blockView!.present(cellView: cellView)
		
		// Add to index in cellAttributesIndex
		self.cellAttributesIndex.index(attributes: cellView)
		
		// calculatePopulatedCells
		GridScapeHelper.calculatePopulatedCells(afterPresentCellViewsIn: blockView!, gridProperties: self.gridProperties, gridState: self.gridState)
		self.gridScapeView!.displayPopulatedCellsProperties(gridState: self.gridState)
		
	}

	public func canPresent(cellView: ProtocolGridCellView, at cellCoord: CellCoord) -> Bool {
		
		var result: Bool = true
		
		// Check isCompatible with neighbours
		if (!self.isCompatibleWithNeighbours(of: cellView, at: cellCoord)) { result = false }
		
		return result
		
	}
	
	public func hide(cellViewAt cellCoord: CellCoord) {
		
		// Get blockCoord
		let blockCoord: 	BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: cellCoord, gridProperties: self.gridProperties)
		
		// Get blockView
		let blockView: 		GridBlockView? = self.get(gridBlockView: blockCoord)
		
		guard (blockView != nil) else { return }
		
		// Get cellView
		let cellView: 		ProtocolGridCellView? = self.get(cellView: cellCoord)
	
		blockView!.hide(cellView: cellCoord)
		
		if (cellView != nil) {
			
			// Unindex cellView
			self.cellAttributesIndex.unindex(cellView: cellView!)
			
			cellView!.clearView()
			
		}
		
		// calculatePopulatedCells
		GridScapeHelper.calculatePopulatedCells(blockViews: self.blockViews, gridProperties: self.gridProperties, gridState: self.gridState)
		
	}
	
	public func isCompatibleWithNeighbours(of cellView: ProtocolGridCellView, at cellCoord: CellCoord) -> Bool {
		
		var result: 		Bool = true
		
		// Get neighbours
		let neighbours: 	[GridCellNeighbour] = self.get(neighbours: cellCoord)
		
		if (neighbours.count > 0) {
			
			// Go through each item
			for gcn in neighbours {
				
				// Check isCompatible
				if (!cellView.isCompatible(with: gcn, neighbours: neighbours)) { result = false }
				
			}
			
		} else {
			
			// Check isCompatible
			if (!cellView.isCompatible(with: neighbours)) { result = false }
			
		}
		
		return result
		
	}
	
	public func get(neighbours cellCoord: CellCoord) -> [GridCellNeighbour] {
		
		var result: 				[GridCellNeighbour] = [GridCellNeighbour]()
		
		// Get neighbourTop
		let neighbourTop: 			GridCellNeighbour? = self.get(neighbourTop: cellCoord)
		if (neighbourTop != nil) { result.append(neighbourTop!) }
		
		// Get neighbourTopRight
		let neighbourTopRight: 		GridCellNeighbour? = self.get(neighbourTopRight: cellCoord)
		if (neighbourTopRight != nil) { result.append(neighbourTopRight!) }
		
		// Get neighbourRight
		let neighbourRight: 		GridCellNeighbour? = self.get(neighbourRight: cellCoord)
		if (neighbourRight != nil) { result.append(neighbourRight!) }
		
		// Get neighbourBottomRight
		let neighbourBottomRight: 	GridCellNeighbour? = self.get(neighbourBottomRight: cellCoord)
		if (neighbourBottomRight != nil) { result.append(neighbourBottomRight!) }
		
		// Get neighbourBottom
		let neighbourBottom: 		GridCellNeighbour? = self.get(neighbourBottom: cellCoord)
		if (neighbourBottom != nil) { result.append(neighbourBottom!) }
		
		// Get neighbourBottomLeft
		let neighbourBottomLeft: 	GridCellNeighbour? = self.get(neighbourBottomLeft: cellCoord)
		if (neighbourBottomLeft != nil) { result.append(neighbourBottomLeft!) }
		
		// Get neighbourLeft
		let neighbourLeft: 			GridCellNeighbour? = self.get(neighbourLeft: cellCoord)
		if (neighbourLeft != nil) { result.append(neighbourLeft!) }
		
		// Get neighbourTopLeft
		let neighbourTopLeft: 		GridCellNeighbour? = self.get(neighbourTopLeft: cellCoord)
		if (neighbourTopLeft != nil) { result.append(neighbourTopLeft!) }
		
		return result
		
	}
	
	public func get(neighbourTop cellCoord: CellCoord) -> GridCellNeighbour? {
		
		var result: 	GridCellNeighbour? = nil
		
		// Create neighbour cellCoord
		let cc: 		CellCoord = CellCoord(column: cellCoord.column, row: cellCoord.row - 1)
		
		// Get neighbour cellView
		let cellView: 	ProtocolGridCellView? = self.get(cellView: cc)
		
		guard (cellView != nil) else { return nil }
		
		result = GridCellNeighbour(cellView: cellView!, position: .top)
		
		return result
		
	}
	
	public func get(neighbourTopRight cellCoord: CellCoord) -> GridCellNeighbour? {
		
		var result: 	GridCellNeighbour? = nil
		
		// Create neighbour cellCoord
		let cc: 		CellCoord = CellCoord(column: cellCoord.column + 1, row: cellCoord.row - 1)
		
		// Get neighbour cellView
		let cellView: 	ProtocolGridCellView? = self.get(cellView: cc)
		
		guard (cellView != nil) else { return nil }
		
		result = GridCellNeighbour(cellView: cellView!, position: .topRight)
		
		return result
		
	}
	
	public func get(neighbourRight cellCoord: CellCoord) -> GridCellNeighbour? {
		
		var result: 	GridCellNeighbour? = nil
		
		// Create neighbour cellCoord
		let cc: 		CellCoord = CellCoord(column: cellCoord.column + 1, row: cellCoord.row)
		
		// Get neighbour cellView
		let cellView: 	ProtocolGridCellView? = self.get(cellView: cc)
		
		guard (cellView != nil) else { return nil }
		
		result = GridCellNeighbour(cellView: cellView!, position: .right)
		
		return result
		
	}
	
	public func get(neighbourBottomRight cellCoord: CellCoord) -> GridCellNeighbour? {
		
		var result: 	GridCellNeighbour? = nil
		
		// Create neighbour cellCoord
		let cc: 		CellCoord = CellCoord(column: cellCoord.column + 1, row: cellCoord.row + 1)
		
		// Get neighbour cellView
		let cellView: 	ProtocolGridCellView? = self.get(cellView: cc)
		
		guard (cellView != nil) else { return nil }
		
		result = GridCellNeighbour(cellView: cellView!, position: .bottomRight)
		
		return result
		
	}
	
	public func get(neighbourBottom cellCoord: CellCoord) -> GridCellNeighbour? {
		
		var result: 	GridCellNeighbour? = nil
		
		// Create neighbour cellCoord
		let cc: 		CellCoord = CellCoord(column: cellCoord.column, row: cellCoord.row + 1)
		
		// Get neighbour cellView
		let cellView: 	ProtocolGridCellView? = self.get(cellView: cc)
		
		guard (cellView != nil) else { return nil }
		
		result = GridCellNeighbour(cellView: cellView!, position: .bottom)
		
		return result
		
	}
	
	public func get(neighbourBottomLeft cellCoord: CellCoord) -> GridCellNeighbour? {
		
		var result: 	GridCellNeighbour? = nil
		
		// Create neighbour cellCoord
		let cc: 		CellCoord = CellCoord(column: cellCoord.column - 1, row: cellCoord.row + 1)
		
		// Get neighbour cellView
		let cellView: 	ProtocolGridCellView? = self.get(cellView: cc)
		
		guard (cellView != nil) else { return nil }
		
		result = GridCellNeighbour(cellView: cellView!, position: .bottomLeft)
		
		return result
		
	}
	
	public func get(neighbourLeft cellCoord: CellCoord) -> GridCellNeighbour? {
		
		var result: 	GridCellNeighbour? = nil
		
		// Create neighbour cellCoord
		let cc: 		CellCoord = CellCoord(column: cellCoord.column - 1, row: cellCoord.row)
		
		// Get neighbour cellView
		let cellView: 	ProtocolGridCellView? = self.get(cellView: cc)
		
		guard (cellView != nil) else { return nil }
		
		result = GridCellNeighbour(cellView: cellView!, position: .left)
		
		return result
		
	}
	
	public func get(neighbourTopLeft cellCoord: CellCoord) -> GridCellNeighbour? {
		
		var result: 	GridCellNeighbour? = nil
		
		// Create neighbour cellCoord
		let cc: 		CellCoord = CellCoord(column: cellCoord.column - 1, row: cellCoord.row - 1)
		
		// Get neighbour cellView
		let cellView: 	ProtocolGridCellView? = self.get(cellView: cc)
		
		guard (cellView != nil) else { return nil }
		
		result = GridCellNeighbour(cellView: cellView!, position: .topLeft)
		
		return result
		
	}
	
	public func move(cell cellView: ProtocolGridCellView, to toCellCoord: CellCoord) {
		
		let movingView: UIView = cellView as! UIView
		
		movingView.alpha = 0
		
		let gcp: 				GridCellProperties = cellView.gridCellProperties!
		
		// Get fromCellCoord
		let fromCellCoord: 		CellCoord = gcp.cellCoord!
		
		// get fromBlockCoord
		let fromBlockCoord: 	BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: fromCellCoord, gridProperties: self.gridProperties)
		
		// Get fromBlockView
		let fromBlockView: 		GridBlockView? = self.get(gridBlockView: fromBlockCoord)
		
		guard (fromBlockView != nil) else { return }
		
		// TODO: If nil, it is offGrid
		// Check can move from
		
		// get toBlockCoord
		let toBlockCoord: 		BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: toCellCoord, gridProperties: self.gridProperties)
		
		// Get toBlockView
		let toBlockView: 		GridBlockView? = self.get(gridBlockView: toBlockCoord)
		
		guard (toBlockView != nil) else { return }
		
		// TODO: If nil, it is offGrid
		// Check can move to
		
		// Remove from fromBlockView
		fromBlockView!.hide(cellView: fromCellCoord)
		
		// Set cellCoord in cellView
		gcp.cellCoord 			= CellCoord(column: toCellCoord.column, row: toCellCoord.row)
		
		// Present cellView in toBlockView
		toBlockView!.present(cellView: cellView)
		
		movingView.alpha = 1
		
		// Go through each tileView
		for tileView in cellView.tileViews.values {
			
			// Set cellCoord in cellView
			tileView.gridTileProperties!.cellCoord = CellCoord(column: toCellCoord.column, row: toCellCoord.row)
		
		}
		
		// calculatePopulatedCells
		GridScapeHelper.calculatePopulatedCells(blockViews: self.blockViews, gridProperties: self.gridProperties, gridState: self.gridState)
		self.gridScapeView!.displayPopulatedCellsProperties(gridState: self.gridState)
		
		// Notify the delegate
		self.delegate!.gridScapeManager(cellMoved: cellView, from: fromCellCoord, to: toCellCoord)
		
	}
	
	public func move(cellFrom fromCellCoord: CellCoord, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		guard (!fromCellCoord.equals(cellCoord: toCellCoord)) else {
			
			// Call the completion handler
			completionHandler(NSError())
			return
			
		}
		
		let gp: 				GridProperties = self.gridProperties
		let gbp: 				GridBuildProperties = self.buildProperties!
		
		// Check valid cellCoords
		let isValidFromCellCoordYN: 	Bool = GridScapeHelper.isValidCellCoord(cellCoord: fromCellCoord, gridProperties: gp, buildProperties: gbp)
		let isValidToCellCoordYN: 		Bool = GridScapeHelper.isValidCellCoord(cellCoord: toCellCoord, gridProperties: gp, buildProperties: gbp)
		
		guard (isValidFromCellCoordYN && isValidToCellCoordYN) else {
			
			// Call the completion handler
			completionHandler(NSError())
			return
			
		}
		
		var fromCellView: 		ProtocolGridCellView? = nil
	
		// Create completion handler
		let getToCellViewCompletionHandler: ((ProtocolGridCellView?, Error?) -> Void) =
		{
			(cellView, error) -> Void in
			
			// Nb: We should never be able to load a toCellView. There should be no cellView where we want to move the cell to. If loaded then can't perform the move.
			
			guard (error == nil) else {
				
				// Call the completion handler
				completionHandler(error)
				return
				
			}
			
			guard (error == nil && cellView == nil) else {
				
				// Call the completion handler
				completionHandler(NSError())
				return
				
			}
		
			// Nb: We have loaded the fromCellView and checked there is no toCellView
			
			// Move cell
			self.move(cell: fromCellView!, to: toCellCoord, oncomplete: completionHandler)
			
		}
		
		// Create completion handler
		let getFromCellViewCompletionHandler: ((ProtocolGridCellView?, Error?) -> Void) =
		{
			(cellView, error) -> Void in
			
			// Nb: We should always be able to load a fromCellView. This is the cellView that is being moved. If not loaded then can't perform the move.
			
			guard (error == nil) else {
				
				// Call the completion handler
				completionHandler(error)
				return
				
			}
			
			guard (error == nil && cellView != nil) else {
				
				// Call the completion handler
				completionHandler(NSError())
				return
				
			}
			
			fromCellView = cellView
			
			// Get toCellView
			self.get(cellView: toCellCoord, oncomplete: getToCellViewCompletionHandler)
			
		}
		
		// Get fromCellView
		self.get(cellView: fromCellCoord, oncomplete: getFromCellViewCompletionHandler)
		
	}

	public func get(cellCoord indicatedPoint: CGPoint) -> CellCoord {
		
		// Get truePoint
		let truePoint: 		CGPoint = GridScapeHelper.toTrue(fromIndicated: indicatedPoint, gridState: self.gridState)
		
		// Get cellCoord
		let result:			CellCoord = GridScapeHelper.toCellCoord(fromTrue: truePoint, gridProperties: self.gridProperties)
		
		return result
		
	}
	
	public func get(indicatedPoint cellCoord: CellCoord) -> CGPoint {
		
		// Get true
		let truePoint: 	CGPoint = GridScapeHelper.toTrue(fromCellCoord: cellCoord, gridProperties: gridProperties)
		
		// Get indicated
		let result: 	CGPoint = GridScapeHelper.toIndicated(fromTrue: truePoint, gridState: gridState)

		return result
		
	}
	
	public func canDrop(cellView: ProtocolGridCellView, at cellCoord: CellCoord) -> Bool {

		// Get toCellView
		let toCellView: ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (toCellView == nil) else { return false }
		
		var result: Bool = true
		
		// Notify the delegate
		result = self.delegate?.gridScapeManager(canDrop: cellView, at: cellCoord) ?? true
		
		guard (result == true) else { return false }
		
		if (self.gridProperties.canDropCellViewCheckIsCompatibleWithNeighboursYN) {
			
			// Check isCompatibleWithNeighbours
			result = self.isCompatibleWithNeighbours(of: cellView, at: cellCoord)
			
		}
		
		guard (result == true) else { return false }
		
		return true
		
	}

	public func didDrop(cellView: ProtocolGridCellView, at indicatedPoint: CGPoint, oncomplete completionHandler:@escaping (ProtocolGridCellView?, Error?) -> Void) {
		
		let gs:						GridState = self.gridState
		let gp: 					GridProperties = self.gridProperties
		let gbp: 					GridBuildProperties = self.buildProperties!
		
		// Get truePoint
		let truePoint: 				CGPoint = GridScapeHelper.toTrue(fromIndicated: indicatedPoint, gridState: self.gridState)
		
		// Get toCellCoord
		let toCellCoord:			CellCoord = GridScapeHelper.toCellCoord(fromTrue: truePoint, gridProperties: gp)

		// Check cellCoord
		let isValidToCellCoordYN: 	Bool = GridScapeHelper.isValidCellCoord(cellCoord: toCellCoord, gridProperties: gp, buildProperties: gbp)
		
		let isOffGridYN: 			Bool = GridScapeHelper.isOffGridYN(cellCoord: toCellCoord, gridState: gs)
		
		guard (isValidToCellCoordYN && !isOffGridYN) else {
			
			// Call the completion handler
			completionHandler(nil, NSError())
			return
			
		}
		
		// Get toCellView
		let toCellView: 			ProtocolGridCellView? = self.get(cellView: toCellCoord)
		
		guard (toCellView == nil) else {
			
			// Call the completion handler
			completionHandler(nil, NSError())
			return
			
		}
		
		// Nb: We clone the cellView so that we don't have to worry about clearing layout constraints, transforms etc.
		// Clone the cellView
		let cv: 					ProtocolGridCellView = cellView.clone()
		cv.set(delegate: self)
		
		// Set gridCellProperties
		self.setGridCellProperties(cellView: cv, cellCoord: toCellCoord)
		
		// Create completion handler
		let moveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Call the completion handler
			completionHandler(cv, error)

		}
		
		// Nb: We have checked there is no toCellView
		
		// Clear cellView
		(cellView as! UIView).removeFromSuperview()
		(cellView as! UIView).alpha = 0
		cellView.clearView()
		
		// Move cell
		self.move(cell: cv, droppedAt: indicatedPoint, to: toCellCoord, oncomplete: moveCompletionHandler)
		
	}
	
	
	// MARK: - Public Methods; Tiles
	
	public func get(tileView key: String?, at cellCoord: CellCoord) -> ProtocolGridTileView? {
		
		var result: 		ProtocolGridTileView? = nil

		// Get cellView
		let cellView: 		ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (cellView != nil) else { return nil }
		
		result = cellView!.get(tileView: key)
		
		return result
		
	}
	
	public func present(tileView: ProtocolGridTileView, at cellCoord: CellCoord) {
		
		// Get cellView
		let cellView: 		ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (cellView != nil) else { return }
		
		var tileView: ProtocolGridTileView = tileView
		
		tileView.delegate 	= self
		
		// Present tileView
		cellView!.present(tileView: tileView)
		
	}
	
	public func canPresent(tileView: ProtocolGridTileView, at cellCoord: CellCoord) -> Bool {
	
		// TODO:
		
		return true
		
	}
	
	public func hide(tileView key: String?, at cellCoord: CellCoord) {
		
		// Get cellView
		let cellView: ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (cellView != nil) else { return }
		
		cellView!.hide(tileView: key)
		
	}

	public func isCompatibleWithNeighbours(of tileView: ProtocolGridTileView, at cellCoord: CellCoord) -> Bool {
		
		var result: 		Bool = true
		
		// Get neighbours
		let neighbours: 	[GridCellNeighbour] = self.get(neighbours: cellCoord)
		
		if (neighbours.count > 0) {
			
			// Go through each item
			for gcn in neighbours {
				
				// Check isCompatible
				if (!tileView.isCompatible(with: gcn, neighbours: neighbours)) { result = false }
				
			}
			
		} else {
			
			// Check isCompatible
			if (!tileView.isCompatible(with: neighbours)) { result = false }
			
		}
		
		return result
		
	}
	
	public func move(tile tileView: ProtocolGridTileView, to toCellCoord: CellCoord) {
		
		let movingView: UIView = tileView as! UIView
		
		movingView.alpha = 0
		
		let gtp: 				GridTileProperties = tileView.gridTileProperties!
		
		// Get fromCellCoord
		let fromCellCoord: 		CellCoord = gtp.cellCoord!
		
		// Get fromCellView
		let fromCellView: 		ProtocolGridCellView? = self.get(cellView: fromCellCoord)
		
		guard (fromCellView != nil) else { return }
		
		// TODO: If nil, it is offGrid
		// Check can move from
		
		// Get toCellView
		let toCellView: 		ProtocolGridCellView? = self.get(cellView: toCellCoord)
		
		guard (toCellView != nil) else { return }
		
		// TODO: If nil, it is offGrid
		// Check can move to
		
		// Remove from fromCellView
		fromCellView!.hide(tileView: tileView.gridTileProperties!.key)
		
		// Set cellCoord in tileView
		gtp.cellCoord 			= CellCoord(column: toCellCoord.column, row: toCellCoord.row)
		
		// Present tileView in toCellView
		toCellView!.present(tileView: tileView)
		
		movingView.alpha = 1
		
		// Notify the delegate
		self.delegate!.gridScapeManager(tileMoved: tileView, from: fromCellCoord, to: toCellCoord)
		
	}

	public func move(tileFrom fromCellCoord: CellCoord, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		guard (!fromCellCoord.equals(cellCoord: toCellCoord)) else {
			
			// Call the completion handler
			completionHandler(NSError())
			return
			
		}
		
		let gp: 				GridProperties = self.gridProperties
		let gbp: 				GridBuildProperties = self.buildProperties!
		
		// Check valid cellCoords
		let isValidFromCellCoordYN: 	Bool = GridScapeHelper.isValidCellCoord(cellCoord: fromCellCoord, gridProperties: gp, buildProperties: gbp)
		let isValidToCellCoordYN: 		Bool = GridScapeHelper.isValidCellCoord(cellCoord: toCellCoord, gridProperties: gp, buildProperties: gbp)
		
		guard (isValidFromCellCoordYN && isValidToCellCoordYN) else {
			
			// Call the completion handler
			completionHandler(NSError())
			return
			
		}
		
		var fromTileView: 		ProtocolGridTileView? = nil
		
		// Create completion handler
		let getToCellViewCompletionHandler: ((ProtocolGridCellView?, Error?) -> Void) =
		{
			(cellView, error) -> Void in
			
			// Nb: We should always be able to load a toCellView. The toCellView should not have a tileView. There should be no tileView where we want to move the tile to. If loaded then can't perform the move.
			
			guard (error == nil) else {
				
				// Call the completion handler
				completionHandler(error)
				return
				
			}
			
			guard (error == nil && cellView != nil && cellView!.tileViews.count == 0) else {
				
				// Call the completion handler
				completionHandler(NSError())
				return
				
			}
			
			// Nb: We have loaded the fromTileView and checked there is no toTileView
			
			// Move tile
			self.move(tile: fromTileView!, to: toCellCoord, oncomplete: completionHandler)
			
		}
		
		// Create completion handler
		let getFromCellViewCompletionHandler: ((ProtocolGridCellView?, Error?) -> Void) =
		{
			(cellView, error) -> Void in
			
			// Nb: We should always be able to load a fromCellView. The fromCellView should have a tileView. This is the tileView that is being moved. If not loaded then can't perform the move.
			
			guard (error == nil) else {
				
				// Call the completion handler
				completionHandler(error)
				return
				
			}
			
			guard (error == nil && cellView != nil && cellView!.tileViews.count > 0) else {
				
				// Call the completion handler
				completionHandler(NSError())
				return
				
			}
			
			fromTileView = cellView!.tileViews.values.first
			
			// Get toCellView
			self.get(cellView: toCellCoord, oncomplete: getToCellViewCompletionHandler)
			
		}
		
		// Get fromCellView
		self.get(cellView: fromCellCoord, oncomplete: getFromCellViewCompletionHandler)
		
	}
	
	public func canDrop(tileView: ProtocolGridTileView, at cellCoord: CellCoord) -> Bool {
		
		// Get toCellView
		let toCellView: 		ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		// Check toCellView and tileViews
		guard (toCellView != nil && toCellView!.tileViews.count == 0) else { return false }
		
		var canSetPositionYN: 	Bool = true

		// Check tileView position
		if (tileView.tileWrapper.position != .Unspecified) {
			
			// Check can set position
			canSetPositionYN 	= toCellView!.canSet(tileView: tileView, at: tileView.tileWrapper.position)
			
		} else {
			
			// Get position
			let position: 		CellContentPositionTypes? = toCellView!.get(positionFor: tileView)
			
			if (position == nil) { canSetPositionYN = false }
			
		}
		
		guard (canSetPositionYN) else { return false }
		
		var result: 			Bool = true
		
		// Notify the delegate
		result = self.delegate?.gridScapeManager(canDrop: tileView, at: cellCoord) ?? true
		
		guard (result == true) else { return false }
		
		if (self.gridProperties.canDropTileViewCheckIsCompatibleWithNeighboursYN) {
			
			// Check isCompatibleWithNeighbours
			result 				= self.isCompatibleWithNeighbours(of: tileView, at: cellCoord)
			
		}
		
		guard (result == true) else { return false }
		
		return true
		
	}
	
	public func didDrop(tileView: ProtocolGridTileView, at indicatedPoint: CGPoint, oncomplete completionHandler:@escaping (ProtocolGridTileView?, Error?) -> Void) {
		
		let gs:						GridState = self.gridState
		let gp: 					GridProperties = self.gridProperties
		let gbp: 					GridBuildProperties = self.buildProperties!

		// Get truePoint
		let truePoint: 				CGPoint = GridScapeHelper.toTrue(fromIndicated: indicatedPoint, gridState: self.gridState)

		// Get toCellCoord
		let toCellCoord:			CellCoord = GridScapeHelper.toCellCoord(fromTrue: truePoint, gridProperties: gp)

		// Check cellCoord
		let isValidToCellCoordYN: 	Bool = GridScapeHelper.isValidCellCoord(cellCoord: toCellCoord, gridProperties: gp, buildProperties: gbp)

		let isOffGridYN: 			Bool = GridScapeHelper.isOffGridYN(cellCoord: toCellCoord, gridState: gs)

		guard (isValidToCellCoordYN && !isOffGridYN) else {

			// Call the completion handler
			completionHandler(nil, NSError())
			return

		}

		// Get toCellView
		let toCellView: 			ProtocolGridCellView? = self.get(cellView: toCellCoord)

		guard (toCellView != nil && toCellView!.tileViews.count == 0) else {

			// Call the completion handler
			completionHandler(nil, NSError())
			return

		}

		// Nb: We clone the tileView so that we don't have to worry about clearing layout constraints, transforms etc.
		// Clone the tileView
		var tv: 											ProtocolGridTileView = tileView.clone()
		tv.delegate 										= self
		tv.gridTileProperties!.position						= tv.tileWrapper.position
		tv.gridTileProperties!.positionFixToCellRotationYN	= tv.tileWrapper.positionFixToCellRotationYN
		
		// Create completion handler
		let moveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in

			// Call the completion handler
			completionHandler(tv, error)

		}

		// Check tileWrapper position
		if (tv.tileWrapper.position == .Unspecified) {
			
			// Get position
			if let position = toCellView!.get(positionFor: tv) {
				
				tv.tileWrapper.position 			= position
				tv.gridTileProperties!.position 	= position
				
			}

		}
		
		// Nb: We have checked there is a valid toCellView

		// Clear tileView
		(tileView as! UIView).removeFromSuperview()
		(tileView as! UIView).alpha = 0
		tileView.clearView()

		// Move tile
		self.move(tile: tv, droppedAt: indicatedPoint, to: toCellCoord, oncomplete: moveCompletionHandler)
		
	}
	
	
	// MARK: - Public Methods; Tokens
	
	public func get(tokenView key: String?, at cellCoord: CellCoord) -> ProtocolGridTokenView? {
		
		var result: 		ProtocolGridTokenView? = nil
		
		// Get cellView
		let cellView: 		ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (cellView != nil) else { return nil }
		
		if (key != nil) {
			
			result = cellView!.get(tokenView: key)
			
		} else {
			
			result = cellView!.tokenViews.values.first
			
		}
		
		
		return result
		
	}
	
	public func present(tokenView: ProtocolGridTokenView, at cellCoord: CellCoord) {
		
		// Get cellView
		let cellView: 		ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (cellView != nil) else { return }
		
		var tokenView: ProtocolGridTokenView = tokenView
		
		tokenView.delegate 	= self
		
		// Present tokenView
		cellView!.present(tokenView: tokenView)
		
	}
	
	public func canPresent(tokenView: ProtocolGridTokenView, at cellCoord: CellCoord) -> Bool {
		
		// TODO:
		
		return true
		
	}
	
	public func hide(tokenView key: String?, at cellCoord: CellCoord) {
		
		// Get cellView
		let cellView: ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (cellView != nil) else { return }
		
		cellView!.hide(tokenView: key)
		
	}
	
	public func isCompatibleWithNeighbours(of tokenView: ProtocolGridTokenView, at cellCoord: CellCoord) -> Bool {
		
		var result: 		Bool = true
		
		// Get neighbours
		let neighbours: 	[GridCellNeighbour] = self.get(neighbours: cellCoord)
		
		if (neighbours.count > 0) {
			
			// Go through each item
			for gcn in neighbours {
				
				// Check isCompatible
				if (!tokenView.isCompatible(with: gcn, neighbours: neighbours)) { result = false }
				
			}
			
		} else {
			
			// Check isCompatible
			if (!tokenView.isCompatible(with: neighbours)) { result = false }
			
		}
		
		return result
		
	}
	
	public func move(token tokenView: ProtocolGridTokenView, to toCellCoord: CellCoord) {
		
		let movingView: UIView = tokenView as! UIView
		
		movingView.alpha = 0
		
		let gtp: 				GridTokenProperties = tokenView.gridTokenProperties!
		
		// Get fromCellCoord
		let fromCellCoord: 		CellCoord = gtp.cellCoord!
		
		// Get fromCellView
		let fromCellView: 		ProtocolGridCellView? = self.get(cellView: fromCellCoord)
		
		guard (fromCellView != nil) else { return }
		
		// TODO: If nil, it is offGrid
		// Check can move from
		
		// Get toCellView
		let toCellView: 		ProtocolGridCellView? = self.get(cellView: toCellCoord)
		
		guard (toCellView != nil) else { return }
		
		// TODO: If nil, it is offGrid
		// Check can move to
		
		// Remove from fromCellView
		fromCellView!.hide(tokenView: tokenView.gridTokenProperties!.key)
		
		// Set cellCoord in tokenView
		gtp.cellCoord 			= CellCoord(column: toCellCoord.column, row: toCellCoord.row)
		
		// Present tokenView in toCellView
		toCellView!.present(tokenView: tokenView)
		
		movingView.alpha = 1
		
		// Notify the delegate
		self.delegate!.gridScapeManager(tokenMoved: tokenView, from: fromCellCoord, to: toCellCoord)
		
	}
	
	public func move(tokenFrom fromCellCoord: CellCoord, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		guard (!fromCellCoord.equals(cellCoord: toCellCoord)) else {
			
			// Call the completion handler
			completionHandler(NSError())
			return
			
		}
		
		let gp: 				GridProperties = self.gridProperties
		let gbp: 				GridBuildProperties = self.buildProperties!
		
		// Check valid cellCoords
		let isValidFromCellCoordYN: 	Bool = GridScapeHelper.isValidCellCoord(cellCoord: fromCellCoord, gridProperties: gp, buildProperties: gbp)
		let isValidToCellCoordYN: 		Bool = GridScapeHelper.isValidCellCoord(cellCoord: toCellCoord, gridProperties: gp, buildProperties: gbp)
		
		guard (isValidFromCellCoordYN && isValidToCellCoordYN) else {
			
			// Call the completion handler
			completionHandler(NSError())
			return
			
		}
		
		var fromTokenView: 		ProtocolGridTokenView? = nil
		
		// Create completion handler
		let getToCellViewCompletionHandler: ((ProtocolGridCellView?, Error?) -> Void) =
		{
			(cellView, error) -> Void in
			
			// Nb: We should always be able to load a toCellView. The toCellView should not have a tokenView. There should be no tokenView where we want to move the token to. If loaded then can't perform the move.
			
			guard (error == nil) else {
				
				// Call the completion handler
				completionHandler(error)
				return
				
			}
			
			guard (error == nil && cellView != nil && cellView!.tokenViews.count == 0) else {
				
				// Call the completion handler
				completionHandler(NSError())
				return
				
			}
			
			// Nb: We have loaded the fromTokenView and checked there is no toTokenView
			
			// Move token
			self.move(token: fromTokenView!, to: toCellCoord, oncomplete: completionHandler)
			
		}
		
		// Create completion handler
		let getFromCellViewCompletionHandler: ((ProtocolGridCellView?, Error?) -> Void) =
		{
			(cellView, error) -> Void in
			
			// Nb: We should always be able to load a fromCellView. The fromCellView should have a tokenView. This is the tokenView that is being moved. If not loaded then can't perform the move.
			
			guard (error == nil) else {
				
				// Call the completion handler
				completionHandler(error)
				return
				
			}
			
			guard (error == nil && cellView != nil && cellView!.tokenViews.count > 0) else {
				
				// Call the completion handler
				completionHandler(NSError())
				return
				
			}
			
			fromTokenView = cellView!.tokenViews.values.first
			
			// Get toCellView
			self.get(cellView: toCellCoord, oncomplete: getToCellViewCompletionHandler)
			
		}
		
		// Get fromCellView
		self.get(cellView: fromCellCoord, oncomplete: getFromCellViewCompletionHandler)
		
	}
	
	public func move(tokenFrom fromCellCoord: CellCoord, alongPath pathWrapper: PathWrapperBase, oncomplete completionHandler:@escaping (PathWrapperBase, Error?) -> Void) {
		
		// lastPathPointWrapper
		let lastPathPointWrapper: 		PathPointWrapperBase? = pathWrapper.last

		guard (lastPathPointWrapper != nil && !fromCellCoord.equals(cellCoord: lastPathPointWrapper!.cellCoord)) else {
			
			// Call the completion handler
			completionHandler(pathWrapper, NSError())
			return
			
		}
		
		let gs:							GridState = self.gridState
		let gp: 						GridProperties = self.gridProperties
		let gbp: 						GridBuildProperties = self.buildProperties!
		
		// Check valid cellCoords
		let isValidFromCellCoordYN: 	Bool = GridScapeHelper.isValidCellCoord(cellCoord: fromCellCoord, gridProperties: gp, buildProperties: gbp)
		let isValidToCellCoordYN: 		Bool = GridScapeHelper.isValidCellCoord(cellCoord: lastPathPointWrapper!.cellCoord, gridProperties: gp, buildProperties: gbp)
		
		guard (isValidFromCellCoordYN && isValidToCellCoordYN) else {
			
			// Call the completion handler
			completionHandler(pathWrapper, NSError())
			return
			
		}

		// Set pathWrapper properties
		pathWrapper.status = .Started
		
		// Create completion handler
		let setGridPositionAtCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Move getTokenView
			self.move(tokenFrom: fromCellCoord, alongPath: pathWrapper, getTokenView: self, oncomplete: completionHandler)
			
		}
		
		// Get isFromOffScreenYN
		let isFromOffScreenYN: Bool = GridScapeHelper.isOffScreenYN(cellCoord: fromCellCoord, gridState: gs, gridProperties: gp)
		
		if (isFromOffScreenYN && gp.setGridPositionBeforeMoveTokenAlongPathYN) {
			
			// Set grid position
			self.set(gridPositionAt: fromCellCoord, animateYN: true, oncomplete: setGridPositionAtCompletionHandler)
			
		} else {
			
			// Move getTokenView
			self.move(tokenFrom: fromCellCoord, alongPath: pathWrapper, getTokenView: self, oncomplete: completionHandler)
			
		}
	
	}

	public func canDrop(tokenView: ProtocolGridTokenView, at cellCoord: CellCoord) -> Bool {
		
		// Get toCellView
		let toCellView: ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		// Check toCellView and TokenViews
		guard (toCellView != nil && toCellView!.tokenViews.count == 0) else { return false }
		
		var result: Bool = true
		
		// Notify the delegate
		result = self.delegate?.gridScapeManager(canDrop: tokenView, at: cellCoord) ?? true
		
		guard (result == true) else { return false }
		
		if (self.gridProperties.canDropTokenViewCheckIsCompatibleWithNeighboursYN) {
			
			// Check isCompatibleWithNeighbours
			result = self.isCompatibleWithNeighbours(of: tokenView, at: cellCoord)
			
		}
		
		guard (result == true) else { return false }
		
		return true
		
	}
	
	public func didDrop(tokenView: ProtocolGridTokenView, at indicatedPoint: CGPoint, oncomplete completionHandler:@escaping (ProtocolGridTokenView?, Error?) -> Void) {
		
		let gs:						GridState = self.gridState
		let gp: 					GridProperties = self.gridProperties
		let gbp: 					GridBuildProperties = self.buildProperties!
		
		// Get truePoint
		let truePoint: 				CGPoint = GridScapeHelper.toTrue(fromIndicated: indicatedPoint, gridState: self.gridState)
		
		// Get toCellCoord
		let toCellCoord:			CellCoord = GridScapeHelper.toCellCoord(fromTrue: truePoint, gridProperties: gp)
		
		// Check cellCoord
		let isValidToCellCoordYN: 	Bool = GridScapeHelper.isValidCellCoord(cellCoord: toCellCoord, gridProperties: gp, buildProperties: gbp)
		
		let isOffGridYN: 			Bool = GridScapeHelper.isOffGridYN(cellCoord: toCellCoord, gridState: gs)
		
		guard (isValidToCellCoordYN && !isOffGridYN) else {
			
			// Call the completion handler
			completionHandler(nil, NSError())
			return
			
		}
		
		// Get toCellView
		let toCellView: 			ProtocolGridCellView? = self.get(cellView: toCellCoord)
		
		guard (toCellView != nil && toCellView!.tokenViews.count == 0) else {
			
			// Call the completion handler
			completionHandler(nil, NSError())
			return
			
		}
		
		// Nb: We clone the TokenView so that we don't have to worry about clearing layout constraints, transforms etc.
		// Clone the TokenView
		var tv: 					ProtocolGridTokenView = tokenView.clone()
		tv.delegate 				= self
		
		// Create completion handler
		let moveCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Call the completion handler
			completionHandler(tv, error)
			
		}
		
		// Nb: We have checked there is a valid toCellView
		
		// Clear TokenView
		(tokenView as! UIView).removeFromSuperview()
		(tokenView as! UIView).alpha = 0
		tokenView.clearView()
		
		// Move Token
		self.move(token: tv, droppedAt: indicatedPoint, to: toCellCoord, oncomplete: moveCompletionHandler)
		
	}
	
	
	// MARK: - Private Methods

	fileprivate func set(isBuildingBlocksYN: Bool, notifyDelegate: Bool) {
		
		// Set flag isBuildingBlocksYN
		self.gridState.isBuildingBlocksYN = isBuildingBlocksYN
		
		if (!notifyDelegate) { return }
		
		if (isBuildingBlocksYN) {
			
			// Notify the delegate
			self.delegate?.gridScapeManager(isBuilding: self)
			
		} else {
			
			// Notify the delegate
			self.delegate?.gridScapeManager(isFinishedBuilding: self)
			
		}
		
	}
	
	fileprivate func doSetGridScapeIndicatedOffset(indicatedOffsetX: CGFloat,
												   indicatedOffsetY: CGFloat,
												   indicatedOffsetTransform: CGAffineTransform,
												   animateYN: Bool,
												   oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Nb: As this is a private method, expects indicatedOffsetX and indicatedOffsetY referenced to default topLeftCorner gridPositionReferenceToType
		
		// Set gridState
		self.gridState.set(indicatedOffsetX: indicatedOffsetX,
						   indicatedOffsetY: indicatedOffsetY,
						   indicatedOffsetTransform: indicatedOffsetTransform)
		
		// Calculate marginFrame
		GridScapeHelper.calculateMarginFrame(gridProperties: self.gridProperties, gridState: self.gridState)
		
		self.gridScapeView!.displayPanProperties(gridState: self.gridState)
		
		if (animateYN) {
			
			// Animate the transform
			UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
				
				// Apply transform to blockViews
				for v in self.blockViews.values {
					
					v.transform = self.gridState.indicatedOffsetTransform
					
				}
				
			}, completion: { _ in
				
				// Call the completion handler
				completionHandler(nil)
				
			})
			
		} else {
			
			// Apply transform to blockViews
			for v in self.blockViews.values {
				
				v.transform = self.gridState.indicatedOffsetTransform
				
			}
			
			// Call the completion handler
			completionHandler(nil)
			
		}
		
	}
	
	fileprivate func doSetGridScapeIndicatedOffset(indicatedOffsetX: CGFloat,
												   indicatedOffsetY: CGFloat,
												   indicatedOffsetTransform: CGAffineTransform) {
		
		// Nb: As this is a private method, expects indicatedOffsetX and indicatedOffsetY referenced to default topLeftCorner gridPositionReferenceToType
		
		// Set gridState
		self.gridState.set(indicatedOffsetX: indicatedOffsetX,
						   indicatedOffsetY: indicatedOffsetY,
						   indicatedOffsetTransform: indicatedOffsetTransform)
		
		// Calculate marginFrame
		GridScapeHelper.calculateMarginFrame(gridProperties: self.gridProperties, gridState: self.gridState)
		
		// Apply transform to blockViews
		for v in self.blockViews.values {
			
			v.transform = self.gridState.indicatedOffsetTransform
			
		}
		
		self.gridScapeView!.displayPanProperties(gridState: self.gridState)
		
	}
	
	fileprivate func doPrepareBuild() {
		
		self.setDisplaySize()
		
		// Calculate margin frame
		GridScapeHelper.calculateMarginFrame(gridProperties: self.gridProperties, gridState: self.gridState)
		
		// Is margin frame outside grid limits?
		GridScapeHelper.checkGridLimits(gridProperties: self.gridProperties, gridState: self.gridState)
		
		// Set gridProperties and gridState in gridScapeView
		self.gridScapeView!.set(gridProperties: self.gridProperties, gridState: self.gridState)
		
		// Create buildProperties
		self.buildProperties = GridBuildProperties()
		
		// Calculate build size
		self.buildProperties!.calculateBuildSize(gridProperties: self.gridProperties, gridState: self.gridState)
		
		// Calculate block coords
		self.buildProperties!.calculateBlockCoords(gridProperties: self.gridProperties, gridState: self.gridState)
		
		// Calculate block layout properties
		GridScapeHelper.calculateBlockLayoutProperties(topLeftMarginBlockCoord: self.buildProperties!.topLeftMarginBlockCoord!,
													   bottomRightMarginBlockCoord: self.buildProperties!.bottomRightMarginBlockCoord!,
													   gridProperties: self.gridProperties,
													   gridState: self.gridState)
		
		DispatchQueue.main.async {
		
			self.gridScapeView!.displayPanProperties(gridState: self.gridState)
			self.gridScapeView!.displayTapProperties(gridState: self.gridState)
			self.gridScapeView!.displaySelectedBlockProperties(blockView: nil)
			
		}
		
	}
	
	fileprivate func doAfterTapped(for gesture: UITapGestureRecognizer, tapped indicatedPoint: CGPoint, cellCoord: 			CellCoord?) {
		
		let truePoint: 			CGPoint = GridScapeHelper.toTrue(fromIndicated: indicatedPoint, gridState: self.gridState)
		
		var cellCoord: 			CellCoord? = cellCoord
		
		if (cellCoord == nil) {
			
			cellCoord 			= GridScapeHelper.toCellCoord(fromTrue: truePoint, gridProperties: self.gridProperties)
			
		}
		
		let blockCoord: 		BlockCoord = GridScapeHelper.toBlockCoord(fromTrue: truePoint, gridProperties: self.gridProperties)
		
		// Set selectedIndicatedPoint
		self.gridState.set(selectedIndicatedPoint: indicatedPoint, selectedTruePoint: truePoint, selectedCellCoord: cellCoord!, selectedBlockCoord: blockCoord)
		
		// Get tapped blockView
		let blockView: 			GridBlockView? = self.get(gridBlockView: blockCoord)
		
		DispatchQueue.main.async {
			
			self.gridScapeView!.displayTapProperties(gridState: self.gridState)
			self.gridScapeView!.displayBlocksProperties(numberofBlocks: self.blockViews.count, gridState: self.gridState)
			self.gridScapeView!.displaySelectedBlockProperties(blockView: blockView!)
			
		}
		
	}
	
	
	// MARK: - Private Methods; GridBlockView
	
	fileprivate func createGridBlockView(at blockCoord: BlockCoord, fillCells: Bool) -> GridBlockView {
		
		// Get truePoint
		let truePoint:	CGPoint = GridScapeHelper.toTrue(fromBlockCoord: blockCoord, gridProperties: self.gridProperties)
		
		let result: 	GridBlockView = GridBlockView(frame: CGRect(x: truePoint.x, y: truePoint.y, width: 0, height: 0))
		
		// Create gridBlockProperties
		let gbp: 		GridBlockProperties = GridBlockProperties(blockCoord: blockCoord)

		// Get cell coord range
		gbp.cellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: blockCoord, gridProperties: self.gridProperties)
		
		// Check cellCoordRange for grid size
		GridScapeHelper.checkGridSizeCellCoordRange(cellCoordRange: gbp.cellCoordRange!, gridProperties: self.gridProperties)
		
		result.set(gridBlockProperties: gbp, gridProperties: self.gridProperties)
		
		if (fillCells) {
			
			// Fill cells
			self.fillGridBlockViewCells(blockView: result)
			
		}
		
		// Set transform
		result.transform = self.gridState.indicatedOffsetTransform
		
		return result
		
	}
	
	fileprivate func presentGridBlockView(blockView: GridBlockView) {
		
		// Present view
		self.gridScapeView?.present(blockView: blockView)

		// Set in collection
		self.set(gridBlockView: blockView)
		
	}
	
	fileprivate func fillGridBlockViewCells(blockView: GridBlockView) {
		
		var cellViewPresentedYN: 	Bool = false
		
		// Get cellCoordRange
		let ccr: 					CellCoordRange = blockView.gridBlockProperties!.cellCoordRange!
		
		// Go through each item
		for cellCoord in ccr.toCellCoords() {
			
			// Get cellView
			var cellView: 			ProtocolGridCellView? = blockView.get(cellView: cellCoord)
			
			if (cellView == nil) {
				
				// Create cellView
				cellView = self.createGridCellView(at: cellCoord)
				
			}
				
			if (cellView != nil) {
				
				// Present cellView
				blockView.present(cellView: cellView!)
				
				cellViewPresentedYN = true
				
				// Add to index in cellAttributesIndex
				self.cellAttributesIndex.index(attributes: cellView!)
				
			}
			
		}

		if (cellViewPresentedYN) {
		
			// calculatePopulatedCells
			GridScapeHelper.calculatePopulatedCells(afterPresentCellViewsIn: blockView, gridProperties: self.gridProperties, gridState: self.gridState)
			self.gridScapeView!.displayPopulatedCellsProperties(gridState: self.gridState)
			
		}
		
	}
	
	fileprivate func hideGridBlockView(blockView: GridBlockView) {
		
		DispatchQueue.main.async {
			
			// Hide view
			blockView.removeFromSuperview()
			
			self.gridScapeView!.layoutIfNeeded()
			
		}

		// Go through each item
		for cellView in blockView.cellViews.values {
			
			// Unindex cellView
			self.cellAttributesIndex.unindex(cellView: cellView)

		}
		
		blockView.clearView()
		
		// Remove from collection
		self.remove(gridBlockView: blockView)
		
	}
	
	fileprivate func set(gridBlockView: GridBlockView) {
		
		// Get gridBlockProperties
		let p: 	GridBlockProperties? = gridBlockView.gridBlockProperties
		
		guard (p != nil) else { return }
		
		let k: 	String = "\(p!.blockCoord!.column),\(p!.blockCoord!.row)"
		
		self.blockViews[k] = gridBlockView
		
	}
	
	fileprivate func remove(gridBlockView: GridBlockView) {
		
		// Get GridBlockProperties
		let p: 	GridBlockProperties? = gridBlockView.gridBlockProperties
		
		guard (p != nil) else { return }
		
		let k: 	String = "\(p!.blockCoord!.column),\(p!.blockCoord!.row)"
		
		self.blockViews.removeValue(forKey: k)
		
	}
	
	fileprivate func get(gridBlockView blockCoord: BlockCoord) -> GridBlockView? {
		
		let k: 	String = "\(blockCoord.column),\(blockCoord.row)"
		
		return self.blockViews[k]
		
	}
	
	fileprivate func doPresentGridBlockView(columnIndex: Int, rowIndex: Int, fillCells: Bool) {
	
		let blockCoord: 		BlockCoord = BlockCoord()
		blockCoord.column 		= columnIndex
		blockCoord.row 			= rowIndex
		
		DispatchQueue.main.async {
			
			// Get blockView
			var blockView: 		GridBlockView? = self.get(gridBlockView: blockCoord)
			
			// Check if blockView exists
			if (blockView == nil) {
				
				// Create blockView
				blockView		= self.createGridBlockView(at: blockCoord, fillCells: fillCells)
				
				// Present blockView
				self.presentGridBlockView(blockView: blockView!)
				
			}
			
		}
		
	}
	
	
	// MARK: - Private Methods; GridCellView
	
	fileprivate func createGridCellView(at cellCoord: CellCoord) -> ProtocolGridCellView? {

		// Get gridCellView from delegate
		let result: 		ProtocolGridCellView? = self.delegate!.gridScapeManager(gridScapeView: self.gridScapeView!, cellViewForItemAt: cellCoord)
		
		guard (result != nil) else { return nil }
		
		result!.set(delegate: self)
		
		// Set gridCellProperties
		self.setGridCellProperties(cellView: result!, cellCoord: cellCoord)
		
		return result
		
	}
	
	fileprivate func setGridCellProperties(cellView: ProtocolGridCellView, cellCoord: CellCoord) {
		
		var cellView: 						ProtocolGridCellView = cellView
		
		// Set gridCellProperties
		if (cellView.gridCellProperties == nil) {
			
			cellView.gridCellProperties 	= GridCellProperties(cellCoord: cellCoord)
			
		}
		
		let gcp: 							GridCellProperties = cellView.gridCellProperties!
		
		// Set gridCellProperties
		gcp.cellHeight 						= self.gridProperties.cellHeight
		gcp.cellWidth 						= self.gridProperties.cellWidth
		
		if (gcp.borderColor == nil) {
			
			gcp.borderColor					= self.gridProperties.cellBorderColor
			
		}
		
		if (gcp.borderWidth == nil) {
			
			gcp.borderWidth					= self.gridProperties.cellBorderWidth
			
		}
		
		if (gcp.highlightBackgroundColor == nil) {
			
			gcp.highlightBackgroundColor	= self.gridProperties.cellHighlightBackgroundColor
			
		}
		
		if (gcp.highlightFilterColor == nil) {
			
			gcp.highlightFilterColor		= self.gridProperties.cellHighlightFilterColor
			
		}
		
		if (gcp.highlightBorderColor == nil) {
			
			gcp.highlightBorderColor		= self.gridProperties.cellHighlightBorderColor
			
		}

		if (gcp.highlightBorderWidth == nil) {
			
			gcp.highlightBorderWidth		= self.gridProperties.cellHighlightBorderWidth
			
		}
		
		cellView.gridCellProperties 		= gcp
		
	}

	fileprivate func getCellViewsLineUp(byRelationOf cellView: ProtocolGridCellView) -> [ProtocolGridCellView] {
		
		var result: 	[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 		GridState = self.gridState
		
		// Get cellCoord
		let cc: 		CellCoord = cellView.gridCellProperties!.cellCoord!
		
		let tcc: 		CellCoord = CellCoord(column: cc.column, row: cc.row)
		
		// Go through decreasing rows
		while (tcc.row > gs.firstCellRowIndex) {
			
			// Move to 0,-1
			tcc.row 	-= 1
			
			// Get cellView
			let tcv: ProtocolGridCellView? = self.get(cellView: tcc)
			
			if (tcv != nil) {
				
				// Add cellView
				result.append(tcv!)
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func getCellViewsLineUpRight(byRelationOf cellView: ProtocolGridCellView) -> [ProtocolGridCellView] {
		
		var result: 	[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 		GridState = self.gridState
		
		// Get cellCoord
		let cc: 		CellCoord = cellView.gridCellProperties!.cellCoord!

		let tcc: 		CellCoord = CellCoord(column: cc.column, row: cc.row)
		
		// Go through increasing columns and decreasing rows
		while (tcc.column < gs.lastCellColumnIndex && tcc.row > gs.firstCellRowIndex) {
			
			// Move to +1,-1
			tcc.column 	+= 1
			tcc.row 	-= 1
			
			// Get cellView
			let tcv: ProtocolGridCellView? = self.get(cellView: tcc)
			
			if (tcv != nil) {
				
				// Add cellView
				result.append(tcv!)
				
			}
			
		}
		
		return result
		
	}

	fileprivate func getCellViewsLineRight(byRelationOf cellView: ProtocolGridCellView) -> [ProtocolGridCellView] {
		
		var result: 	[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 		GridState = self.gridState
		
		// Get cellCoord
		let cc: 		CellCoord = cellView.gridCellProperties!.cellCoord!
		
		let tcc: 		CellCoord = CellCoord(column: cc.column, row: cc.row)
		
		// Go through increasing columns
		while (tcc.column < gs.lastCellColumnIndex) {
			
			// Move to +1,0
			tcc.column 	+= 1
			
			// Get cellView
			let tcv: ProtocolGridCellView? = self.get(cellView: tcc)
			
			if (tcv != nil) {
				
				// Add cellView
				result.append(tcv!)
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func getCellViewsLineDownRight(byRelationOf cellView: ProtocolGridCellView) -> [ProtocolGridCellView] {
		
		var result: 	[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 		GridState = self.gridState
		
		// Get cellCoord
		let cc: 		CellCoord = cellView.gridCellProperties!.cellCoord!
		
		let tcc: 		CellCoord = CellCoord(column: cc.column, row: cc.row)
		
		// Go through increasing columns and increasing rows
		while (tcc.column < gs.lastCellColumnIndex && tcc.row < gs.lastCellRowIndex) {
			
			// Move to +1,+1
			tcc.column 	+= 1
			tcc.row 	+= 1
			
			// Get cellView
			let tcv: ProtocolGridCellView? = self.get(cellView: tcc)
			
			if (tcv != nil) {
				
				// Add cellView
				result.append(tcv!)
				
			}
			
		}
		
		return result
		
	}

	fileprivate func getCellViewsLineDown(byRelationOf cellView: ProtocolGridCellView) -> [ProtocolGridCellView] {
		
		var result: 	[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 		GridState = self.gridState
		
		// Get cellCoord
		let cc: 		CellCoord = cellView.gridCellProperties!.cellCoord!
		
		let tcc: 		CellCoord = CellCoord(column: cc.column, row: cc.row)
		
		// Go through increasing rows
		while (tcc.row < gs.lastCellRowIndex) {
			
			// Move to 0,+1
			tcc.row 	+= 1
			
			// Get cellView
			let tcv: ProtocolGridCellView? = self.get(cellView: tcc)
			
			if (tcv != nil) {
				
				// Add cellView
				result.append(tcv!)
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func getCellViewsLineDownLeft(byRelationOf cellView: ProtocolGridCellView) -> [ProtocolGridCellView] {
		
		var result: 	[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 		GridState = self.gridState
		
		// Get cellCoord
		let cc: 		CellCoord = cellView.gridCellProperties!.cellCoord!
		
		let tcc: 		CellCoord = CellCoord(column: cc.column, row: cc.row)
		
		// Go through decreasing columns and increasing rows
		while (tcc.column > gs.firstCellColumnIndex && tcc.row < gs.lastCellRowIndex) {
			
			// Move to -1,+1
			tcc.column 	-= 1
			tcc.row 	+= 1
			
			// Get cellView
			let tcv: ProtocolGridCellView? = self.get(cellView: tcc)
			
			if (tcv != nil) {
				
				// Add cellView
				result.append(tcv!)
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func getCellViewsLineLeft(byRelationOf cellView: ProtocolGridCellView) -> [ProtocolGridCellView] {
		
		var result: 	[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 		GridState = self.gridState
		
		// Get cellCoord
		let cc: 		CellCoord = cellView.gridCellProperties!.cellCoord!
		
		let tcc: 		CellCoord = CellCoord(column: cc.column, row: cc.row)
		
		// Go through decreasing columns
		while (tcc.column > gs.firstCellColumnIndex) {
			
			// Move to -1,0
			tcc.column 	-= 1
			
			// Get cellView
			let tcv: ProtocolGridCellView? = self.get(cellView: tcc)
			
			if (tcv != nil) {
				
				// Add cellView
				result.append(tcv!)
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func getCellViewsLineUpLeft(byRelationOf cellView: ProtocolGridCellView) -> [ProtocolGridCellView] {
		
		var result: 	[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 		GridState = self.gridState
		
		// Get cellCoord
		let cc: 		CellCoord = cellView.gridCellProperties!.cellCoord!
		
		let tcc: 		CellCoord = CellCoord(column: cc.column, row: cc.row)
		
		// Go through decreasing columns and decreasing rows
		while (tcc.column > gs.firstCellColumnIndex && tcc.row > gs.firstCellRowIndex) {
			
			// Move to -1,-1
			tcc.column 	-= 1
			tcc.row 	-= 1
			
			// Get cellView
			let tcv: ProtocolGridCellView? = self.get(cellView: tcc)
			
			if (tcv != nil) {
				
				// Add cellView
				result.append(tcv!)
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func getCellViewsDisplayEdge() -> [ProtocolGridCellView] {
		
		var result: 		[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 			GridState = self.gridState
		
		// Get topLeft blockCoord and blockCoordRange
		let tlmbc: 			BlockCoord = BlockCoord(column: gs.firstBlockColumnIndex, row: gs.firstBlockRowIndex)
		let tlmccr: 		CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: tlmbc, gridProperties: self.gridProperties)
		
		let brmbc: 			BlockCoord = BlockCoord(column: gs.lastBlockColumnIndex, row: gs.lastBlockRowIndex)
		let brmccr: 		CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: brmbc, gridProperties: self.gridProperties)
		
		// Get blockViews
		var blockViews: 	[GridBlockView] = [GridBlockView]()

		// Top and Bottom edges; go through each column
		for c in tlmbc.column...brmbc.column {
			
			let tbv: GridBlockView? = self.get(gridBlockView: BlockCoord(column: c, row: tlmbc.row))
			let bbv: GridBlockView? = self.get(gridBlockView: BlockCoord(column: c, row: brmbc.row))

			if (tbv != nil) { blockViews.append(tbv!) }
			if (bbv != nil) { blockViews.append(bbv!) }
			
		}
		
		// Left and Right edges; go through each row (except first and last)
		for r in (tlmbc.row + 1)...(brmbc.row - 1) {
			
			let lbv: GridBlockView? = self.get(gridBlockView: BlockCoord(column: tlmbc.column, row: r))
			let rbv: GridBlockView? = self.get(gridBlockView: BlockCoord(column: brmbc.column, row: r))
			
			if (lbv != nil) { blockViews.append(lbv!) }
			if (rbv != nil) { blockViews.append(rbv!) }
			
		}


		// Go through each block
		for blockView in blockViews {
			
			// Get blockCoord
			let bc: 	BlockCoord = blockView.gridBlockProperties!.blockCoord!
			
			// Go through each cellView
			for cv in blockView.cellViews.values {

				// Get cellCoord
				let cc: 		CellCoord = cv.gridCellProperties!.cellCoord!
				
				// Determine which edge the cell is on
				let isLeft: 	Bool = (cc.column == tlmccr.topLeft.column)
				let isRight: 	Bool = (cc.column == brmccr.bottomRight.column)
				let isTop: 		Bool = (cc.row == tlmccr.topLeft.row)
				let isBottom: 	Bool = (cc.row == brmccr.bottomRight.row)
				
				// Left and Right edges; check blockCoord
				if (bc.column == tlmbc.column && isLeft) {			// Left edge
					
					result.append(cv)
					
				} else if (bc.column == brmbc.column && isRight) {	// Right edge
				
					result.append(cv)
					
				}
				
				// Top and Bottom edges; check blockCoord
				if (bc.row == tlmbc.row && isTop
					&& !isLeft && !isRight) {						// Top edge
					
					result.append(cv)
					
				} else if (bc.row == brmbc.row && isBottom
					&& !isLeft && !isRight) {						// Bottom edge
					
					result.append(cv)
					
				}
				
			}
			
		}

		return result
		
	}

	fileprivate func getCellViewsAlternate(alternateYN: Bool) -> [ProtocolGridCellView] {
		
		var result: 	[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		// Go through each item
		for bv in self.blockViews.values {
			
			// Go through each item
			for cv in bv.cellViews.values {
				
				// Get cellCoord
				let cc: CellCoord = cv.gridCellProperties!.cellCoord!
				
				if (GridScapeHelper.isAlternate(cellCoord: cc) == alternateYN) {
					
					// Add cellView
					result.append(cv)
				}
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func getCellViewsColumns(columns: [Int]) -> [ProtocolGridCellView] {
		
		var result: 			[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 				GridState = self.gridState
		
		// Go through each column
		for c in columns {
			
			// Get cellCoord
			let cc:				CellCoord = CellCoord(column: c, row: gs.firstCellRowIndex)
			
			// Get blockCoord
			let bc: 			BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: cc, gridProperties: self.gridProperties)
			
			// Get blockViews
			var blockViews: 	[GridBlockView] = [GridBlockView]()
			
			// Go through each row
			for r in gs.firstBlockRowIndex...gs.lastBlockRowIndex {
				
				let bv: 		GridBlockView? = self.get(gridBlockView: BlockCoord(column: bc.column, row: r))
				
				if (bv != nil) { blockViews.append(bv!) }
				
			}
			
			// Go through each blockView
			for blockView in blockViews {
				
				// Go through each cellView
				for cv in blockView.cellViews.values {
					
					// Get cellCoord
					let cc: 	CellCoord = cv.gridCellProperties!.cellCoord!
					
					if (cc.column == c) {
						
						result.append(cv)
						
					}
					
				}
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func getCellViewsRows(rows: [Int]) -> [ProtocolGridCellView] {
		
		var result: 			[ProtocolGridCellView] = [ProtocolGridCellView]()
		
		let gs: 				GridState = self.gridState
		
		// Go through each row
		for r in rows {
			
			// Get cellCoord
			let cc:				CellCoord = CellCoord(column: gs.firstCellColumnIndex, row: r)
			
			// Get blockCoord
			let bc: 			BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: cc, gridProperties: self.gridProperties)
			
			// Get blockViews
			var blockViews: 	[GridBlockView] = [GridBlockView]()
			
			// Go through each column
			for c in gs.firstBlockColumnIndex...gs.lastBlockColumnIndex {
				
				let bv: 		GridBlockView? = self.get(gridBlockView: BlockCoord(column: c, row: bc.row))
				
				if (bv != nil) { blockViews.append(bv!) }
				
			}
			
			// Go through each blockView
			for blockView in blockViews {
				
				// Go through each cellView
				for cv in blockView.cellViews.values {
					
					// Get cellCoord
					let cc: 	CellCoord = cv.gridCellProperties!.cellCoord!
					
					if (cc.row == r) {
						
						result.append(cv)
						
					}
					
				}
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func get(cellView cellCoord: CellCoord, oncomplete completionHandler:@escaping (ProtocolGridCellView?, Error?) -> Void) {
		
		let gs: 			GridState = self.gridState
		
		var cellView:		ProtocolGridCellView? = nil
		
		// Create completion handler
		let loadCellCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			if (error == nil) {
				
				// Get cellView
				cellView = self.createGridCellView(at: cellCoord)
				
				// Call present to setup the cellView display
				cellView?.present()
				
			}
			
			// Call the completion handler
			completionHandler(cellView, nil)
			
		}
		
		// Get cellView
		cellView 			= self.get(cellView: cellCoord)
		
		if (cellView == nil && GridScapeHelper.isOffGridYN(cellCoord: cellCoord, gridState: gs)) {
			
			// Nb: cellView was not retrieved. It does not exist on the grid. Try to load the cell data then get the cellView from the delegate.
			
			let ccr: 			CellCoordRange = CellCoordRange(topLeft: cellCoord, bottomRight: cellCoord)
			
			// Load cell
			self.delegate!.gridScapeManager(loadCells: self, cellCoordRange: ccr, oncomplete: loadCellCompletionHandler)
			
		} else {
			
			// Nb: cellView was retrieved. It exists on the grid.
			
			// Call the completion handler
			completionHandler(cellView, nil)
			
		}
		
	}
	
	fileprivate func moveCellDoBeforeReposition(cellView: ProtocolGridCellView, fromCellCoord: CellCoord, fromBlockView: GridBlockView?, toCellCoord: CellCoord) {
		
		(cellView as! UIView).alpha = 0
		
		let gcp: 		GridCellProperties = cellView.gridCellProperties!
		
		if (fromBlockView != nil) {
			
			// Remove from fromBlockView
			fromBlockView!.hide(cellView: fromCellCoord)
			
		}
		
		// Set cellCoord in cellView
		gcp.cellCoord 	= CellCoord(column: toCellCoord.column, row: toCellCoord.row)
		
		// Go through each tileView
		for tileView in cellView.tileViews.values {
			
			// Set cellCoord in cellView
			tileView.gridTileProperties!.cellCoord = CellCoord(column: toCellCoord.column, row: toCellCoord.row)
			
		}
		
	}

	fileprivate func moveCellDoBeforeReposition(cellView: ProtocolGridCellView, toCellCoord: CellCoord) {
		
		(cellView as! UIView).alpha = 0
		(cellView as! UIView).removeFromSuperview()
		
		let gcp: 		GridCellProperties = cellView.gridCellProperties!
		
		// Set cellCoord in cellView
		gcp.cellCoord 	= CellCoord(column: toCellCoord.column, row: toCellCoord.row)
		
		// Go through each tileView
		for tileView in cellView.tileViews.values {
			
			// Set cellCoord in cellView
			tileView.gridTileProperties!.cellCoord = CellCoord(column: toCellCoord.column, row: toCellCoord.row)
			
		}
		
	}
	
	fileprivate func moveCellDoAfterReposition(cellView: ProtocolGridCellView, fromCellCoord: CellCoord, toBlockView: GridBlockView?, toCellCoord: CellCoord) {
		
		if (toBlockView != nil) {
			
			// Present cellView in toBlockView
			toBlockView!.present(cellView: cellView)
			
		}
		
		(cellView as! UIView).alpha = 1
		
		// calculatePopulatedCells
		GridScapeHelper.calculatePopulatedCells(blockViews: self.blockViews, gridProperties: self.gridProperties, gridState: self.gridState)
		self.gridScapeView!.displayPopulatedCellsProperties(gridState: self.gridState)
		
		// Notify the delegate
		self.delegate!.gridScapeManager(cellMoved: cellView, from: fromCellCoord, to: toCellCoord)
		
	}

	fileprivate func moveCellDoAfterReposition(cellView: ProtocolGridCellView, toBlockView: GridBlockView?, toCellCoord: CellCoord) {
		
		(cellView as! UIView).alpha = 1
		
		if (toBlockView != nil) {
			
			// Present cellView in toBlockView
			toBlockView!.present(cellView: cellView)
			
		}
		
		// Add to index in cellAttributesIndex
		self.cellAttributesIndex.index(attributes: cellView)
		
		// calculatePopulatedCells
		GridScapeHelper.calculatePopulatedCells(blockViews: self.blockViews, gridProperties: self.gridProperties, gridState: self.gridState)
		self.gridScapeView!.displayPopulatedCellsProperties(gridState: self.gridState)
		
		// Notify the delegate
		self.delegate!.gridScapeManager(cellDropped: cellView, at: toCellCoord)

	}
	
	fileprivate func move(cell cellView: ProtocolGridCellView, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let gp: 				GridProperties = self.gridProperties
		let fromCellCoord:		CellCoord = cellView.gridCellProperties!.cellCoord!
		
		// get fromBlockCoord
		let fromBlockCoord: 	BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: fromCellCoord, gridProperties: gp)
		
		// Get fromBlockView
		let fromBlockView: 		GridBlockView? = self.get(gridBlockView: fromBlockCoord)
		
		// get toBlockCoord
		let toBlockCoord: 		BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: toCellCoord, gridProperties: gp)
		
		// Get toBlockView
		let toBlockView: 		GridBlockView? = self.get(gridBlockView: toBlockCoord)
		
		// Do before reposition
		self.moveCellDoBeforeReposition(cellView: cellView, fromCellCoord: fromCellCoord, fromBlockView: fromBlockView, toCellCoord: toCellCoord)
		
		// Create completion handler
		let repositionCellViewCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			if (error == nil) {
				
				// Do after reposition
				self.moveCellDoAfterReposition(cellView: cellView, fromCellCoord: fromCellCoord, toBlockView: toBlockView, toCellCoord: toCellCoord)
				
			}
			
			// Call the completion handler
			completionHandler(error)
			
		}
		
		if (fromBlockView == nil && toBlockView == nil) {
			
			// Nb: fromBlockView and toBlockView are off the screen, so reposition not required.
			
			// Call the completion handler
			repositionCellViewCompletionHandler(nil)
			
		} else {
			
			// Reposition cellView
			self.gridScapeView!.reposition(cell: cellView, from: fromCellCoord, fromBlockView: fromBlockView, to: toCellCoord, toBlockView: toBlockView, oncomplete: repositionCellViewCompletionHandler)
			
		}
		
	}
	
	fileprivate func move(cell cellView: ProtocolGridCellView, droppedAt indicatedPoint: CGPoint, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let gp: 				GridProperties = self.gridProperties

		// get toBlockCoord
		let toBlockCoord: 		BlockCoord = GridScapeHelper.toBlockCoord(fromCellCoord: toCellCoord, gridProperties: gp)
		
		// Get toBlockView
		let toBlockView: 		GridBlockView? = self.get(gridBlockView: toBlockCoord)
		
		// Do before reposition
		self.moveCellDoBeforeReposition(cellView: cellView, toCellCoord: toCellCoord)
		
		// Create completion handler
		let repositionCellViewCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			if (error == nil) {
				
				// Do after reposition
				self.moveCellDoAfterReposition(cellView: cellView, toBlockView: toBlockView, toCellCoord: toCellCoord)
				
			}
			
			self.gridScapeView!.layoutIfNeeded()
			
			// Call the completion handler
			completionHandler(error)
			
		}
		
		if (toBlockView == nil) {
			
			// Nb: toBlockView is off the screen, so reposition not required.
			
			// Call the completion handler
			repositionCellViewCompletionHandler(nil)
			
		} else {
			
			let gcp: 					GridCellProperties = cellView.gridCellProperties!
			
			// Get topLeftIndicatedPoint from indicatedPoint which is the center of the cellView
			let topLeftIndicatedPoint: 	CGPoint = CGPoint(x: indicatedPoint.x - (gcp.cellWidth / 2), y: indicatedPoint.y - (gcp.cellHeight / 2))
			
			// Reposition cellView
			self.gridScapeView!.reposition(cell: cellView, from: topLeftIndicatedPoint, to: toCellCoord, oncomplete: repositionCellViewCompletionHandler)
			
		}
		
	}
	
	fileprivate func checkLongPressedCellView(gesture: UILongPressGestureRecognizer, indicatedPoint: CGPoint, cellView: ProtocolGridCellView) -> ProtocolGridCellView? {
		
		// Convert to point inside cellView
		let cellViewPoint 	= gesture.view!.convert(indicatedPoint, to: cellView as! UIView)
		
		// Check cellView
		guard (cellView.checkHitTest(onCell: cellViewPoint) != nil) else { return nil }
		
		// Notify the delegate
		self.delegate?.gridScapeManager(longPressed: cellView, at: indicatedPoint, gesture: gesture)
		
		return cellView
		
	}
	
	
	// MARK: - Private Methods; GridTileView
	
	fileprivate func moveTileDoBeforeReposition(tileView: ProtocolGridTileView, fromCellCoord: CellCoord, fromCellView: ProtocolGridCellView?, toCellCoord: CellCoord) {
		
		(tileView as! UIView).alpha = 0
		
		let gtp: 		GridTileProperties = tileView.gridTileProperties!
		
		if (fromCellView != nil) {
			
			// Remove from fromCellView
			fromCellView!.hide(tileView: gtp.key)
			
		}
		
		// Set cellCoord in tileView
		gtp.cellCoord 	= CellCoord(column: toCellCoord.column, row: toCellCoord.row)
		
	}
	
	fileprivate func moveTileDoBeforeReposition(tileView: ProtocolGridTileView, toCellCoord: CellCoord) {
		
		(tileView as! UIView).alpha = 0
		(tileView as! UIView).removeFromSuperview()
		
		let gtp: 		GridTileProperties = tileView.gridTileProperties!
		
		// Set cellCoord in tileView
		gtp.cellCoord 	= CellCoord(column: toCellCoord.column, row: toCellCoord.row)
		
	}
	
	fileprivate func moveTileDoAfterReposition(tileView: ProtocolGridTileView, fromCellCoord: CellCoord, toCellView: ProtocolGridCellView?, toCellCoord: CellCoord) {
		
		if (toCellView != nil) {
			
			// Present tileView in toCellView
			toCellView!.present(tileView: tileView)
			
		}
		
		(tileView as! UIView).alpha = 1

		// Notify the delegate
		self.delegate!.gridScapeManager(tileMoved: tileView, from: fromCellCoord, to: toCellCoord)
		
	}
	
	fileprivate func moveTileDoAfterReposition(tileView: ProtocolGridTileView, toCellView: ProtocolGridCellView?, toCellCoord: CellCoord) {
		
		(tileView as! UIView).alpha = 1
		
		if (toCellView != nil) {
			
			// Present cellView in toCellView
			toCellView!.present(tileView: tileView)
			
		}
		
		// Notify the delegate
		self.delegate!.gridScapeManager(tileDropped: tileView, at: toCellCoord)
		
	}
	
	fileprivate func move(tile tileView: ProtocolGridTileView, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let fromCellCoord:		CellCoord = tileView.gridTileProperties!.cellCoord!
		
		// Get fromCellView
		let fromCellView: 		ProtocolGridCellView? = self.get(cellView: fromCellCoord)

		// Get toCellView
		let toCellView: 		ProtocolGridCellView? = self.get(cellView: toCellCoord)
		
		// Do before reposition
		self.moveTileDoBeforeReposition(tileView: tileView, fromCellCoord: fromCellCoord, fromCellView: fromCellView, toCellCoord: toCellCoord)
		
		// Create completion handler
		let repositionTileViewCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			if (error == nil) {
				
				// Do after reposition
				self.moveTileDoAfterReposition(tileView: tileView, fromCellCoord: fromCellCoord, toCellView: toCellView, toCellCoord: toCellCoord)
				
			}
			
			// Call the completion handler
			completionHandler(error)
			
		}
		
		if (fromCellView == nil && toCellView == nil) {
			
			// Nb: fromCellView and toCellView are off the screen, so reposition not required.
			
			// Call the completion handler
			repositionTileViewCompletionHandler(nil)
			
		} else {
			
			// Reposition tileView
			self.gridScapeView!.reposition(tile: tileView, from: fromCellCoord, fromCellView: fromCellView, to: toCellCoord, toCellView: toCellView, oncomplete: repositionTileViewCompletionHandler)
			
		}
		
	}
	
	fileprivate func move(tile tileView: ProtocolGridTileView, droppedAt indicatedPoint: CGPoint, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {

		// Get toCellView
		let toCellView: 	ProtocolGridCellView? = self.get(cellView: toCellCoord)
		
		// Do before reposition
		self.moveTileDoBeforeReposition(tileView: tileView, toCellCoord: toCellCoord)
		
		// Create completion handler
		let repositionTileViewCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			if (error == nil) {
				
				// Do after reposition
				self.moveTileDoAfterReposition(tileView: tileView, toCellView: toCellView, toCellCoord: toCellCoord)
				
			}
			
			self.gridScapeView!.layoutIfNeeded()
			
			// Call the completion handler
			completionHandler(error)
			
		}
		
		if (toCellView == nil) {
			
			// Nb: toCellView is off the screen, so reposition not required.
			
			// Call the completion handler
			repositionTileViewCompletionHandler(nil)
			
		} else {
			
			let gtp: 					GridTileProperties = tileView.gridTileProperties!
			
			// Get topLeftIndicatedPoint from indicatedPoint which is the center of the tileView
			let topLeftIndicatedPoint: 	CGPoint = CGPoint(x: indicatedPoint.x - (gtp.tileWidth / 2), y: indicatedPoint.y - (gtp.tileHeight / 2))
	
			// Reposition tileView
			self.gridScapeView!.reposition(tile: tileView, from: topLeftIndicatedPoint, to: toCellView!, oncomplete: repositionTileViewCompletionHandler)
			
		}
		
	}
	
	fileprivate func checkLongPressedTileView(gesture: UILongPressGestureRecognizer, indicatedPoint: CGPoint, cellView: ProtocolGridCellView) -> ProtocolGridTileView? {
		
		// Convert to point inside cellView
		let cellViewPoint 	= gesture.view!.convert(indicatedPoint, to: cellView as! UIView)
		
		// Check tileView
		let tileView: 		ProtocolGridTileView? = cellView.checkHitTest(onTile: cellViewPoint)
		
		guard (tileView != nil) else { return nil }
		
		// Notify the delegate
		self.delegate?.gridScapeManager(longPressed: tileView!, cellView: cellView, at: indicatedPoint, gesture: gesture)
		
		return tileView
		
	}
	
	
	// MARK: - Private Methods; GridTokenView
	
	fileprivate func moveTokenDoBeforeReposition(tokenView: ProtocolGridTokenView, fromCellCoord: CellCoord, fromCellView: ProtocolGridCellView?, toCellCoord: CellCoord) {
		
		(tokenView as! UIView).alpha = 0
		
		let gtp: 		GridTokenProperties = tokenView.gridTokenProperties!
		
		if (fromCellView != nil) {
			
			// Remove from fromCellView
			fromCellView!.hide(tokenView: gtp.key)
			
		}
		
		// Set cellCoord in tokenView
		gtp.cellCoord 	= CellCoord(column: toCellCoord.column, row: toCellCoord.row)
		
	}
	
	fileprivate func moveTokenDoBeforeReposition(tokenView: ProtocolGridTokenView, toCellCoord: CellCoord) {
		
		(tokenView as! UIView).alpha = 0
		(tokenView as! UIView).removeFromSuperview()
		
		let gtp: 		GridTokenProperties = tokenView.gridTokenProperties!
		
		// Set cellCoord in tokenView
		gtp.cellCoord 	= CellCoord(column: toCellCoord.column, row: toCellCoord.row)
		
	}
	
	fileprivate func moveTokenDoAfterReposition(tokenView: ProtocolGridTokenView, fromCellCoord: CellCoord, toCellView: ProtocolGridCellView?, toCellCoord: CellCoord, notifyDelegateYN: Bool) {
		
		if (toCellView != nil) {
			
			// Present tokenView in toCellView
			toCellView!.present(tokenView: tokenView)
			
		}
		
		(tokenView as! UIView).alpha = 1
		
		if (notifyDelegateYN) {
		
			// Notify the delegate
			self.delegate!.gridScapeManager(tokenMoved: tokenView, from: fromCellCoord, to: toCellCoord)
			
		}

	}
	
	fileprivate func moveTokenDoAfterReposition(tokenView: ProtocolGridTokenView, toCellView: ProtocolGridCellView?, toCellCoord: CellCoord) {
		
		(tokenView as! UIView).alpha = 1
		
		if (toCellView != nil) {
			
			// Present tokenView in toCellView
			toCellView!.present(tokenView: tokenView)
			
		}
		
		// Notify the delegate
		//self.delegate!.gridScapeManager(tokenDropped: tokenView, at: toCellCoord)
		
	}
	
	fileprivate func move(token tokenView: ProtocolGridTokenView, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let fromCellCoord:		CellCoord = tokenView.gridTokenProperties!.cellCoord!
		
		// Get fromCellView
		let fromCellView: 		ProtocolGridCellView? = self.get(cellView: fromCellCoord)
		
		// Get toCellView
		let toCellView: 		ProtocolGridCellView? = self.get(cellView: toCellCoord)
		
		// Do before reposition
		self.moveTokenDoBeforeReposition(tokenView: tokenView, fromCellCoord: fromCellCoord, fromCellView: fromCellView, toCellCoord: toCellCoord)
		
		// Create completion handler
		let repositionTokenViewCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			if (error == nil) {
				
				// Do after reposition
				self.moveTokenDoAfterReposition(tokenView: tokenView, fromCellCoord: fromCellCoord, toCellView: toCellView, toCellCoord: toCellCoord, notifyDelegateYN: true)
				
			}
			
			// Call the completion handler
			completionHandler(error)
			
		}
		
		if (fromCellView == nil && toCellView == nil) {
			
			// Nb: fromCellView and toCellView are off the screen, so reposition not required.
			
			// Call the completion handler
			repositionTokenViewCompletionHandler(nil)
			
		} else {
			
			// Reposition tokenView
			self.gridScapeView!.reposition(token: tokenView, from: fromCellCoord, fromCellView: fromCellView, to: toCellCoord, toCellView: toCellView, oncomplete: repositionTokenViewCompletionHandler)
			
		}
		
	}

	fileprivate func move(token tokenView: ProtocolGridTokenView, droppedAt indicatedPoint: CGPoint, to toCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get toCellView
		let toCellView: 	ProtocolGridCellView? = self.get(cellView: toCellCoord)
		
		// Do before reposition
		self.moveTokenDoBeforeReposition(tokenView: tokenView, toCellCoord: toCellCoord)
		
		// Create completion handler
		let repositionTokenViewCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			if (error == nil) {
				
				// Do after reposition
				self.moveTokenDoAfterReposition(tokenView: tokenView, toCellView: toCellView, toCellCoord: toCellCoord)
				
			}
			
			self.gridScapeView!.layoutIfNeeded()
			
			// Call the completion handler
			completionHandler(error)
			
		}
		
		if (toCellView == nil) {
			
			// Nb: toCellView is off the screen, so reposition not required.
			
			// Call the completion handler
			repositionTokenViewCompletionHandler(nil)
			
		} else {
			
			let gtp: 					GridTokenProperties = tokenView.gridTokenProperties!
			
			// Get topLeftIndicatedPoint from indicatedPoint which is the center of the tokenView
			let topLeftIndicatedPoint: 	CGPoint = CGPoint(x: indicatedPoint.x - (gtp.tokenWidth / 2), y: indicatedPoint.y - (gtp.tokenHeight / 2))
			
			// Reposition tokenView
			self.gridScapeView!.reposition(token: tokenView, from: topLeftIndicatedPoint, to: toCellCoord, oncomplete: repositionTokenViewCompletionHandler)
			
		}
		
	}
	
	fileprivate func checkLongPressedTokenView(gesture: UILongPressGestureRecognizer, indicatedPoint: CGPoint, cellView: ProtocolGridCellView) -> ProtocolGridTokenView? {
		
		// Convert to point inside cellView
		let cellViewPoint 	= gesture.view!.convert(indicatedPoint, to: cellView as! UIView)
		
		// Check tokenView
		let tokenView: 		ProtocolGridTokenView? = cellView.checkHitTest(onToken: cellViewPoint)
		
		guard (tokenView != nil) else { return nil }
		
		// Notify the delegate
		self.delegate?.gridScapeManager(longPressed: tokenView!, cellView: cellView, at: indicatedPoint, gesture: gesture)
		
		return tokenView
		
	}
	
	
	// MARK: - Private Methods; Blocks

	fileprivate func fillWithBlocks(buildProperties: GridBuildProperties, fillCells: Bool) {
		
		// Get blockCoords
		let tlmbc: 	BlockCoord = buildProperties.topLeftMarginBlockCoord!
		let brmbc: 	BlockCoord = buildProperties.bottomRightMarginBlockCoord!
		
		if (buildProperties.numberofColumns > 0) {
			
			// Go through each column
			for ci in tlmbc.column...brmbc.column {
				
				if (buildProperties.numberofRows > 0) {
					
					// Go through each row
					for ri in tlmbc.row...brmbc.row {
						
						self.doPresentGridBlockView(columnIndex: ci, rowIndex: ri, fillCells: fillCells)
						
					}
					
				}
				
			}
			
		}
		
	}
	
	fileprivate func fillToFitWithBlocks(buildProperties: GridBuildProperties, fillCells: Bool) {
		
		let s: 						GridState = self.gridState
		
		// Create unloadedCellCoords
		var unloadedCellCoords: 	[CellCoord] = [CellCoord]()
		
		// Get blockCoords
		let tlmbc: 					BlockCoord = buildProperties.topLeftMarginBlockCoord!
		let brmbc: 					BlockCoord = buildProperties.bottomRightMarginBlockCoord!
		
		// Is current number of columns > required number of columns?
		if (s.numberofColumns > buildProperties.numberofColumns) {
			
			// Remove columns
			let ccr: CellCoordRange = self.removeColumnsFrom(fromIndex: brmbc.column + 1)
			
			// Get unloaded cellCoords
			unloadedCellCoords.append(contentsOf: ccr.toCellCoords())
			
		}
		
		// Is current number of rows > required number of rows?
		if (s.numberofRows > buildProperties.numberofRows) {
			
			// Remove rows
			let ccr: CellCoordRange = self.removeRowsFrom(fromIndex: brmbc.row + 1)
			
			// Get unloaded cellCoords
			unloadedCellCoords.append(contentsOf: ccr.toCellCoords())
			
		}
		
		// Check unloadedCellCoords
		if (unloadedCellCoords.count > 0) {
			
			// Notify the delegate
			self.delegate?.gridScapeManager(unloadedCells: unloadedCellCoords)
			
			// calculatePopulatedCells
			GridScapeHelper.calculatePopulatedCells(blockViews: self.blockViews, gridProperties: self.gridProperties, gridState: self.gridState)
			self.gridScapeView!.displayPopulatedCellsProperties(gridState: self.gridState)
			
		}
		
		// Create and present blocks
		// Go through each column
		for ci in tlmbc.column...brmbc.column {
			
			// Go through each row
			for ri in tlmbc.row...brmbc.row {
				
				let blockCoord: 		BlockCoord = BlockCoord()
				blockCoord.column 		= ci
				blockCoord.row 			= ri
				
				DispatchQueue.main.async {
					
					// Get blockView
					var blockView: 		GridBlockView? = self.get(gridBlockView: blockCoord)
					
					// Check if blockView exists
					if (blockView == nil) {
						
						// Create blockView
						blockView		= self.createGridBlockView(at: blockCoord, fillCells: fillCells)
						
						// Present blockView
						self.presentGridBlockView(blockView: blockView!)
						
					}
					
				}
				
			}
			
		}
		
	}
	
	fileprivate func rebuildAfterPanningStopped() {
		
		self.set(isBuildingBlocksYN: true, notifyDelegate: false)
		
		// Calculate block coords
		self.buildProperties!.calculateBlockCoords(gridProperties: self.gridProperties, gridState: self.gridState)

		// Add blocks up to margins
		self.addBlocksUpToMargins(buildProperties: self.buildProperties!)
		
		// Remove blocks outside margins
		self.removeBlocksOutsideMargins(buildProperties: self.buildProperties!)
		
		self.gridScapeView!.displayBlocksProperties(numberofBlocks: self.blockViews.count, gridState: self.gridState)
		
		self.set(isBuildingBlocksYN: false, notifyDelegate: false)
		
	}

	fileprivate func rebuildAfterPanningContinued(gridScrollState: GridScrollState) {
		
		let s: GridState = self.gridState
		
		// Is true x of marginFrame right > true maxX of last column
		if (gridScrollState.mfrx > s.lastBlockColumnTrueMaxX) {
			
			let rccr: CellCoordRange? = self.appendColumn(fillCells: false)
			
			if (rccr != nil) {
				
				// Notify the delegate
				self.delegate?.gridScapeManager(loadCells: self, cellCoordRange: rccr!)
				
			}
			
		}
		
		// Is true x of marginFrame left < true minX of first column
		if (gridScrollState.mflx < s.firstBlockColumnTrueMinX) {
			
			let lccr: CellCoordRange? = self.prependColumn(fillCells: false)
			
			if (lccr != nil) {
				
				// Notify the delegate
				self.delegate?.gridScapeManager(loadCells: self, cellCoordRange: lccr!)
				
			}
			
		}
	
		// Is true y of marginFrame bottom > true maxY of last row
		if (gridScrollState.mfby > s.lastBlockRowTrueMaxY) {
			
			let bccr: CellCoordRange? = self.appendRow(fillCells: false)
			
			if (bccr != nil) {
				
				// Notify the delegate
				self.delegate?.gridScapeManager(loadCells: self, cellCoordRange: bccr!)
				
			}
			
		}
		
		// Is true y of marginFrame top < true minY of first row
		if (gridScrollState.mfty < s.firstBlockRowTrueMinY) {
			
			let tccr: CellCoordRange? = self.prependRow(fillCells: false)
			
			if (tccr != nil) {
				
				// Notify the delegate
				self.delegate?.gridScapeManager(loadCells: self, cellCoordRange: tccr!)
				
			}
			
		}
		
	}
	
	fileprivate func addBlocksUpToMargins(buildProperties: GridBuildProperties) {
		
		// Get blockCoords
		let tlmbc: 		BlockCoord = buildProperties.topLeftMarginBlockCoord!
		let brmbc: 		BlockCoord = buildProperties.bottomRightMarginBlockCoord!
		
		// Add columns up to left margin
		let lccr: 		CellCoordRange? = self.addColumnsUpToLeftMargin(buildProperties: buildProperties, fillCells: false)
		
		// Add rows up to top margin
		let tccr: 		CellCoordRange? = self.addRowsUpToTopMargin(buildProperties: buildProperties, fillCells: false)
		
		// Add columns up to right margin
		let rccr: 		CellCoordRange? = self.addColumnsUpToRightMargin(buildProperties: buildProperties, fillCells: false)
		
		// Add rows up to bottom margin
		let bccr: 		CellCoordRange? = self.addRowsUpToBottomMargin(buildProperties: buildProperties, fillCells: false)
		
		// Set layout properties
		GridScapeHelper.calculateBlockLayoutProperties(topLeftMarginBlockCoord: tlmbc,
													   bottomRightMarginBlockCoord: brmbc,
													   gridProperties: self.gridProperties,
													   gridState: self.gridState)
		
		if (lccr != nil) {
			
			// Notify the delegate
			self.delegate?.gridScapeManager(loadCells: self, cellCoordRange: lccr!)
			
		}

		if (tccr != nil) {
			
			// Notify the delegate
			self.delegate?.gridScapeManager(loadCells: self, cellCoordRange: tccr!)
			
		}
		
		if (rccr != nil) {
			
			// Notify the delegate
			self.delegate?.gridScapeManager(loadCells: self, cellCoordRange: rccr!)
			
		}
		
		if (bccr != nil) {
			
			// Notify the delegate
			self.delegate?.gridScapeManager(loadCells: self, cellCoordRange: bccr!)
			
		}
		
	}

	fileprivate func removeBlocksOutsideMargins(buildProperties: GridBuildProperties) {

		let tlmbc: 					BlockCoord = buildProperties.topLeftMarginBlockCoord!
		let brmbc: 					BlockCoord = buildProperties.bottomRightMarginBlockCoord!
		
		// Create unloadedCellCoords
		var unloadedCellCoords: 	[CellCoord] = [CellCoord]()
		
		// Go through each item
		for blockView in self.blockViews.values {
			
			let blockCoord: 		BlockCoord = blockView.gridBlockProperties!.blockCoord!
			
			// Check if outside margin
			if (blockCoord.column < tlmbc.column
				|| blockCoord.column > brmbc.column
				|| blockCoord.row < tlmbc.row
				|| blockCoord.row > brmbc.row) {
				
				// hide blockView
				self.hideGridBlockView(blockView: blockView)
				
				// Get unloaded cellCoords
				unloadedCellCoords.append(contentsOf: GridScapeHelper.toCellCoords(fromBlockCoord: blockCoord, gridProperties: self.gridProperties))
				
			}
			
		}
		
		// calculatePopulatedCells
		GridScapeHelper.calculatePopulatedCells(blockViews: self.blockViews, gridProperties: self.gridProperties, gridState: self.gridState)
		self.gridScapeView!.displayPopulatedCellsProperties(gridState: self.gridState)
		
		// Notify the delegate
		self.delegate?.gridScapeManager(unloadedCells: unloadedCellCoords)
		
	}
	
	
	// MARK: - Private Methods; Columns
	
	fileprivate func prependColumn(fillCells: Bool) -> CellCoordRange? {
		
		guard (self.gridState.numberofRows > 0) else { return nil }
		guard (self.buildProperties!.gridSizeMinBlockColumnIndex == nil || self.gridState.firstBlockColumnIndex > 0) else { return nil }
		
		let s: 			GridState = self.gridState
		
		// Get new column index
		let ci: 		Int = s.firstBlockColumnIndex - 1
		
		// topLeftMargin
		let tlmbc:		BlockCoord = BlockCoord()
		tlmbc.column 	= ci
		tlmbc.row 		= s.firstBlockRowIndex
		
		// Go through each row
		for ri in s.firstBlockRowIndex...s.lastBlockRowIndex {
			
			self.doPresentGridBlockView(columnIndex: ci, rowIndex: ri, fillCells: fillCells)
			
		}
		
		// Set layout properties
		GridScapeHelper.calculateBlockLayoutProperties(topLeftMarginBlockCoord: tlmbc,
													   bottomRightMarginBlockCoord: nil,
													   gridProperties: self.gridProperties,
													   gridState: self.gridState)
		
		let fromBlockCoord: 	BlockCoord = BlockCoord()
		fromBlockCoord.column 	= ci
		fromBlockCoord.row 		= s.firstBlockRowIndex
		
		let toBlockCoord: 		BlockCoord = BlockCoord()
		toBlockCoord.column 	= ci
		toBlockCoord.row 		= s.lastBlockRowIndex
		
		let result:				CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: fromBlockCoord, gridProperties: self.gridProperties)
		result.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: toBlockCoord, gridProperties: self.gridProperties))
		
		return result
		
	}
	
	fileprivate func appendColumn(fillCells: Bool) -> CellCoordRange? {
		
		guard (self.gridState.numberofRows > 0) else { return nil }
		guard (self.buildProperties!.gridSizeMaxBlockColumnIndex == nil || self.gridState.lastBlockColumnIndex < self.buildProperties!.gridSizeMaxBlockColumnIndex!) else { return nil }
		
		let s: 			GridState = self.gridState
		
		// Get new column index
		let ci: 		Int = s.lastBlockColumnIndex + 1
		
		// bottomRightMargin
		let brmbc:		BlockCoord = BlockCoord()
		brmbc.column 	= ci
		brmbc.row 		= s.lastBlockRowIndex
		
		// Go through each row
		for ri in s.firstBlockRowIndex...s.lastBlockRowIndex {
			
			self.doPresentGridBlockView(columnIndex: ci, rowIndex: ri, fillCells: fillCells)
			
		}
		
		// Set layout properties
		GridScapeHelper.calculateBlockLayoutProperties(topLeftMarginBlockCoord: nil,
													   bottomRightMarginBlockCoord: brmbc,
													   gridProperties: self.gridProperties,
													   gridState: self.gridState)
		
		let fromBlockCoord: 	BlockCoord = BlockCoord()
		fromBlockCoord.column 	= ci
		fromBlockCoord.row 		= s.firstBlockRowIndex
		
		let toBlockCoord: 		BlockCoord = BlockCoord()
		toBlockCoord.column 	= ci
		toBlockCoord.row 		= s.lastBlockRowIndex
		
		let result:				CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: fromBlockCoord, gridProperties: self.gridProperties)
		result.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: toBlockCoord, gridProperties: self.gridProperties))
		
		return result
		
	}
	
	fileprivate func addColumnsUpToLeftMargin(buildProperties: GridBuildProperties, fillCells: Bool) -> CellCoordRange? {
		
		var result: 	CellCoordRange? = nil
		
		let s: 			GridState = self.gridState
		
		// Get blockCoords
		let tlmbc: 		BlockCoord = buildProperties.topLeftMarginBlockCoord!
		let brmbc: 		BlockCoord = buildProperties.bottomRightMarginBlockCoord!
		
		if (s.firstBlockColumnIndex > tlmbc.column) {
			
			let fromBlockCoord: 	BlockCoord = BlockCoord()
			fromBlockCoord.column 	= tlmbc.column
			fromBlockCoord.row 		= tlmbc.row
			
			let toBlockCoord: 		BlockCoord = BlockCoord()
			toBlockCoord.column 	= s.firstBlockColumnIndex - 1
			toBlockCoord.row 		= brmbc.row
			
			result = GridScapeHelper.toCellCoordRange(fromBlockCoord: fromBlockCoord, gridProperties: self.gridProperties)
			result!.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: toBlockCoord, gridProperties: self.gridProperties))
			
			// Check cellCoords for grid size
			GridScapeHelper.checkGridSizeCellCoordRange(cellCoordRange: result!, gridProperties: self.gridProperties)
			
			// Go through each column
			for ci in (tlmbc.column...(s.firstBlockColumnIndex - 1)).reversed() {
				
				// Go through each row
				for ri in tlmbc.row...brmbc.row {
					
					self.doPresentGridBlockView(columnIndex: ci, rowIndex: ri, fillCells: fillCells)
					
				}
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func addColumnsUpToRightMargin(buildProperties: GridBuildProperties, fillCells: Bool) -> CellCoordRange? {
		
		var result: 	CellCoordRange? = nil
		
		let s: 			GridState = self.gridState
		
		// Get blockCoords
		let tlmbc: 		BlockCoord = buildProperties.topLeftMarginBlockCoord!
		let brmbc: 		BlockCoord = buildProperties.bottomRightMarginBlockCoord!
		
		if (s.lastBlockColumnIndex < brmbc.column) {
			
			let fromBlockCoord: 	BlockCoord = BlockCoord()
			fromBlockCoord.column 	= s.lastBlockColumnIndex + 1
			fromBlockCoord.row 		= tlmbc.row
			
			let toBlockCoord: 		BlockCoord = BlockCoord()
			toBlockCoord.column 	= brmbc.column
			toBlockCoord.row 		= brmbc.row
			
			result = GridScapeHelper.toCellCoordRange(fromBlockCoord: fromBlockCoord, gridProperties: self.gridProperties)
			result!.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: toBlockCoord, gridProperties: self.gridProperties))
			
			// Check cellCoords for grid size
			GridScapeHelper.checkGridSizeCellCoordRange(cellCoordRange: result!, gridProperties: self.gridProperties)
			
			// Go through each column
			for ci in (s.lastBlockColumnIndex + 1)...brmbc.column {
				
				// Go through each row
				for ri in tlmbc.row...brmbc.row {
					
					self.doPresentGridBlockView(columnIndex: ci, rowIndex: ri, fillCells: fillCells)
					
				}
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func removeColumnsOutsideLeftMargin(buildProperties: GridBuildProperties) -> CellCoordRange? {

		var result:						CellCoordRange? = nil
		
		let actualFirstColumnIndex: 	Int = self.gridState.firstBlockColumnIndex
		let requiredFirstColumnIndex: 	Int = buildProperties.topLeftMarginBlockCoord!.column
		
		if (actualFirstColumnIndex < requiredFirstColumnIndex) {
			
			// Remove columns outside left margin
			result = self.removeColumnsFrom(fromIndex: actualFirstColumnIndex, toIndex: requiredFirstColumnIndex - 1)
			
		}
		
		return result
		
	}

	fileprivate func removeColumnsOutsideRightMargin(buildProperties: GridBuildProperties) -> CellCoordRange? {
		
		var result:						CellCoordRange? = nil
		
		let actualLastColumnIndex: 		Int = self.gridState.lastBlockColumnIndex
		let requiredLastColumnIndex: 	Int = buildProperties.bottomRightMarginBlockCoord!.column
		
		if (actualLastColumnIndex > requiredLastColumnIndex) {
			
			// Remove columns outside right margin
			result = self.removeColumnsFrom(fromIndex: requiredLastColumnIndex + 1, toIndex: actualLastColumnIndex)
			
		}
		
		return result
		
	}
	
	fileprivate func removeColumnsFrom(fromIndex: Int) -> CellCoordRange {
		
		let result: CellCoordRange = self.removeColumnsFrom(fromIndex: fromIndex, toIndex: self.gridState.lastBlockColumnIndex)

		return result
		
	}

	fileprivate func removeColumnsFrom(fromIndex: Int, toIndex: Int) -> CellCoordRange {
		
		let s: 			GridState = self.gridState
		
		// Create blockCoords
		// topLeft
		let tlbc:		BlockCoord = BlockCoord()
		tlbc.column 	= fromIndex
		tlbc.row 		= s.firstBlockRowIndex
		
		// bottomRight
		let brbc:		BlockCoord = BlockCoord()
		brbc.column 	= toIndex
		brbc.row 		= s.lastBlockRowIndex
		
		// Get cellCoordRange
		let result:		CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: tlbc, gridProperties: self.gridProperties)
		result.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: brbc, gridProperties: self.gridProperties))
		
		// Remove columns
		self.doRemoveColumns(fromIndex: fromIndex, toIndex: toIndex)
		
		return result
		
	}

	fileprivate func doRemoveColumns(fromIndex: Int, toIndex: Int) {
		
		guard (self.gridState.numberofColumns > 0) else { return }
		
		guard (fromIndex == self.gridState.firstBlockColumnIndex
			|| toIndex == self.gridState.lastBlockColumnIndex) else { return }
		
		let s: 			GridState = self.gridState
		
		// Go through each column
		for ci in fromIndex...toIndex {
			
			// Go through each row
			for ri in s.firstBlockRowIndex...s.lastBlockRowIndex {
				
				let blockCoord: 	BlockCoord = BlockCoord()
				blockCoord.column 	= ci
				blockCoord.row 		= ri
				
				// Get blockView
				let blockView: 		GridBlockView? = self.get(gridBlockView: blockCoord)
				
				if (blockView != nil) {
					
					// hide blockView
					self.hideGridBlockView(blockView: blockView!)
					
				}
				
			}
			
		}
		
	}
	
	fileprivate func doRemoveColumns(fromIndex: Int) {
		
		guard (self.gridState.numberofColumns > 0
			&& fromIndex <= self.gridState.lastBlockColumnIndex) else { return }
		
		self.doRemoveColumns(fromIndex: fromIndex, toIndex: self.gridState.lastBlockColumnIndex)
		
	}
	
	
	// MARK: - Private Methods; Rows
	
	fileprivate func prependRow(fillCells: Bool) -> CellCoordRange? {
		
		guard (self.gridState.numberofColumns > 0) else { return nil }
		guard (self.buildProperties!.gridSizeMinBlockRowIndex == nil || self.gridState.firstBlockRowIndex > 0) else { return nil }
		
		let s: 			GridState = self.gridState
		
		// Get new row index
		let ri: 		Int = s.firstBlockRowIndex - 1
		
		// topLeftMargin
		let tlmbc:		BlockCoord = BlockCoord()
		tlmbc.column 	= s.firstBlockColumnIndex
		tlmbc.row 		= ri
		
		// Go through each column
		for ci in s.firstBlockColumnIndex...s.lastBlockColumnIndex {
			
			self.doPresentGridBlockView(columnIndex: ci, rowIndex: ri, fillCells: fillCells)
			
		}
		
		// Set layout properties
		GridScapeHelper.calculateBlockLayoutProperties(topLeftMarginBlockCoord: tlmbc,
													   bottomRightMarginBlockCoord: nil,
													   gridProperties: self.gridProperties,
													   gridState: self.gridState)
		
		let fromBlockCoord: 	BlockCoord = BlockCoord()
		fromBlockCoord.column 	= s.firstBlockColumnIndex
		fromBlockCoord.row 		= ri
		
		let toBlockCoord: 		BlockCoord = BlockCoord()
		toBlockCoord.column 	= s.lastBlockColumnIndex
		toBlockCoord.row 		= ri
		
		let result:				CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: fromBlockCoord, gridProperties: self.gridProperties)
		result.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: toBlockCoord, gridProperties: self.gridProperties))
		
		return result
		
	}
	
	fileprivate func appendRow(fillCells: Bool) -> CellCoordRange? {
		
		guard (self.gridState.numberofColumns > 0) else { return nil }
		guard (self.buildProperties!.gridSizeMaxBlockRowIndex == nil || self.gridState.lastBlockRowIndex < self.buildProperties!.gridSizeMaxBlockRowIndex!) else { return nil }
		
		let s: 			GridState = self.gridState
		
		// Get new row index
		let ri: 		Int = s.lastBlockRowIndex + 1
		
		// bottomRightMargin
		let brmbc:		BlockCoord = BlockCoord()
		brmbc.column 	= s.lastBlockColumnIndex
		brmbc.row 		= ri
		
		// Go through each column
		for ci in s.firstBlockColumnIndex...s.lastBlockColumnIndex {
			
			self.doPresentGridBlockView(columnIndex: ci, rowIndex: ri, fillCells: fillCells)
			
		}
		
		// Set layout properties
		GridScapeHelper.calculateBlockLayoutProperties(topLeftMarginBlockCoord: nil,
													   bottomRightMarginBlockCoord: brmbc,
													   gridProperties: self.gridProperties,
													   gridState: self.gridState)
		
		let fromBlockCoord: 	BlockCoord = BlockCoord()
		fromBlockCoord.column 	= s.firstBlockColumnIndex
		fromBlockCoord.row 		= ri
		
		let toBlockCoord: 		BlockCoord = BlockCoord()
		toBlockCoord.column 	= s.lastBlockColumnIndex
		toBlockCoord.row 		= ri
		
		let result:				CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: fromBlockCoord, gridProperties: self.gridProperties)
		result.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: toBlockCoord, gridProperties: self.gridProperties))
		
		return result
		
	}
	
	fileprivate func addRowsUpToTopMargin(buildProperties: GridBuildProperties, fillCells: Bool) -> CellCoordRange? {
		
		var result: 	CellCoordRange? = nil
		
		let s: 			GridState = self.gridState
		
		// Get blockCoords
		let tlmbc: 		BlockCoord = buildProperties.topLeftMarginBlockCoord!
		let brmbc: 		BlockCoord = buildProperties.bottomRightMarginBlockCoord!
		
		if (s.firstBlockRowIndex > tlmbc.row) {
			
			let fromBlockCoord: 	BlockCoord = BlockCoord()
			fromBlockCoord.column 	= tlmbc.column
			fromBlockCoord.row 		= tlmbc.row
			
			let toBlockCoord: 		BlockCoord = BlockCoord()
			toBlockCoord.column 	= brmbc.column
			toBlockCoord.row 		= s.firstBlockRowIndex - 1
			
			result = GridScapeHelper.toCellCoordRange(fromBlockCoord: fromBlockCoord, gridProperties: self.gridProperties)
			result!.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: toBlockCoord, gridProperties: self.gridProperties))
			
			// Check cellCoords for grid size
			GridScapeHelper.checkGridSizeCellCoordRange(cellCoordRange: result!, gridProperties: self.gridProperties)
			
			// Go through each row
			for ri in (tlmbc.row...(s.firstBlockRowIndex - 1)).reversed() {
				
				// Go through each column
				for ci in tlmbc.column...brmbc.column {
					
					self.doPresentGridBlockView(columnIndex: ci, rowIndex: ri, fillCells: fillCells)
					
				}
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func addRowsUpToBottomMargin(buildProperties: GridBuildProperties, fillCells: Bool) -> CellCoordRange? {
		
		var result: 	CellCoordRange? = nil
		
		let s: 			GridState = self.gridState
		
		// Get blockCoords
		let tlmbc: 		BlockCoord = buildProperties.topLeftMarginBlockCoord!
		let brmbc: 		BlockCoord = buildProperties.bottomRightMarginBlockCoord!
		
		if (s.lastBlockRowIndex < brmbc.row) {
			
			let fromBlockCoord: 	BlockCoord = BlockCoord()
			fromBlockCoord.column 	= tlmbc.column
			fromBlockCoord.row 		= s.lastBlockRowIndex + 1
			
			let toBlockCoord: 		BlockCoord = BlockCoord()
			toBlockCoord.column 	= brmbc.column
			toBlockCoord.row 		= brmbc.row
			
			result = GridScapeHelper.toCellCoordRange(fromBlockCoord: fromBlockCoord, gridProperties: self.gridProperties)
			result!.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: toBlockCoord, gridProperties: self.gridProperties))
			
			// Check cellCoords for grid size
			GridScapeHelper.checkGridSizeCellCoordRange(cellCoordRange: result!, gridProperties: self.gridProperties)
			
			// Go through each row
			for ri in (s.lastBlockRowIndex + 1)...brmbc.row {
				
				// Go through each column
				for ci in tlmbc.column...brmbc.column {
					
					self.doPresentGridBlockView(columnIndex: ci, rowIndex: ri, fillCells: fillCells)
					
				}
				
			}
			
		}
		
		return result
		
	}
	
	fileprivate func removeRowsOutsideTopMargin(buildProperties: GridBuildProperties) -> CellCoordRange? {
		
		var result:					CellCoordRange? = nil
		
		let actualFirstRowIndex: 	Int = self.gridState.firstBlockRowIndex
		let requiredFirstRowIndex: 	Int = buildProperties.topLeftMarginBlockCoord!.row
		
		if (actualFirstRowIndex < requiredFirstRowIndex) {
			
			// Remove rows outside top margin
			result = self.removeRowsFrom(fromIndex: actualFirstRowIndex, toIndex: requiredFirstRowIndex - 1)
			
		}
		
		return result
		
	}
	
	fileprivate func removeRowsOutsideBottomMargin(buildProperties: GridBuildProperties) -> CellCoordRange? {
		
		var result:					CellCoordRange? = nil
		
		let actualLastRowIndex: 	Int = self.gridState.lastBlockRowIndex
		let requiredLastRowIndex: 	Int = buildProperties.bottomRightMarginBlockCoord!.row
		
		if (actualLastRowIndex > requiredLastRowIndex) {
			
			// Remove rows outside bottom margin
			result = self.removeRowsFrom(fromIndex: requiredLastRowIndex + 1, toIndex: actualLastRowIndex)
			
		}
		
		return result
		
	}

	fileprivate func removeRowsFrom(fromIndex: Int) -> CellCoordRange {
		
		let result: CellCoordRange = self.removeRowsFrom(fromIndex: fromIndex, toIndex: self.gridState.lastBlockRowIndex)
		
		return result
		
	}
	
	fileprivate func removeRowsFrom(fromIndex: Int, toIndex: Int) -> CellCoordRange {
		
		let s: 			GridState = self.gridState
		
		// Create blockCoords
		// topLeft
		let tlbc:		BlockCoord = BlockCoord()
		tlbc.column 	= s.firstBlockColumnIndex
		tlbc.row 		= fromIndex
		
		// bottomRight
		let brbc:		BlockCoord = BlockCoord()
		brbc.column 	= s.lastBlockColumnIndex
		brbc.row 		= toIndex
		
		// Get cellCoordRange
		let result:		CellCoordRange = GridScapeHelper.toCellCoordRange(fromBlockCoord: tlbc, gridProperties: self.gridProperties)
		result.add(range: GridScapeHelper.toCellCoordRange(fromBlockCoord: brbc, gridProperties: self.gridProperties))
		
		// Remove rows
		self.doRemoveRows(fromIndex: fromIndex, toIndex: toIndex)
		
		return result
		
	}
	
	fileprivate func doRemoveRows(fromIndex: Int, toIndex: Int) {
		
		guard (self.gridState.numberofRows > 0) else { return }
		
		guard (fromIndex == self.gridState.firstBlockRowIndex
			|| toIndex == self.gridState.lastBlockRowIndex) else { return }
		
		let s: 			GridState = self.gridState
		
		// Go through each row
		for ri in fromIndex...toIndex {
			
			// Go through each column
			for ci in s.firstBlockColumnIndex...s.lastBlockColumnIndex {
				
				let blockCoord: 	BlockCoord = BlockCoord()
				blockCoord.column 	= ci
				blockCoord.row 		= ri
				
				// Get blockView
				let blockView: 		GridBlockView? = self.get(gridBlockView: blockCoord)
				
				if (blockView != nil) {
					
					// hide blockView
					self.hideGridBlockView(blockView: blockView!)
					
				}
				
			}
			
		}
		
	}
	
	fileprivate func doRemoveRows(fromIndex: Int) {
		
		guard (self.gridState.numberofRows > 0
			&& fromIndex <= self.gridState.lastBlockRowIndex) else { return }
		
		self.doRemoveRows(fromIndex: fromIndex, toIndex: self.gridState.lastBlockRowIndex)
		
	}

	
	// MARK: - Private Methods; Paths
	
	fileprivate func get(tokenView cellCoord: CellCoord, toMoveAlongPath sender: GridScapeManager, oncomplete completionHandler:@escaping (ProtocolGridTokenView?, Error?) -> Void) {
		
		// Get tokenView
		let tokenView: ProtocolGridTokenView? = self.get(tokenView: nil, at: cellCoord)
		
		if (tokenView != nil) {
			
			// Call the completion handler
			completionHandler(tokenView, nil)
			
			return
			
		}
		
		// Create completion handler
		let tokenViewForItemAtCompletionHandler: ((ProtocolGridTokenView?, Error?) -> Void) =
		{
			(tokenView, error) -> Void in
			
			// Call the completion handler
			completionHandler(tokenView, error)
			
		}
		
		// Get tokenView from delegate
		self.delegate!.gridScapeManager(gridScapeView: self.gridScapeView!, tokenViewForItemAt: cellCoord, key: nil, completionHandler: tokenViewForItemAtCompletionHandler)
		
	}
	
	fileprivate func move(tokenFrom fromCellCoord: CellCoord, alongPath pathWrapper: PathWrapperBase, getTokenView sender: GridScapeManager, oncomplete completionHandler:@escaping (PathWrapperBase, Error?) -> Void) {
		
		var fromTokenView: 	ProtocolGridTokenView? = nil
		
		// Create completion handler
		let moveBuildProcessMovePathPointWrappersCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			if (fromTokenView != nil && error == nil) {
				
				// Get toCellCoord
				let toCellCoord: CellCoord = pathWrapper.current!.cellCoord
				
				// Notify the delegate
				self.delegate!.gridScapeManager(tokenMoved: fromTokenView!, from: fromCellCoord, to: toCellCoord)
				
			}
			
			// Call the completion handler
			completionHandler(pathWrapper, error)
			
		}
		
		// Create completion handler
		let getTokenViewCompletionHandler: ((ProtocolGridTokenView?, Error?) -> Void) =
		{
			(tokenView, error) -> Void in
			
			guard (tokenView != nil && error == nil) else {
				
				// Call the completion handler
				completionHandler(pathWrapper, NSError())
				return
				
			}
			
			fromTokenView = tokenView
			
			// Move buildProcessMovePathPointWrappers
			self.move(token: fromTokenView!, alongPath: pathWrapper, buildProcessMovePathPointWrappers: self, oncomplete: moveBuildProcessMovePathPointWrappersCompletionHandler)
			
		}
		
		// Get tokenView
		self.get(tokenView: fromCellCoord, toMoveAlongPath: self, oncomplete: getTokenViewCompletionHandler)
		
	}
	
	fileprivate func move(token fromTokenView: ProtocolGridTokenView, alongPath pathWrapper: PathWrapperBase, buildProcessMovePathPointWrappers sender: GridScapeManager, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Create processMovePathPointWrappers
		var processMovePathPointWrappers: 			[String:ProcessMovePathPointWrapper] = [String:ProcessMovePathPointWrapper]()
		
		// Nb: The pathCellCoords should include the tokenView's current cellCoord and final cellCoord.
		
		// Get pathPointWrappers
		let pathPointWrappers: 						[PathPointWrapperBase] = pathWrapper.getPointsByIndex()
		
		// Go through each item
		for ppw in pathPointWrappers {
			
			// Create ProcessMovePathPointWrapper
			let wrapper: 							ProcessMovePathPointWrapper = ProcessMovePathPointWrapper()
			
			wrapper.pathPointWrapper 				= ppw
			
			processMovePathPointWrappers[ppw.id] 	= wrapper
			
		}
		
		// Set originCellCoord
		if (pathWrapper.originCellCoord == nil) {
			
			pathWrapper.originCellCoord = fromTokenView.gridTokenProperties!.cellCoord
			
		}
		
		// Set path
		pathWrapper.setFirst()
		
		if (!pathWrapper.originCellCoord!.equals(cellCoord: pathWrapper.first!.cellCoord)) {
			
			let start: 			PathPointWrapperBase = PathPointWrapperBase()
			start.id 			= UUID().uuidString
			start.column 		= pathWrapper.originCellCoord!.column
			start.row 			= pathWrapper.originCellCoord!.row
			start.pathID 		= pathWrapper.id
			
			pathWrapper.start 	= start
			
			// Create ProcessMovePathPointWrapper
			let wrapper: 							ProcessMovePathPointWrapper = ProcessMovePathPointWrapper()
			
			wrapper.pathPointWrapper 				= pathWrapper.start
			
			processMovePathPointWrappers[start.id] 	= wrapper
			
		}
		
		guard (processMovePathPointWrappers.count > 1) else {
			
			// Call the completion handler
			completionHandler(nil)
			
			return
			
		}
		
		// Create completion handler
		let moveProcessPointWrappersCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			let s: String = JSONHelper.SerializeDataJSONWrapper(dataWrapper: pathWrapper.pathLogWrapper.wrapper) ?? ""
			print(s)
			
			// Call the completion handler
			completionHandler(error)
			
		}
		
		// Create completion handler
		let doBeforeStartMovingAlongPathCompletionHandler: ((MoveAlongPathResponseTypes, Error?) -> Void) =
		{
			(response, error) -> Void in
			
			guard (error == nil) else {
				
				// Call the completion handler
				completionHandler(error)
				
				return
				
			}
			
			if (response == .Continue) {
				
				// Move processPointWrappers
				self.move(tokenView: fromTokenView, pathWrapper: pathWrapper, processMovePathPointWrappers: processMovePathPointWrappers, processPointWrappers: self, oncomplete: moveProcessPointWrappersCompletionHandler)
				
			} else {
				
				// Set pathWrapper properties
				pathWrapper.status = .Suspended
				
				// Call the completion handler
				completionHandler(error)
				
			}
			
		}
		
		// Check log
		if (!pathWrapper.pathLogWrapper.hasLogged(key: .DoneDoBeforeStartMovingAlongPath)) {
			
			// Before start moving along path
			self.doBeforeStartMoving(token: fromTokenView, alongPath: pathWrapper, oncomplete: doBeforeStartMovingAlongPathCompletionHandler)
			
		} else {
			
			// Move processPointWrappers
			self.move(tokenView: fromTokenView, pathWrapper: pathWrapper, processMovePathPointWrappers: processMovePathPointWrappers, processPointWrappers: self, oncomplete: moveProcessPointWrappersCompletionHandler)
			
		}
		
	}
	
	fileprivate func move(tokenView: ProtocolGridTokenView, pathWrapper: PathWrapperBase, processMovePathPointWrappers: [String:ProcessMovePathPointWrapper], processPointWrappers sender: GridScapeManager, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get fromPointWrapper
		var fromPointWrapper: 		ProcessMovePathPointWrapper? = nil
		
		// Nb: The first call to this method the currentPathPointIndex is 0 and the current processMovePathPointWrapper didMoveToYN is false
		
		// Check currentPathPointIndex and current didMoveToYN
		if (pathWrapper.currentPathPointIndex == 0 && !processMovePathPointWrappers[pathWrapper.current!.id]!.didMoveToYN) {
			
			fromPointWrapper 		= processMovePathPointWrappers[pathWrapper.start!.id]
			
		} else {
			
			fromPointWrapper 		= processMovePathPointWrappers[pathWrapper.current!.id]
			
		}
		
		// Check cellCoord of fromPointWrapper and current
		if (fromPointWrapper!.pathPointWrapper!.cellCoord.equals(cellCoord: pathWrapper.current!.cellCoord)) {
			
			// Set next
			pathWrapper.setNext()
			
			// Log
			pathWrapper.pathLogWrapper.log(key: .DoneSetNext, pathPointWrapperID: pathWrapper.current!.id)
			
		}
		
		// Get toPointWrapper
		let toPointWrapper: 		ProcessMovePathPointWrapper? = processMovePathPointWrappers[pathWrapper.current!.id]
		
		// Get nextToPointWrapper
		let nextToPointWrapper: 	ProcessMovePathPointWrapper? = (pathWrapper.next != nil) ? processMovePathPointWrappers[pathWrapper.next!.id] : nil
		
		// Create completion handler
		let continueCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			guard (error == nil) else {
				
				// Call completion handler
				completionHandler(error)
				
				return
				
			}
			
			guard (pathWrapper.next != nil) else {
				
				// Call completion handler
				completionHandler(error)
				
				return
				
			}
			
			// Move processPointWrappers
			self.move(tokenView: tokenView, pathWrapper: pathWrapper, processMovePathPointWrappers: processMovePathPointWrappers, processPointWrappers: self, oncomplete: completionHandler)
			
		}
		
		// Create completion handler
		let suspendedCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Set pathWrapper properties
			pathWrapper.status = .Suspended
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		// Create completion handler
		let doAfterFinishedMovingAlongPathCompletionHandler: ((MoveAlongPathResponseTypes, Error?) -> Void) =
		{
			(response, error) -> Void in
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		// Create completion handler
		let finishedCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			guard (error == nil) else {
				
				// Call completion handler
				completionHandler(error)
				
				return
				
			}
			
			// Set pathWrapper properties
			pathWrapper.status = .Finished
			
			// After finished moving along path
			self.doAfterFinishedMovingAlongPath(tokenMoving: tokenView, pathWrapper: pathWrapper, oncomplete: doAfterFinishedMovingAlongPathCompletionHandler)
			
		}
		
		// Move setGridPositionBeforeProcessMove
		self.move(tokenView: tokenView, pathWrapper: pathWrapper, processMovePathPointWrappers: processMovePathPointWrappers, fromPointWrapper: fromPointWrapper!, toPointWrapper: toPointWrapper!, nextToPointWrapper: nextToPointWrapper, setGridPositionBeforeProcessMove: self, oncontinue: continueCompletionHandler, onsuspended: suspendedCompletionHandler, onfinished: finishedCompletionHandler)
		
	}
	
	fileprivate func move(tokenView: ProtocolGridTokenView, pathWrapper: PathWrapperBase, processMovePathPointWrappers: [String:ProcessMovePathPointWrapper], fromPointWrapper: ProcessMovePathPointWrapper, toPointWrapper: ProcessMovePathPointWrapper, nextToPointWrapper: ProcessMovePathPointWrapper?, setGridPositionBeforeProcessMove sender: GridScapeManager, oncontinue continueCompletionHandler:@escaping (Error?) -> Void, onsuspended suspendedCompletionHandler:@escaping (Error?) -> Void, onfinished finishedCompletionHandler:@escaping (Error?) -> Void) {
		
		let gs:		GridState = self.gridState
		let gp: 	GridProperties = self.gridProperties
		
		// Create completion handler
		let setGridPositionAtCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Move beforeMovePoint
			self.move(tokenView: tokenView, pathWrapper: pathWrapper, processMovePathPointWrappers: processMovePathPointWrappers, fromPointWrapper: fromPointWrapper, toPointWrapper: toPointWrapper, nextToPointWrapper: nextToPointWrapper, beforeMovePoint: self, oncontinue: continueCompletionHandler, onsuspended: suspendedCompletionHandler, onfinished: finishedCompletionHandler)
			
		}
		
		// Get isToOffScreenYN
		let isToOffScreenYN: Bool = GridScapeHelper.isOffScreenYN(cellCoord: toPointWrapper.pathPointWrapper!.cellCoord, gridState: gs, gridProperties: gp)
		
		if (isToOffScreenYN && gp.setGridPositionBeforeMoveTokenAlongPathYN) {
			
			// Set grid position
			self.set(gridPositionAt: toPointWrapper.pathPointWrapper!.cellCoord, animateYN: true, oncomplete: setGridPositionAtCompletionHandler)
			
		} else {
			
			// Move beforeMovePoint
			self.move(tokenView: tokenView, pathWrapper: pathWrapper, processMovePathPointWrappers: processMovePathPointWrappers, fromPointWrapper: fromPointWrapper, toPointWrapper: toPointWrapper, nextToPointWrapper: nextToPointWrapper, beforeMovePoint: self, oncontinue: continueCompletionHandler, onsuspended: suspendedCompletionHandler, onfinished: finishedCompletionHandler)
			
		}
		
	}
	
	fileprivate func move(tokenView: ProtocolGridTokenView, pathWrapper: PathWrapperBase, processMovePathPointWrappers: [String:ProcessMovePathPointWrapper], fromPointWrapper: ProcessMovePathPointWrapper, toPointWrapper: ProcessMovePathPointWrapper, nextToPointWrapper: ProcessMovePathPointWrapper?, beforeMovePoint sender: GridScapeManager, oncontinue continueCompletionHandler:@escaping (Error?) -> Void, onsuspended suspendedCompletionHandler:@escaping (Error?) -> Void, onfinished finishedCompletionHandler:@escaping (Error?) -> Void) {
		
		// Create completion handler
		let doBeforeMovePointCompletionHandler: ((MoveAlongPathResponseTypes, Error?) -> Void) =
		{
			(response, error) -> Void in
			
			guard (error == nil) else {
				
				// Call the completion handler
				finishedCompletionHandler(error)
				
				return
				
			}
			
			if (response == .Continue) {
				
				DispatchQueue.main.async {
				
					// Move processMove
					self.move(tokenView: tokenView, pathWrapper: pathWrapper, processMovePathPointWrappers: processMovePathPointWrappers, fromPointWrapper: fromPointWrapper, toPointWrapper: toPointWrapper, nextToPointWrapper: nextToPointWrapper, processMove: self, oncontinue: continueCompletionHandler, onsuspended: suspendedCompletionHandler, onfinished: finishedCompletionHandler)
					
				}
				
			} else {
				
				// Call the completion handler
				suspendedCompletionHandler(nil)
				
			}
			
		}
		
		// Check log
		if (!pathWrapper.pathLogWrapper.hasLogged(key: .DoneDoBeforeMovePoint, pathPointWrapperID: toPointWrapper.pathPointWrapper!.id)) {
			
			// Before move
			self.doBeforeMovePoint(tokenMoving: tokenView, pathWrapper: pathWrapper, fromPointWrapper: fromPointWrapper, toPointWrapper: toPointWrapper, oncomplete: doBeforeMovePointCompletionHandler)
			
		} else {
			
			DispatchQueue.main.async {
				
				// Move processMove
				self.move(tokenView: tokenView, pathWrapper: pathWrapper, processMovePathPointWrappers: processMovePathPointWrappers, fromPointWrapper: fromPointWrapper, toPointWrapper: toPointWrapper, nextToPointWrapper: nextToPointWrapper, processMove: self, oncontinue: continueCompletionHandler, onsuspended: suspendedCompletionHandler, onfinished: finishedCompletionHandler)
				
			}
			
		}
		
	}
	
	fileprivate func move(tokenView: ProtocolGridTokenView, pathWrapper: PathWrapperBase, processMovePathPointWrappers: [String:ProcessMovePathPointWrapper], fromPointWrapper: ProcessMovePathPointWrapper, toPointWrapper: ProcessMovePathPointWrapper, nextToPointWrapper: ProcessMovePathPointWrapper?, processMove sender: GridScapeManager, oncontinue continueCompletionHandler:@escaping (Error?) -> Void, onsuspended suspendedCompletionHandler:@escaping (Error?) -> Void, onfinished finishedCompletionHandler:@escaping (Error?) -> Void) {
		
		// Get fromPointWrapper cellView
		if (fromPointWrapper.cellView == nil) {
			
			fromPointWrapper.cellView		= self.get(cellView: fromPointWrapper.pathPointWrapper!.cellCoord)
			
		}
		
		// Get toPointWrapper cellView
		if (toPointWrapper.cellView == nil) {
			
			toPointWrapper.cellView			= self.get(cellView: toPointWrapper.pathPointWrapper!.cellCoord)
			
		}
		
		// Get nextToPointWrapper cellView
		if (nextToPointWrapper != nil) {
			
			nextToPointWrapper!.cellView	= self.get(cellView: nextToPointWrapper!.pathPointWrapper!.cellCoord)
			
		}
		
		// Create completion handler
		let doAfterMovePointCompletionHandler: ((MoveAlongPathResponseTypes, Error?) -> Void) =
		{
			(response, error) -> Void in
			
			guard (error == nil) else {
				
				// Call the completion handler
				finishedCompletionHandler(error)
				
				return
				
			}
			
			if (response != .Continue) {
				
				// Call the completion handler
				suspendedCompletionHandler(nil)
				
				return
				
			}
			
			if (nextToPointWrapper != nil) {
				
				// Call completion handler
				continueCompletionHandler(nil)
				
			} else {
				
				// Call completion handler
				finishedCompletionHandler(nil)
				
			}
			
		}
		
		// Create completion handler
		let moveDoMoveTokenCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Set toPointWrapper properties
			toPointWrapper.didMoveToYN = true
			
			// Log
			pathWrapper.pathLogWrapper.log(key: .DoneDoMovePoint, pathPointWrapperID: toPointWrapper.pathPointWrapper!.id)
			
			// After move
			self.doAfterMovePoint(tokenMoving: tokenView, pathWrapper: pathWrapper, fromPointWrapper: fromPointWrapper, toPointWrapper: toPointWrapper, oncomplete: doAfterMovePointCompletionHandler)
			
		}
		
		// Check log
		if (!pathWrapper.pathLogWrapper.hasLogged(key: .DoneDoMovePoint, pathPointWrapperID: toPointWrapper.pathPointWrapper!.id)) {
			
			// Move doMoveToken
			self.move(token: tokenView, alongPathFrom: fromPointWrapper.cellView!, toCellView: toPointWrapper.cellView!, doMoveToken: self, oncomplete: moveDoMoveTokenCompletionHandler)
			
			return
			
		}
		
		// Check log
		if (!pathWrapper.pathLogWrapper.hasLogged(key: .DoneDoAfterMovePoint, pathPointWrapperID: toPointWrapper.pathPointWrapper!.id)) {
			
			// After move
			self.doAfterMovePoint(tokenMoving: tokenView, pathWrapper: pathWrapper, fromPointWrapper: fromPointWrapper, toPointWrapper: toPointWrapper, oncomplete: doAfterMovePointCompletionHandler)
			
			return
			
		}
		
		// Call completion handler
		continueCompletionHandler(nil)
		
	}
	
	fileprivate func doBeforeStartMoving(token tokenView: ProtocolGridTokenView, alongPath pathWrapper: PathWrapperBase, oncomplete completionHandler:@escaping (MoveAlongPathResponseTypes, Error?) -> Void) {
		
		// Log
		pathWrapper.pathLogWrapper.log(key: .DoneDoBeforeStartMovingAlongPath)
		
		// Notify the delegate
		self.delegate!.gridScapeManager(tokenMoving: tokenView, alongPath: pathWrapper, doBeforeStartMovingAlongPath: self, completionHandler: completionHandler)
		
	}
	
	fileprivate func doBeforeMovePoint(tokenMoving tokenView: ProtocolGridTokenView, pathWrapper: PathWrapperBase, fromPointWrapper: ProcessMovePathPointWrapper, toPointWrapper: ProcessMovePathPointWrapper, oncomplete completionHandler:@escaping (MoveAlongPathResponseTypes, Error?) -> Void) {
		
		// Log
		pathWrapper.pathLogWrapper.log(key: .DoneDoBeforeMovePoint, pathPointWrapperID: toPointWrapper.pathPointWrapper!.id)
		
		// Notify the delegate
		self.delegate!.gridScapeManager(tokenMoving: tokenView, alongPath: pathWrapper, from: fromPointWrapper.pathPointWrapper!, to: toPointWrapper.pathPointWrapper!, doBeforeMovePoint: self, completionHandler: completionHandler)
		
	}
	
	fileprivate func doAfterMovePoint(tokenMoving tokenView: ProtocolGridTokenView, pathWrapper: PathWrapperBase, fromPointWrapper: ProcessMovePathPointWrapper, toPointWrapper: ProcessMovePathPointWrapper, oncomplete completionHandler:@escaping (MoveAlongPathResponseTypes, Error?) -> Void) {
		
		// Log
		pathWrapper.pathLogWrapper.log(key: .DoneDoAfterMovePoint, pathPointWrapperID: toPointWrapper.pathPointWrapper!.id)
		
		// Notify the delegate
		self.delegate!.gridScapeManager(tokenMoving: tokenView, alongPath: pathWrapper, from: fromPointWrapper.pathPointWrapper!, to: toPointWrapper.pathPointWrapper!, doAfterMovePoint: self, completionHandler: completionHandler)
		
	}
	
	fileprivate func doAfterFinishedMovingAlongPath(tokenMoving tokenView: ProtocolGridTokenView, pathWrapper: PathWrapperBase, oncomplete completionHandler:@escaping (MoveAlongPathResponseTypes, Error?) -> Void) {
		
		// Log
		pathWrapper.pathLogWrapper.log(key: .DoneDoAfterFinishedMovingAlongPath)
		
		// Notify the delegate
		self.delegate!.gridScapeManager(tokenMoving: tokenView, alongPath: pathWrapper, doAfterFinishedMovingAlongPath: self, completionHandler: completionHandler)
		
	}
	
	fileprivate func move(token tokenView: ProtocolGridTokenView, alongPathFrom fromCellView: ProtocolGridCellView, toCellView: ProtocolGridCellView, doMoveToken sender: GridScapeManager, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let fromCellCoord:		CellCoord = tokenView.gridTokenProperties!.cellCoord!
		
		// Get toCellCoord
		let toCellCoord: 		CellCoord = toCellView.gridCellProperties!.cellCoord!
		
		// Do before reposition
		self.moveTokenDoBeforeReposition(tokenView: tokenView, fromCellCoord: fromCellCoord, fromCellView: fromCellView, toCellCoord: toCellCoord)
		
		// Create completion handler
		let repositionTokenViewCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			if (error == nil) {
				
				// Do after reposition
				self.moveTokenDoAfterReposition(tokenView: tokenView, fromCellCoord: fromCellCoord, toCellView: toCellView, toCellCoord: toCellCoord, notifyDelegateYN: false)
				
			}
			
			// Call the completion handler
			completionHandler(error)
			
		}
		
		// Reposition tokenView
		self.gridScapeView!.reposition(token: tokenView, from: fromCellCoord, fromCellView: fromCellView, to: toCellCoord, toCellView: toCellView, oncomplete: repositionTokenViewCompletionHandler)
		
	}

}

// MARK: - Extension ProtocolGridScapeViewDelegate

extension GridScapeManager: ProtocolGridScapeViewDelegate {
	
	// MARK: - Public Methods
	
	public func gridScapeView(touchesBegan gridScapeView: ProtocolGridScapeView) {
		
		// Notify the delegate
		self.delegate?.gridScapeManager(touchesBegan: self, on: gridScapeView as? UIView)
		
	}
	
	public func gridScapeView(for gesture: UITapGestureRecognizer, tapped indicatedPoint: CGPoint) {
		
		let truePoint: 	CGPoint = GridScapeHelper.toTrue(fromIndicated: indicatedPoint, gridState: self.gridState)
		let cellCoord: 	CellCoord = GridScapeHelper.toCellCoord(fromTrue: truePoint, gridProperties: self.gridProperties)
		
		// Notify the delegate
		self.delegate?.gridScapeManager(tapped: indicatedPoint, cellCoord: cellCoord)
		
		self.doAfterTapped(for: gesture, tapped: indicatedPoint, cellCoord: cellCoord)
		
	}

	public func gridScapeView(for gesture: UILongPressGestureRecognizer, longPressed indicatedPoint: CGPoint) {
		
		let truePoint: 	CGPoint = GridScapeHelper.toTrue(fromIndicated: indicatedPoint, gridState: self.gridState)
		let cellCoord: 	CellCoord = GridScapeHelper.toCellCoord(fromTrue: truePoint, gridProperties: self.gridProperties)
		
		// Get cellView
		let cellView: 	ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (cellView != nil) else { return }
		
		// Check tokenView
		let tokenView: 	ProtocolGridTokenView? = self.checkLongPressedTokenView(gesture: gesture, indicatedPoint: indicatedPoint, cellView: cellView!)
		
		if (tokenView != nil) { return }
		
		// Check tileView
		let tileView: 	ProtocolGridTileView? = self.checkLongPressedTileView(gesture: gesture, indicatedPoint: indicatedPoint, cellView: cellView!)
		
		if (tileView != nil) { return }
		
		// Check cellView
		let _ = self.checkLongPressedCellView(gesture: gesture, indicatedPoint: indicatedPoint, cellView: cellView!)

	}
	
	public func gridScapeView(for gesture:UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes) {
		
		// Set gridScrollState
		self.gridState.gridScrollState = GridScrollState()
		
		// Set marginFrame properties
		self.gridState.gridScrollState!.setMarginFrameProperties(marginFrame: self.gridState.marginFrame!, attributes: attributes)
		
		// Notify the delegate
		self.delegate?.gridScapeManager(scrollingBegan: self)
		
	}
	
	public func gridScapeView(for gesture:UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes) {

		let s: 		GridState = self.gridState
		let gss: 	GridScrollState = s.gridScrollState!
		
		// Set marginFrame properties
		gss.setMarginFrameProperties(marginFrame: s.marginFrame!, attributes: attributes)
		
		// Check grid limits
		gss.checkGridLimits(gridProperties: self.gridProperties, gridState: s, attributes: attributes)
		
		// Apply transform to blockViews
		for v in self.blockViews.values {
			v.transform = self.gridState.indicatedOffsetTransform.concatenating(attributes.transform!)
		}
		
		// Check not isBuildingBlocksYN
		//guard (!self.gridState.isBuildingBlocksYN) else { return }
		
		//self.set(isBuildingBlocksYN: true, notifyDelegate: false)

		self.rebuildAfterPanningContinued(gridScrollState: gss)

		//self.set(isBuildingBlocksYN: false, notifyDelegate: false)
		
		self.gridScapeView!.displayPanProperties(gridState: self.gridState)
		self.gridScapeView!.displayBlocksProperties(numberofBlocks: self.blockViews.count, gridState: self.gridState)
		
	}
	
	public func gridScapeView(for gesture:UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes) {
		
	}
	
	public func gridScapeView(for gesture:UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes) {
		
	}
	
	public func gridScapeView(for gesture:UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes) {
		
		// Check grid limits
		self.gridState.gridScrollState!.checkGridLimits(gridProperties: self.gridProperties, gridState: self.gridState, attributes: attributes)
		
		let indicatedOffsetX: 			CGFloat = self.gridState.indicatedOffsetX + attributes.horizontalDistance
		let indicatedOffsetY: 			CGFloat = self.gridState.indicatedOffsetY + attributes.verticalDistance
		let indicatedOffsetTransform: 	CGAffineTransform = self.gridState.indicatedOffsetTransform.concatenating(attributes.transform!)
		
		// Set gridScape indicatedOffset
		self.doSetGridScapeIndicatedOffset(indicatedOffsetX: indicatedOffsetX,
										   indicatedOffsetY: indicatedOffsetY,
										   indicatedOffsetTransform: indicatedOffsetTransform)
		
		DispatchQueue.main.async {
			
			self.rebuildAfterPanningStopped()
			
		}
		
		let fromIndicated: 		CGPoint = CGPoint(x: indicatedOffsetX, y: indicatedOffsetY)
		
		// Convert to indicatedPoint for current gridPositionReferenceToType. Nb: We need to do this as we are going back through a public method
		let indicatedPoint: 	CGPoint = GridScapeHelper.toIndicated(toReferenceToType: self.gridProperties.gridPositionReferenceToType, fromIndicated: fromIndicated, gridProperties: self.gridProperties)
		
		// Nb: As this is a public delegate method, expects indicatedOffsetX and indicatedOffsetY referenced to current gridPositionReferenceToType
		// Notify the delegate
		self.delegate?.gridScapeManager(scrolled: self, indicatedOffsetX: indicatedPoint.x, indicatedOffsetY: indicatedPoint.y)
		
		self.gridState.gridScrollState = nil
		
	}
	
	public func gridScapeView(sender: GridScapeView, cellForItemAt cellCoord: CellCoord) -> ProtocolGridCellView? {
		
		// Get cellView
		let result: ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		return result
		
	}

	public func gridScapeView(sender: GridScapeView, canDrag cellView: ProtocolGridCellView) -> Bool {
		
		return cellView.gridCellProperties?.canDragYN ?? true
		
	}
	
	public func gridScapeView(sender: GridScapeView, draggingStarted cellView: ProtocolGridCellView) {

	}
	
	public func gridScapeView(sender: GridScapeView, draggingCancelled cellView: ProtocolGridCellView) {

	}
	
	public func gridScapeView(sender: GridScapeView, canDrop cellView: ProtocolGridCellView, at cellCoord: CellCoord) -> Bool {
		
		var result: Bool = true
		
		// Check cellView exists at cellCoord
		let cv: ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (cv == nil) else { return false }

		// Check canDrop
		result = self.canDrop(cellView: cellView, at: cellCoord)

		return result
		
	}
	
	public func gridScapeView(sender: GridScapeView, didDrop cellView: ProtocolGridCellView, at cellCoord: CellCoord) {

		DispatchQueue.main.async {
			
			// Move cellView
			self.move(cell: cellView, to: cellCoord)
			
		}
		
	}

	public func gridScapeView(sender: GridScapeView, canDrag tileView: ProtocolGridTileView) -> Bool {
		
		return tileView.gridTileProperties?.canDragYN ?? true
		
	}
	
	public func gridScapeView(sender: GridScapeView, draggingStarted tileView: ProtocolGridTileView) {
		
	}
	
	public func gridScapeView(sender: GridScapeView, draggingCancelled tileView: ProtocolGridTileView) {
		
	}
	
	public func gridScapeView(sender: GridScapeView, canDrop tileView: ProtocolGridTileView, at cellCoord: CellCoord) -> Bool {
		
		var result: Bool = true
		
		// Check cellView exists at cellCoord
		let cv: ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (cv != nil) else { return false }
		
		// Check canDrop
		result = self.canDrop(tileView: tileView, at: cellCoord)
		
		return result
		
	}
	
	public func gridScapeView(sender: GridScapeView, didDrop tileView: ProtocolGridTileView, at cellCoord: CellCoord) {
	
		DispatchQueue.main.async {
			
			// Move tileView
			self.move(tile: tileView, to: cellCoord)
			
		}
		
	}

	public func gridScapeView(sender: GridScapeView, canDrag tokenView: ProtocolGridTokenView) -> Bool {
		
		return tokenView.gridTokenProperties?.canDragYN ?? true
		
	}
	
	public func gridScapeView(sender: GridScapeView, draggingStarted tokenView: ProtocolGridTokenView) {
		
	}
	
	public func gridScapeView(sender: GridScapeView, draggingCancelled tokenView: ProtocolGridTokenView) {
		
	}
	
	public func gridScapeView(sender: GridScapeView, canDrop tokenView: ProtocolGridTokenView, at cellCoord: CellCoord) -> Bool {
		
		var result: Bool = true
		
		// Check cellView exists at cellCoord
		let cv: ProtocolGridCellView? = self.get(cellView: cellCoord)
		
		guard (cv != nil) else { return false }
		
		// Check canDrop
		result = self.canDrop(tokenView: tokenView, at: cellCoord)
		
		return result
		
	}
	
	public func gridScapeView(sender: GridScapeView, didDrop tokenView: ProtocolGridTokenView, at cellCoord: CellCoord) {
		
		DispatchQueue.main.async {
			
			// Move tokenView
			self.move(token: tokenView, to: cellCoord)
			
		}
		
	}
	
}

// MARK: - Extension ProtocolGridCellViewDelegate

extension GridScapeManager: ProtocolGridCellViewDelegate {
	
	// MARK: - Public Methods
	
	public func gridCellView(propertyChanged wrapper: CellPropertyChangedWrapper, cellCoord: CellCoord, with cellView: ProtocolGridCellView?) {
		
		if (wrapper.type == .Attribute || wrapper.type == .SideAttribute) {
			
			// Index in cellAttributesIndex
			self.cellAttributesIndex.index(attribute: wrapper, cellView: cellView!)
			
		} else if (wrapper.type == .Property && wrapper.key.lowercased() == "rotationdegrees") {
			
			// Index in cellAttributesIndex
			self.cellAttributesIndex.index(sideAttributesAfterRotation: wrapper, cellView: cellView!)
			
		}
		
		// Notify the delegate
		self.delegate?.gridScapeManager(cellPropertyChanged: wrapper.key, cellCoord: cellCoord, with: cellView)
		
	}
	
	public func gridCellView(touchesBegan cellView: ProtocolGridCellView) {
	
		// Notify the delegate
		self.delegate?.gridScapeManager(touchesBegan: self, on: cellView as? UIView)
		
	}
	
	public func gridCellView(for gesture: UITapGestureRecognizer, tapped cellView: ProtocolGridCellView) {
		
		// Get indicatedPoint
		let indicatedPoint: 	CGPoint = self.gridScapeView!.get(locationOf: gesture)
		
		// Get cellCoord
		let cellCoord: 			CellCoord? = cellView.gridCellProperties?.cellCoord
		
		guard (cellCoord != nil) else { return }
		
		// Notify the delegate
		self.delegate?.gridScapeManager(tapped: cellView, at: indicatedPoint)
		
		self.doAfterTapped(for: gesture, tapped: indicatedPoint, cellCoord: cellCoord!)
		
	}
		
	public func gridCellView(getTileViewDelegate sender: ProtocolGridCellView) -> ProtocolGridTileViewDelegate? {
	
		return self
		
	}

	public func gridCellView(getTokenViewDelegate sender: ProtocolGridCellView) -> ProtocolGridTokenViewDelegate? {
		
		return self
		
	}
	
}

// MARK: - Extension ProtocolGridTileViewDelegate

extension GridScapeManager: ProtocolGridTileViewDelegate {
	
	// MARK: - Public Methods
	
	public func gridTileView(propertyChanged wrapper: CellPropertyChangedWrapper, cellCoord: CellCoord, with tileView: ProtocolGridTileView?) {
		
		// Notify the delegate
		self.delegate?.gridScapeManager(tilePropertyChanged: wrapper.key, cellCoord: cellCoord, with: tileView)
		
	}

	public func gridTileView(touchesBegan tileView: ProtocolGridTileView) {
		
		// Notify the delegate
		self.delegate?.gridScapeManager(touchesBegan: self, on: tileView as? UIView)
		
	}
	
	public func gridTileView(for gesture: UITapGestureRecognizer, tapped tileView: ProtocolGridTileView) {
		
		// Get indicatedPoint
		let indicatedPoint: 	CGPoint = self.gridScapeView!.get(locationOf: gesture)
		
		// Get cellCoord
		let cellCoord: 			CellCoord? = tileView.gridTileProperties?.cellCoord
		
		guard (cellCoord != nil) else { return }
		
		// Get cellView
		let cellView: 			ProtocolGridCellView? = self.get(cellView: cellCoord!)
		
		guard (cellView != nil) else { return }
		
		// Notify the delegate
		self.delegate?.gridScapeManager(tapped: tileView, cellView: cellView!, at: indicatedPoint)
		
		self.doAfterTapped(for: gesture, tapped: indicatedPoint, cellCoord: cellCoord!)
		
	}
	
	public func gridTileView(setPosition tileView: ProtocolGridTileView) {
		
		// Get cellCoord
		let cellCoord: 			CellCoord? = tileView.gridTileProperties?.cellCoord
		
		guard (cellCoord != nil) else { return }
		
		// Get cellView
		let cellView: 			ProtocolGridCellView? = self.get(cellView: cellCoord!)
		
		guard (cellView != nil) else { return }
		
		cellView!.setPosition(tileView: tileView)
		
	}
	
}

// MARK: - Extension ProtocolGridTokenViewDelegate

extension GridScapeManager: ProtocolGridTokenViewDelegate {
	
	// MARK: - Public Methods
	
	public func gridTokenView(propertyChanged wrapper: CellPropertyChangedWrapper, cellCoord: CellCoord, with tokenView: ProtocolGridTokenView?) {
		
		// Notify the delegate
		self.delegate?.gridScapeManager(tokenPropertyChanged: wrapper.key, cellCoord: cellCoord, with: tokenView)
		
	}
	
	public func gridTokenView(touchesBegan tokenView: ProtocolGridTokenView) {
		
		// Notify the delegate
		self.delegate?.gridScapeManager(touchesBegan: self, on: tokenView as? UIView)
		
	}
	
	public func gridTokenView(for gesture: UITapGestureRecognizer, tapped tokenView: ProtocolGridTokenView) {
		
		// Get indicatedPoint
		let indicatedPoint: 	CGPoint = self.gridScapeView!.get(locationOf: gesture)
		
		// Get cellCoord
		let cellCoord: 			CellCoord? = tokenView.gridTokenProperties?.cellCoord
		
		guard (cellCoord != nil) else { return }
		
		// Get cellView
		let cellView: 			ProtocolGridCellView? = self.get(cellView: cellCoord!)
		
		guard (cellView != nil) else { return }
		
		// Notify the delegate
		self.delegate?.gridScapeManager(tapped: tokenView, cellView: cellView!, at: indicatedPoint)
		
		self.doAfterTapped(for: gesture, tapped: indicatedPoint, cellCoord: cellCoord!)
		
	}
	
}
