//
//  PathWrapperBase.swift
//  SFGridScape
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

/// A base class for classes which are a wrapper for a Path model item
open class PathWrapperBase {
	
	// MARK: - Private Stored Properties
	
	fileprivate var indexedPathPoints:					[PathPointWrapperBase]? = nil
	
	
	// MARK: - Public Stored Properties
	
	public var id:										String = ""
	public fileprivate(set) var pathPoints:				[String:PathPointWrapperBase]? = [String:PathPointWrapperBase]()
	public fileprivate(set) var pathAttributesString:	String = ""
	public var pathAttributesWrapper:					PathAttributesWrapper = PathAttributesWrapper()
	public fileprivate(set) var pathLogString:			String = ""
	public var pathLogWrapper:							PathLogWrapper = PathLogWrapper()
	public fileprivate(set) var current:				PathPointWrapperBase? = nil
	public var status: 									PathStatusTypes = .NotStarted
	public var originCellCoord:							CellCoord? = nil
	public var start:									PathPointWrapperBase? = nil
	public fileprivate(set) var currentPathPointIndex:	Int = 0
	
	
	// MARK: - Public Computed Properties
	
	public var first: PathPointWrapperBase? {
		get {
			
			guard (self.pathPoints != nil && self.pathPoints!.count > 0) else { return nil }
			
			var result: 		PathPointWrapperBase? = nil
			var lowestIndex: 	Int? = nil
			
			// Go through each item
			for ppw in self.pathPoints!.values {

				if (lowestIndex == nil) { lowestIndex = ppw.index }
				
				if (ppw.index <= lowestIndex!) {
					
					lowestIndex = ppw.index
					result = ppw
					
				}
				
			}
			
			return result
			
		}
	}

	public var last: PathPointWrapperBase? {
		get {
			
			guard (self.pathPoints != nil && self.pathPoints!.count > 0) else { return nil }
			
			var result: 		PathPointWrapperBase? = nil
			var highestIndex: 	Int? = nil
			
			// Go through each item
			for ppw in self.pathPoints!.values {
				
				if (highestIndex == nil) { highestIndex = ppw.index }
				
				if (ppw.index >= highestIndex!) {
					
					highestIndex = ppw.index
					result = ppw
					
				}
				
			}
			
			return result
			
		}
	}
	
	public var next: PathPointWrapperBase? {
		get {
			
			guard (self.indexedPathPoints != nil && self.indexedPathPoints!.count > 0) else { return nil }
			
			var result: 	PathPointWrapperBase? = nil
			let i: 			Int = self.currentPathPointIndex + 1
			
			if (i <= (self.indexedPathPoints!.endIndex - 1)) {
			
				result = self.indexedPathPoints![i]
			}
			
			return result
			
		}
	}
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	open func dispose() {
		
		self.pathPoints = nil
		
	}
	
	public func setFirst() {
		
		// Check indexedPathPoints
		if (self.indexedPathPoints == nil) { self.setIndexedPathPoints() }
		
		// Set current first item
		self.current 					= self.indexedPathPoints!.first
		self.currentPathPointIndex 		= 0
		
	}
	
	public func setNext() {
	
		// Check indexedPathPoints
		if (self.indexedPathPoints == nil) { self.setIndexedPathPoints() }
		
		if (self.current != nil) {
		
			// Set doneYN
			self.current!.doneYN 			= true
			
		} else {
			
			// Set current first item
			self.current 					= self.indexedPathPoints!.first
			self.currentPathPointIndex 		= 0
			
		}
		
		guard (self.indexedPathPoints!.count > 0) else { return }
		
		// Check doneYN
		while (self.current!.doneYN) {
			
			if (self.currentPathPointIndex < (self.indexedPathPoints!.endIndex - 1)) {
				
				// Set current next item
				self.currentPathPointIndex 	+= 1
				self.current 				= self.indexedPathPoints![self.currentPathPointIndex]
				
			}
			
		}
		
	}
//
//	public func set(current: PathPointWrapperBase) {
//
//		self.current = current
//
//	}
	
	public func set(pathPointWrapper: PathPointWrapperBase) {
		
		if (self.pathPoints == nil) {
			
			self.pathPoints = [String:PathPointWrapperBase]()
			
		}
		
		self.pathPoints![pathPointWrapper.id] = pathPointWrapper
		
	}
	
	public func set(pathAttributesString: String) {
		
		self.pathAttributesString 	= pathAttributesString
		
		// Create pathAttributesWrapper
		self.pathAttributesWrapper 	= PathAttributesWrapper(pathAttributesString: pathAttributesString)
		
		self.refreshPathAttributesString()
		
	}
	
	public func refreshPathAttributesString() {
		
		self.pathAttributesString = self.pathAttributesWrapper.toString()
	
	}

	public func set(pathLogString: String) {
		
		self.pathLogString 		= pathLogString
		
		// Create pathLogWrapper
		self.pathLogWrapper 	= PathLogWrapper(pathLogString: pathLogString)
		
		self.refreshPathLogString()
		
	}
	
	public func refreshPathLogString() {
		
		self.pathLogString = self.pathLogWrapper.toString()
		
	}
	
	public func remove(pathPointWrapper id: String) {
		
		guard (self.pathPoints != nil) else { return }
		
		self.pathPoints!.removeValue(forKey: id)
		
	}
	
	public func clearPathPoints() {
		
		guard (self.pathPoints != nil) else { return }
		
		// Go through each item
		for ppw in self.pathPoints!.values {
			
			ppw.dispose()
			
		}
		
		self.pathPoints = nil
		
	}
	
	public func getPointsByIndex() -> [PathPointWrapperBase] {
		
		var result: 		[PathPointWrapperBase] = [PathPointWrapperBase]()
		
		guard (self.pathPoints != nil) else { return result }
		
		var indexedItems: 	[Int:[PathPointWrapperBase]] = [Int:[PathPointWrapperBase]]()
		var highestIndex:	Int = 0
		
		// Go through each item
		for ppw in self.pathPoints!.values {
			
			var index: 		Int = ppw.index
			if (index < 0) { index = 0 }
			
			if (!indexedItems.keys.contains(index)) {
				
				indexedItems[index] = [PathPointWrapperBase]()
				
			}
			
			indexedItems[index]!.append(ppw)
			
			// Set highestIndex
			if (index > highestIndex) { highestIndex = index }
			
		}
		
		// Go through each index
		for index in 0...highestIndex {
			
			// Get items for index
			if let items = indexedItems[index] {
				
				result.append(contentsOf: items)
				
			}
			
		}
		
		// Set start
		self.start = result.first
		
		return result
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setIndexedPathPoints() {
	
		self.indexedPathPoints = self.getPointsByIndex()
		
	}
	
}
