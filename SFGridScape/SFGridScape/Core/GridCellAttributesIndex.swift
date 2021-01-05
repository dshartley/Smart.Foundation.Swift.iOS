//
//  GridCellAttributesIndex.swift
//  SFGridScape
//
//  Created by David on 14/12/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// Manages the indexing of cell attributes
public class GridCellAttributesIndex {

	// MARK: - Private Stored Properties
	
	fileprivate var indexCellAttributes:		[String : [String : Any?]] = [String : [String : Any?]]()
	fileprivate var indexCellSideAttributes:	[String : [String : Any?]] = [String : [String : Any?]]()
	
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Public Computed Properties
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func clear() {
		
		self.indexCellAttributes 		= [String : [String : Any?]]()
		self.indexCellSideAttributes 	= [String : [String : Any?]]()
		
	}
	
	public func index(attributes cellView: ProtocolGridCellView) {

		// Get cellKey
		let cellKey: 	String = "\(cellView.id)"
		
		let caw: 		CellAttributesWrapper = cellView.cellWrapper.cellAttributesWrapper
		let csaw: 		CellSideAttributesWrapper = cellView.cellWrapper.cellSideAttributesWrapper
		
		// Go through each cell attribute
		for ca in caw.wrapper.Params {
			
			// Add index
			self.cellAttributeAddIndex(key: ca.Key, value: ca.Value, cellKey: cellKey)
			
		}
		
		// Go through each cell side
		for w in csaw.wrapper.Items {
			
			// Get trueDegrees 	Nb: The ID of the cellSideAttribute is the true degrees of the side
			let trueDegrees: 		Int = Int(w.ID) ?? 0
			
			// Get rotationDegrees
			let rotationDegrees: 	Int = cellView.gridCellProperties!.rotationDegrees
			
			// Get side		Nb: This is the indicated side, so we need to know the rotation
			let side: 				CellSideTypes? = GridScapeHelper.toSide(from: trueDegrees, withRotation: rotationDegrees)
			
			// Go through each cell side attribute
			for csa in w.Params {
				
				// Add index
				self.cellSideAttributeAddIndex(key: csa.Key, side: side!, value: csa.Value, cellKey: cellKey)
				
			}
			
		}
		
	}

	public func index(attribute wrapper: CellPropertyChangedWrapper, cellView: ProtocolGridCellView) {
		
		// Get cellKey
		let cellKey: 	String = "\(cellView.id)"

		if (wrapper.type == .Attribute) {

			// Remove old index
			self.cellAttributeRemoveIndex(key: wrapper.key, value: wrapper.oldValue, cellKey: cellKey)

			// Add new index
			self.cellAttributeAddIndex(key: wrapper.key, value: wrapper.newValue, cellKey: cellKey)
	
		} else if (wrapper.type == .SideAttribute && wrapper.side != nil) {
			
			// Remove old index
			self.cellSideAttributeRemoveIndex(key: wrapper.key, side: wrapper.side!, value: wrapper.oldValue, cellKey: cellKey)
			
			// Add new index
			self.cellSideAttributeAddIndex(key: wrapper.key, side: wrapper.side!, value: wrapper.newValue, cellKey: cellKey)
			
		}
		
	}
	
	public func index(sideAttributesAfterRotation wrapper: CellPropertyChangedWrapper, cellView: ProtocolGridCellView) {
		
		guard (wrapper.type == .Property && wrapper.key.lowercased() == "rotationdegrees") else { return }
		
		// Get cellKey
		let cellKey: 	String = "\(cellView.id)"

		let csaw: 		CellSideAttributesWrapper = cellView.cellWrapper.cellSideAttributesWrapper
		
		// Go through each cell side
		for w in csaw.wrapper.Items {
			
			// Get trueDegrees 	Nb: The ID of the cellSideAttribute is the true degrees of the side
			let trueDegrees: 			Int = Int(w.ID) ?? 0
			
			// Get oldRotationDegrees
			let oldRotationDegrees: 	Int? = Int(wrapper.oldValue!)
			
			// Get newRotationDegrees
			let newRotationDegrees: 	Int? = Int(wrapper.newValue!)
			
			guard (oldRotationDegrees != nil && newRotationDegrees != nil) else { continue }
			
			// Get oldSide		Nb: This is the indicated side, so we need to know the rotation
			let oldSide: 				CellSideTypes? = GridScapeHelper.toSide(from: trueDegrees, withRotation: oldRotationDegrees!)

			// Get newSide		Nb: This is the indicated side, so we need to know the rotation
			let newSide: 				CellSideTypes? = GridScapeHelper.toSide(from: trueDegrees, withRotation: newRotationDegrees!)
			
			guard (oldSide != nil && newSide != nil) else { continue }
			
			// Go through each cell side attribute
			for csa in w.Params {
				
				// Remove index
				self.cellSideAttributeRemoveIndex(key: csa.Key, side: oldSide!, value: csa.Value, cellKey: cellKey)
				
				// Add index
				self.cellSideAttributeAddIndex(key: csa.Key, side: newSide!, value: csa.Value, cellKey: cellKey)
				
			}
			
		}
		
	}
	
