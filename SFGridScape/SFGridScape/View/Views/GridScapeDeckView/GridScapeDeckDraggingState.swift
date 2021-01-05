//
//  GridScapeDeckDraggingState.swift
//  SFGridScape
//
//  Created by David on 30/12/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// A wrapper for a GridScapeDeckDraggingState item
public class GridScapeDeckDraggingState {
	
	// MARK: - Public Stored Properties
	
	public var isDraggingYN: 					Bool = true
	public var type: 							GridDraggingTypes = .Cell
	public var fromIndicated: 					CGPoint? = nil
	public var currentCellCoord: 				CellCoord? = nil
	public var insideDeckYN: 					Bool = true
	public var currentIndicatedInGridScapeView: CGPoint? = nil
	public var canDropYN: 						Bool = false
	public var isInitialYN: 					Bool = true
	public fileprivate(set) var originCellView: ProtocolGridCellView? = nil
	public fileprivate(set) var originView: 	UIView? = nil
	
	
	// MARK: - Public Computed Properties
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func clear() {
		
		self.isDraggingYN						= false
		self.fromIndicated 						= nil
		self.currentCellCoord					= nil
		self.insideDeckYN 						= true
		self.currentIndicatedInGridScapeView 	= nil
		self.canDropYN 							= false
		self.isInitialYN 						= true
		self.originCellView						= nil
		self.originView							= nil
		
	}
	
	public func set(originCellView:	ProtocolGridCellView?) {
		
		self.originCellView 	= originCellView
		
		self.originView 		= (self.originCellView as? UIView) ?? nil
		
	}
	
}

