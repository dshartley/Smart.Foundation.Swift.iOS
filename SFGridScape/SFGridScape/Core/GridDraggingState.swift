//
//  GridDraggingState.swift
//  SFGridScape
//
//  Created by David on 17/12/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a GridDraggingState item
public class GridDraggingState {
	
	// MARK: - Public Stored Properties
	
	public var type: 										GridDraggingTypes = .Cell
	public var isDraggingYN: 								Bool = true
	public fileprivate(set) var fromIndicated:				CGPoint? = nil
	public fileprivate(set) var fromCellCoord:				CellCoord? = nil
	public fileprivate(set) var fromCellCoordIndicated:		CGPoint? = nil
	public fileprivate(set) var toCellCoord:				CellCoord? = nil
	public fileprivate(set) var toCellCoordIndicated:		CGPoint? = nil
	public fileprivate(set) var originCellView: 			ProtocolGridCellView? = nil
	public fileprivate(set) var originTileView: 			ProtocolGridTileView? = nil
	public fileprivate(set) var originTokenView: 			ProtocolGridTokenView? = nil
	public fileprivate(set) var originView: 				UIView? = nil
	public fileprivate(set) var draggingCellView: 			ProtocolGridCellView? = nil
	public fileprivate(set) var draggingTileView: 			ProtocolGridTileView? = nil
	public fileprivate(set) var draggingTokenView: 			ProtocolGridTokenView? = nil
	public fileprivate(set) var draggingView: 				UIView? = nil
	public var canDropYN:									Bool = false
	public fileprivate(set) var isFromCellCoordYN:			Bool = true
	
	
	// MARK: - Public Computed Properties
	
	
	// MARK: - Initializers
	
	public init() {
		
	}


	// MARK: - Public Methods

	public func clear() {
		
		self.originCellView 	= nil
		self.originTileView 	= nil
		self.originTokenView 	= nil
		self.draggingCellView 	= nil
		self.draggingTileView 	= nil
		self.draggingTokenView 	= nil
		self.isDraggingYN 		= false
		self.isFromCellCoordYN	= true
		self.canDropYN			= false
		
	}
	
	public func set(fromIndicated: CGPoint, gridProperties: GridProperties, gridState: GridState) {
		
		self.fromIndicated 				= fromIndicated
		
		// Get fromTrue
		let fromTrue: 					CGPoint = GridScapeHelper.toTrue(fromIndicated: self.fromIndicated!, gridState: gridState)
		
		// Get fromCellCoord
		self.fromCellCoord				= GridScapeHelper.toCellCoord(fromTrue: fromTrue, gridProperties: gridProperties)
		
		// Get fromCellCoordTrue
		let fromCellCoordTrue: 			CGPoint = GridScapeHelper.toTrue(fromCellCoord: self.fromCellCoord!, gridProperties: gridProperties)
		
		// Get fromCellCoordIndicated
		self.fromCellCoordIndicated 	= GridScapeHelper.toIndicated(fromTrue: fromCellCoordTrue, gridState: gridState)

	}
	
	public func set(toCellCoord: CellCoord, gridProperties: GridProperties, gridState: GridState) {
	
		self.toCellCoord 			= toCellCoord
		
		// Get toCellCoordTrue
		let toCellCoordTrue: 		CGPoint = GridScapeHelper.toTrue(fromCellCoord: self.toCellCoord!, gridProperties: gridProperties)
		
		// Get toCellCoordIndicated
		self.toCellCoordIndicated 	= GridScapeHelper.toIndicated(fromTrue: toCellCoordTrue, gridState: gridState)
		
		// Check isFromCellCoordYN
		self.isFromCellCoordYN 		= self.fromCellCoord!.equals(cellCoord: self.toCellCoord!)
		
	}
	
	public func set(originCellView:	ProtocolGridCellView?) {
		
		self.originCellView 	= originCellView

		self.originView 		= (self.originCellView as? UIView) ?? nil
		
	}

	public func set(originTileView:	ProtocolGridTileView?) {
		
		self.originTileView 	= originTileView
		
		self.originView 		= (self.originTileView as? UIView) ?? nil
	
	}

	public func set(originTokenView:	ProtocolGridTokenView?) {
		
		self.originTokenView 	= originTokenView
		
		self.originView 		= (self.originTokenView as? UIView) ?? nil
		
	}
	
	public func set(draggingCellView: ProtocolGridCellView?) {
		
		self.draggingCellView 	= draggingCellView
		
		self.draggingView 		= (self.draggingCellView as? UIView) ?? nil
		self.originView 		= (self.originCellView as? UIView) ?? nil
		
	}
	
	public func set(draggingTileView: ProtocolGridTileView?) {
		
		self.draggingTileView 	= draggingTileView
		
		self.draggingView 		= (self.draggingTileView as? UIView) ?? nil
		self.originView 		= (self.originTileView as? UIView) ?? nil
		
	}

	public func set(draggingTokenView: ProtocolGridTokenView?) {
		
		self.draggingTokenView 	= draggingTokenView
		
		self.draggingView 		= (self.draggingTokenView as? UIView) ?? nil
		self.originView 		= (self.originTokenView as? UIView) ?? nil
		
	}
	
}