	public func unindex(cellView: ProtocolGridCellView) {
		
		// Get cellKey
		let cellKey: 	String = "\(cellView.id)"
		
		let caw: 		CellAttributesWrapper = cellView.cellWrapper.cellAttributesWrapper
		let csaw: 		CellSideAttributesWrapper = cellView.cellWrapper.cellSideAttributesWrapper
		
		// Go through each cell attribute
		for ca in caw.wrapper.Params {
			
			// Remove index
			self.cellAttributeRemoveIndex(key: ca.Key, value: ca.Value, cellKey: cellKey)
			
		}

		// Go through each cell side
		for w in csaw.wrapper.Items {
			
			// Get trueDegrees 	Nb: The ID of the cellSideAttribute is the true degrees of the side
			let trueDegrees: 		Int = Int(w.ID) ?? 0
			
			// Get rotationDegrees
			let rotationDegrees: 	Int = cellView.gridCellProperties!.rotationDegrees
			
			// Get side		Nb: This is the indicated side, so we need to know the rotation
			let side: 				CellSideTypes? = GridScapeHelper.toSide(from: trueDegrees, withRotation: rotationDegrees)
			
			// Go through each cell side attribute
			for csa in w.Params {
				
				// Remove index
				self.cellSideAttributeRemoveIndex(key: csa.Key, side: side!, value: csa.Value, cellKey: cellKey)
				
			}

		}
		
	}
	
	public func find(key: String, value: String) -> [String : Any?]? {
		
		var result: 	[String : Any?]? = nil
		
		// Get indexKey
		let indexKey: 	String = self.getIndexKey(key: key, value: value)
		
		result = self.indexCellAttributes[indexKey]

		return result
		
	}

	public func find(key: String, side: CellSideTypes, value: String) -> [String : Any?]? {
		
		var result: 	[String : Any?]? = nil
		
		// Get indexKey
		let indexKey: 	String = self.getIndexKey(key: key, side: side, value: value)
		
		result = self.indexCellSideAttributes[indexKey]
		
		return result
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func getIndexKey(key: String, value: String) -> String {
		
		let result: String = "\(key.lowercased())_\(value.lowercased())"
		
		return result
		
	}

	fileprivate func getIndexKey(key: String, side: CellSideTypes, value: String) -> String {
		
		let result: String = "\(key.lowercased())_\(side)_\(value.lowercased())"
		
		return result
		
	}
	
	fileprivate func cellAttributeRemoveIndex(key: String, value: String?, cellKey: String) {
		
		// Check value
		if (value != nil) {
		
			// Get indexKey
			let indexKey: 	String = self.getIndexKey(key: key, value: value!)
			
			// Check index exists for indexKey
			if (self.indexCellAttributes[indexKey] != nil) {
				
				// Remove from index
				self.indexCellAttributes[indexKey]?.removeValue(forKey: cellKey)
				
				// Check number of items in index
				if (self.indexCellAttributes[indexKey]!.count == 0) {
					
					// Clear old index
					self.indexCellAttributes.removeValue(forKey: indexKey)
					
				}
				
			}
			
		}
		
	}

	fileprivate func cellSideAttributeRemoveIndex(key: String, side: CellSideTypes, value: String?, cellKey: String) {
		
		// Check value
		if (value != nil) {
			
			// Get indexKey
			let indexKey: 	String = self.getIndexKey(key: key, side: side, value: value!)
			
			// Check index exists for indexKey
			if (self.indexCellSideAttributes[indexKey] != nil) {
				
				// Remove from index
				self.indexCellSideAttributes[indexKey]?.removeValue(forKey: cellKey)
				
				// Check number of items in index
				if (self.indexCellSideAttributes[indexKey]!.count == 0) {
					
					// Clear old index
					self.indexCellSideAttributes.removeValue(forKey: indexKey)
					
				}
				
			}
			
		}
		
	}
	
	fileprivate func cellAttributeAddIndex(key: String, value: String?, cellKey: String) {
		
		// Check value
		if (value != nil) {
			
			// Get indexKey
			let indexKey: 	String = self.getIndexKey(key: key, value: value!)
			
			// Check index exists for indexKey
			if (self.indexCellAttributes[indexKey] == nil) {
				
				self.indexCellAttributes[indexKey] = [String : Any?]()
				
			}
			
			// Add to index
			self.indexCellAttributes[indexKey]![cellKey] = cellKey
			
		}
		
	}
	
	fileprivate func cellSideAttributeAddIndex(key: String, side: CellSideTypes, value: String?, cellKey: String) {
		
		// Check value
		if (value != nil) {
			
			// Get indexKey
			let indexKey: 	String = self.getIndexKey(key: key, side: side, value: value!)
			
			// Check index exists for indexKey
			if (self.indexCellSideAttributes[indexKey] == nil) {
				
				self.indexCellSideAttributes[indexKey] = [String : Any?]()
				
			}
			
			// Add to index
			self.indexCellSideAttributes[indexKey]![cellKey] = cellKey
			
		}
		
	}
	
}
