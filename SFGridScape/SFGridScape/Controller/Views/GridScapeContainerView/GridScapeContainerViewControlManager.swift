//
//  GridScapeContainerViewControlManager.swift
//  SFGridScape
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit
import SFController
import SFModel
import SFSerialization

/// Manages the GridScapeContainerView control layer
public class GridScapeContainerViewControlManager: ControlManagerBase {
	
	// MARK: - Private Stored Properties
	
	fileprivate var cellWrappers: 				[String:CellWrapperBase] = [String:CellWrapperBase]()
	fileprivate var tileWrappers: 				[String:TileWrapperBase] = [String:TileWrapperBase]()
	fileprivate var tokenWrappers: 				[String:TokenWrapperBase] = [String:TokenWrapperBase]()
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:					ProtocolGridScapeContainerViewControlManagerDelegate?
	public var viewManager:						GridScapeContainerViewViewManager?
	public var isGridScapeInitialLoadedYN:		Bool = false
	
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManagerBase, viewManager: GridScapeContainerViewViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager = viewManager
	}
	
	
	// MARK: - Public Methods

	public func clear() {
		
		self.cellWrappers 					= [String:CellWrapperBase]()
		self.tileWrappers 					= [String:TileWrapperBase]()
		self.tokenWrappers 					= [String:TokenWrapperBase]()
		self.isGridScapeInitialLoadedYN 	= false
		
	}
	
	
	// MARK: - Public Methods; Cells
	
	public func get(cellWrapper cellCoord: CellCoord) -> CellWrapperBase? {
		
		let k: 	String = "\(cellCoord.column),\(cellCoord.row)"
		
		return self.cellWrappers[k]
		
	}
	
	public func get(cellWrappers cellCoordRange: CellCoordRange) -> [CellWrapperBase] {
		
		var result: [CellWrapperBase] = [CellWrapperBase]()
		
		// Go through each item
		for cellWrapper in self.cellWrappers.values {
			
			// Get cellCoord
			let cellCoord: CellCoord = CellCoord(column: cellWrapper.column, row: cellWrapper.row)
			
			if (cellCoordRange.contains(cellCoord: cellCoord)) {
				
				result.append(cellWrapper)
				
			}
			
		}
		
		return result
		
	}
	
	public func set(cellWrappers: [CellWrapperBase]) {
		
		// Go through each item
		for cellWrapper in cellWrappers {
			
			self.set(cellWrapper: cellWrapper)
			
		}
		
	}
	
	public func set(cellWrapper: CellWrapperBase) {
		
		let k: 	String = "\(cellWrapper.column),\(cellWrapper.row)"
		
		self.cellWrappers[k] = cellWrapper
		
	}
	
	public func remove(cellWrapper: CellWrapperBase) {
		
		let k: 	String = "\(cellWrapper.column),\(cellWrapper.row)"
		
		self.cellWrappers.removeValue(forKey: k)
		
	}
	
	public func copy(from cellWrapper: CellWrapperBase, to cell: ProtocolGridScapeCell) {
		
		cell.cellTypeID					= cellWrapper.cellTypeID
		cell.column 					= cellWrapper.column
		cell.row 						= cellWrapper.row
		cell.rotationDegrees			= cellWrapper.rotationDegrees
		cell.imageName					= cellWrapper.imageName
		cell.cellAttributesString		= cellWrapper.cellAttributesString
		cell.cellSideAttributesString	= cellWrapper.cellSideAttributesString
		
	}
	
	public func addCell(cellWrapper: CellWrapperBase, cellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Create completion handler
		let addTileCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Call the completion handler
			completionHandler(error)
			
		}
		
		// Create model item
		let cell: 			ProtocolGridScapeCell? = self.delegate?.createCellModelItem(for: cellWrapper)
		
		guard (cell != nil) else { return }
		
		self.copy(from: cellWrapper, to: cell!)
		
		cellWrapper.id 		= cell!.id
		self.set(cellWrapper: cellWrapper)
		
		// Create completion handler
		let saveCellCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Check tileWrapper
			if (cellWrapper.tileWrapper != nil) {
				
				// Add tile
				self.addTile(tileWrapper: cellWrapper.tileWrapper!, cellCoord: cellCoord, oncomplete: addTileCompletionHandler)
				
			}
			
		}
		
		// Save
		self.delegate?.saveCell(cell: cell!, oncomplete: saveCellCompletionHandler)
		
	}
	
	public func saveCell(cellWrapper: CellWrapperBase, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get model item
		let cell: ProtocolGridScapeCell? = self.delegate?.getCellModelItem(for: cellWrapper.id)
		
		guard (cell != nil) else { return }
		
		self.copy(from: cellWrapper, to: cell!)
		
		// Save
		self.delegate?.saveCell(cell: cell!, oncomplete: completionHandler)
		
	}
	
	public func saveCell(cellView: ProtocolGridCellView, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let gcp: 			GridCellProperties = cellView.gridCellProperties!
		
		// Get cellWrapper
		let cellWrapper: 	CellWrapperBase? = self.get(cellWrapper: gcp.cellCoord!)
		
		guard (cellWrapper != nil) else { return }
		
		self.copy(from: cellView, to: cellWrapper!)
		
		self.saveCell(cellWrapper: cellWrapper!, oncomplete: completionHandler)
		
	}
	
	public func saveCell(afterMoved cellView: ProtocolGridCellView, from fromCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let gcp: 				GridCellProperties = cellView.gridCellProperties!
		
		// Get cellWrapper
		let cellWrapper: 		CellWrapperBase? = self.get(cellWrapper: fromCellCoord)
		
		guard (cellWrapper != nil) else { return }
		
		let k: 	String = "\(fromCellCoord.column),\(fromCellCoord.row)"
		
		self.cellWrappers.removeValue(forKey: k)
		
		// Set properties in cellWrapper
		cellWrapper!.column 	= gcp.cellCoord!.column
		cellWrapper!.row		= gcp.cellCoord!.row
		
		self.set(cellWrapper: cellWrapper!)

		var resultCount: Int = 0
		
		// Create completion handler
		let saveTokenCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			guard (error == nil) else {
				
				// Call completion handler
				completionHandler(error)
				
				return
				
			}
			
			resultCount += 1
			
			if (resultCount >= cellView.tokenViews.count) {
				
				// Call completion handler
				completionHandler(nil)
				
			}
			
		}
		
		// Create completion handler
		let saveTileCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			guard (error == nil) else {
				
				// Call completion handler
				completionHandler(error)
				
				return
				
			}
			
			resultCount += 1
			
			if (resultCount >= cellView.tileViews.count) {
				
				resultCount = 0
				
				// Go through each tokenView
				for tokenView in cellView.tokenViews.values {
					
					// Save tokenView
					self.saveToken(afterMoved: tokenView, from: fromCellCoord, oncomplete: saveTokenCompletionHandler)
					
				}
				
			}
			
		}
		
		resultCount = 0
		
		// Create completion handler
		let saveCellCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in

			guard (error == nil) else {
				
				// Call completion handler
				completionHandler(error)
				
				return
				
			}
			
			// Go through each tileView
			for tileView in cellView.tileViews.values {
				
				// Save tileView
				self.saveTile(afterMoved: tileView, from: fromCellCoord, oncomplete: saveTileCompletionHandler)
				
			}
			
		}
		
		self.saveCell(cellView: cellView, oncomplete: saveCellCompletionHandler)
		
	}
	
	public func removeCell(cellCoord: CellCoord) {
		
		// Get cellWrapper
		let cellWrapper: CellWrapperBase? = self.get(cellWrapper: cellCoord)
		
		guard (cellWrapper != nil) else { return }
		
		if (cellWrapper!.tileWrapper != nil) {
			
			// Remove tile
			self.removeTile(cellCoord: cellCoord)
		}
		
		self.remove(cellWrapper: cellWrapper!)
		
		// Get model item
		let cell: 		ProtocolGridScapeCell? = self.delegate?.getCellModelItem(for: cellWrapper!.id)
		
		// Create completion handler
		let saveCellCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Not required
			
		}
		
		if (cell != nil) {
			
			self.delegate?.removeCellModelItem(cell: cell!)
			
			// Save
			self.delegate?.saveCell(cell: cell!, oncomplete: saveCellCompletionHandler)
			
		}
		
	}
	
	public func copy(from cellView: ProtocolGridCellView, to cellWrapper: CellWrapperBase) {
		
		let gcp: 						GridCellProperties = cellView.gridCellProperties!
		
		cellWrapper.cellTypeID			= cellView.cellWrapper.cellTypeID
		
		if (cellView.cellWrapper.cellTypeWrapper != nil) {
			
			cellWrapper.set(cellTypeWrapper: cellView.cellWrapper.cellTypeWrapper!)
			
		}
		
		cellWrapper.column				= gcp.cellCoord!.column
		cellWrapper.row					= gcp.cellCoord!.row
		cellWrapper.rotationDegrees 	= gcp.rotationDegrees
		cellWrapper.imageName			= cellView.cellWrapper.imageName
		
		// Set cellAttributesString
		cellWrapper.set(cellAttributesString: cellView.cellWrapper.cellAttributesString)
		
		// Set cellSideAttributesString
		cellWrapper.set(cellSideAttributesString: cellView.cellWrapper.cellSideAttributesString)

	}
	
	
	// MARK: - Public Methods; Tiles
	
	public func get(tileWrapper cellCoord: CellCoord) -> TileWrapperBase? {
		
		let k: 	String = "\(cellCoord.column),\(cellCoord.row)"
		
		return self.tileWrappers[k]
		
	}
	
	public func set(tileWrappers: [TileWrapperBase]) {
		
		// Go through each item
		for tileWrapper in tileWrappers {
			
			self.set(tileWrapper: tileWrapper)
			
			// Get cellCoord
			let cellCoord:		CellCoord = CellCoord(column: tileWrapper.column, row: tileWrapper.row)
			
			// Get cellWrapper
			let cellWrapper: 	CellWrapperBase? = self.get(cellWrapper: cellCoord)
			
			if (cellWrapper != nil) {
				
				// Set tileWrapper
				cellWrapper!.tileWrapper = tileWrapper
				
			}
			
		}
		
	}
	
	public func set(tileWrapper: TileWrapperBase) {
		
		let k: 	String = "\(tileWrapper.column),\(tileWrapper.row)"
		
		self.tileWrappers[k] = tileWrapper
		
	}
	
	public func remove(tileWrapper: TileWrapperBase) {
		
		let k: 	String = "\(tileWrapper.column),\(tileWrapper.row)"
		
		self.tileWrappers.removeValue(forKey: k)
		
	}
	
	public func copy(from tileWrapper: TileWrapperBase, to tile: ProtocolGridScapeTile) {
		
		tile.tileTypeID						= tileWrapper.tileTypeID
		tile.column 						= tileWrapper.column
		tile.row 							= tileWrapper.row
		tile.rotationDegrees				= tileWrapper.rotationDegrees
		tile.imageName						= tileWrapper.imageName
		tile.widthPixels					= tileWrapper.widthPixels
		tile.heightPixels					= tileWrapper.heightPixels
		tile.position						= tileWrapper.position
		tile.positionFixToCellRotationYN	= tileWrapper.positionFixToCellRotationYN
		tile.tileAttributesString			= tileWrapper.tileAttributesString
		tile.tileSideAttributesString		= tileWrapper.tileSideAttributesString
		
	}
	
	public func addTile(tileWrapper: TileWrapperBase, cellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get cellWrapper
		let cellWrapper: CellWrapperBase? = self.get(cellWrapper: cellCoord)
		
		guard (cellWrapper != nil) else { return }
		
		// Nb: The cellWrapper may already have a tileWrapper if this method is called from addCell when the deckCellView is dropped to the gridScapeView
		
		// Set in cellWrapper
		cellWrapper!.tileWrapper = tileWrapper
		
		// Create model item
		let tile: 		ProtocolGridScapeTile? = self.delegate?.createTileModelItem(for: tileWrapper)
		
		guard (tile != nil) else { return }
		
		self.copy(from: tileWrapper, to: tile!)
		
		tileWrapper.id 	= tile!.id
		self.set(tileWrapper: tileWrapper)
		
		// Save
		self.delegate?.saveTile(tile: tile!, oncomplete: completionHandler)
		
	}
	
	public func saveTile(tileWrapper: TileWrapperBase, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get model item
		let tile: ProtocolGridScapeTile? = self.delegate?.getTileModelItem(for: tileWrapper.id)
		
		guard (tile != nil) else { return }
		
		self.copy(from: tileWrapper, to: tile!)
		
		// Save to cache
		self.delegate?.saveTile(tile: tile!, oncomplete: completionHandler)
		
	}
	
	public func saveTile(tileView: ProtocolGridTileView, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let gtp: 			GridTileProperties = tileView.gridTileProperties!
		
		// Get tileWrapper
		let tileWrapper: 	TileWrapperBase? = self.get(tileWrapper: gtp.cellCoord!)
		
		guard (tileWrapper != nil) else { return }
		
		self.copy(from: tileView, to: tileWrapper!)
		
		self.saveTile(tileWrapper: tileWrapper!, oncomplete: completionHandler)
		
	}

	public func saveTile(afterMoved tileView: ProtocolGridTileView, from fromCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let gtp: 						GridTileProperties = tileView.gridTileProperties!
		
		// Get tileWrapper
		let tileWrapper: 				TileWrapperBase? = self.get(tileWrapper: fromCellCoord)
		
		guard (tileWrapper != nil) else { return }
		
		let k: 							String = "\(fromCellCoord.column),\(fromCellCoord.row)"
		
		self.tileWrappers.removeValue(forKey: k)
		
		// Set properties in tileWrapper
		tileWrapper!.column 			= gtp.cellCoord!.column
		tileWrapper!.row				= gtp.cellCoord!.row
		
		self.set(tileWrapper: tileWrapper!)
		
		// Create completion handler
		let saveTileCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Call completion handler
			completionHandler(error)
			
		}
		
		// Get fromCellWrapper
		let fromCellWrapper: 			CellWrapperBase? = self.get(cellWrapper: fromCellCoord)
		
		fromCellWrapper?.tileWrapper 	= nil
		
		// Get toCellWrapper
		let toCellWrapper: 				CellWrapperBase? = self.get(cellWrapper: gtp.cellCoord!)
		
		toCellWrapper?.tileWrapper 		= tileWrapper
	
		self.saveTile(tileView: tileView, oncomplete: saveTileCompletionHandler)
		
	}
	
	public func removeTile(cellCoord: CellCoord) {
		
		// Create completion handler
		let saveTileCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// TODO:
			
		}
		
		// Get cellWrapper
		let cellWrapper: 	CellWrapperBase? = self.get(cellWrapper: cellCoord)
		
		guard (cellWrapper != nil) else { return }
		
		// Get cellWrapper
		let tileWrapper: 	TileWrapperBase? = cellWrapper!.tileWrapper
		
		guard (tileWrapper != nil) else { return }
		
		// Remove from cellWrapper
		cellWrapper!.tileWrapper = nil
		
		self.remove(tileWrapper: tileWrapper!)
		
		// Get model item
		let tile: 			ProtocolGridScapeTile? = self.delegate?.getTileModelItem(for: tileWrapper!.id)
		
		if (tile != nil) {
			
			self.delegate?.removeTileModelItem(tile: tile!)
			
			// Save
			self.delegate?.saveTile(tile: tile!, oncomplete: saveTileCompletionHandler)
			
		}
	
	}
	
	public func copy(from tileView: ProtocolGridTileView, to tileWrapper: TileWrapperBase) {
		
		let gtp: 								GridTileProperties = tileView.gridTileProperties!
		
		tileWrapper.tileTypeID					= tileView.tileWrapper.tileTypeID
		
		if (tileView.tileWrapper.tileTypeWrapper != nil) {
			
			tileWrapper.set(tileTypeWrapper: tileView.tileWrapper.tileTypeWrapper!)
			
		}
		
		tileWrapper.column						= gtp.cellCoord!.column
		tileWrapper.row							= gtp.cellCoord!.row
		tileWrapper.rotationDegrees 			= gtp.rotationDegrees
		tileWrapper.imageName					= tileView.tileWrapper.imageName
		tileWrapper.widthPixels					= Int(gtp.tileWidth)
		tileWrapper.heightPixels				= Int(gtp.tileHeight)
		tileWrapper.position					= gtp.position
		tileWrapper.positionFixToCellRotationYN	= gtp.positionFixToCellRotationYN
		
		// Set tileAttributesString
		tileWrapper.set(tileAttributesString: tileView.tileWrapper.tileAttributesString)
		
		// Set tileSideAttributesString
		tileWrapper.set(tileSideAttributesString: tileView.tileWrapper.tileSideAttributesString)
	}
	
	
	// MARK: - Public Methods; Tokens
	
	public func get(tokenWrapper cellCoord: CellCoord) -> TokenWrapperBase? {
		
		let k: 	String = "\(cellCoord.column),\(cellCoord.row)"
		
		return self.tokenWrappers[k]
		
	}
	
	public func set(tokenWrappers: [TokenWrapperBase]) {
		
		// Go through each item
		for tokenWrapper in tokenWrappers {
			
			self.set(tokenWrapper: tokenWrapper)
			
			// Get cellCoord
			let cellCoord:		CellCoord = CellCoord(column: tokenWrapper.column, row: tokenWrapper.row)
			
			// Get cellWrapper
			let cellWrapper: 	CellWrapperBase? = self.get(cellWrapper: cellCoord)
			
			if (cellWrapper != nil) {
				
				// Set tokenWrapper
				cellWrapper!.tokenWrapper = tokenWrapper
				
			}
			
		}
		
	}
	
	public func set(tokenWrapper: TokenWrapperBase) {
		
		let k: 	String = "\(tokenWrapper.column),\(tokenWrapper.row)"
		
		self.tokenWrappers[k] = tokenWrapper
		
	}
	
	public func remove(tokenWrapper: TokenWrapperBase) {
		
		let k: 	String = "\(tokenWrapper.column),\(tokenWrapper.row)"
		
		self.tokenWrappers.removeValue(forKey: k)
		
	}
	
	public func copy(from tokenWrapper: TokenWrapperBase, to token: ProtocolGridScapeToken) {
		
		token.column 					= tokenWrapper.column
		token.row 						= tokenWrapper.row
		token.imageName					= tokenWrapper.imageName
		token.tokenAttributesString		= tokenWrapper.tokenAttributesString
	
	}
	
	public func addToken(tokenWrapper: TokenWrapperBase, cellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get cellWrapper
		let cellWrapper: CellWrapperBase? = self.get(cellWrapper: cellCoord)
		
		guard (cellWrapper != nil) else { return }
		
		// Nb: The cellWrapper may already have a tokenWrapper if this method is called from addCell when the deckCellView is dropped to the gridScapeView
		
		// Set in cellWrapper
		cellWrapper!.tokenWrapper = tokenWrapper
		
		// Create model item
		let token: 		ProtocolGridScapeToken? = self.delegate?.createTokenModelItem(for: tokenWrapper)
		
		guard (token != nil) else { return }
		
		self.copy(from: tokenWrapper, to: token!)
		
		tokenWrapper.id 	= token!.id
		self.set(tokenWrapper: tokenWrapper)
		
		// Save
		self.delegate?.saveToken(token: token!, oncomplete: completionHandler)
		
	}
	
	public func saveToken(tokenWrapper: TokenWrapperBase, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Get model item
		let token: ProtocolGridScapeToken? = self.delegate?.getTokenModelItem(for: tokenWrapper.id)
		
		guard (token != nil) else { return }
		
		self.copy(from: tokenWrapper, to: token!)
		
		// Save
		self.delegate?.saveToken(token: token!, oncomplete: completionHandler)
		
	}
	
	public func saveToken(tokenView: ProtocolGridTokenView, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let gtp: 			GridTokenProperties = tokenView.gridTokenProperties!
		
		// Get tokenWrapper
		let tokenWrapper: 	TokenWrapperBase? = self.get(tokenWrapper: gtp.cellCoord!)
		
		guard (tokenWrapper != nil) else { return }
		
		self.copy(from: tokenView, to: tokenWrapper!)
		
		self.saveToken(tokenWrapper: tokenWrapper!, oncomplete: completionHandler)
		
	}
	
	public func saveToken(afterMoved tokenView: ProtocolGridTokenView, from fromCellCoord: CellCoord, oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		let gtp: 						GridTokenProperties = tokenView.gridTokenProperties!
		
		// Get tokenWrapper
		let tokenWrapper: 				TokenWrapperBase? = self.get(tokenWrapper: fromCellCoord)
		
		guard (tokenWrapper != nil) else { return }
		
		let k: 							String = "\(fromCellCoord.column),\(fromCellCoord.row)"
		
		self.tokenWrappers.removeValue(forKey: k)
		
		// Set properties in tokenWrapper
		tokenWrapper!.column 			= gtp.cellCoord!.column
		tokenWrapper!.row				= gtp.cellCoord!.row
		
		self.set(tokenWrapper: tokenWrapper!)
		
		// Create completion handler
		let saveTokenCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
		
			// Call completion handler
			completionHandler(error)
			
		}
		
		// Get fromCellWrapper
		let fromCellWrapper: 			CellWrapperBase? = self.get(cellWrapper: fromCellCoord)
		
		fromCellWrapper?.tokenWrapper 	= nil
		
		// Get toCellWrapper
		let toCellWrapper: 				CellWrapperBase? = self.get(cellWrapper: gtp.cellCoord!)
		
		toCellWrapper?.tokenWrapper 	= tokenWrapper
		
		self.saveToken(tokenView: tokenView, oncomplete: saveTokenCompletionHandler)
		
	}
	
	public func removeToken(cellCoord: CellCoord) {
		
		// Create completion handler
		let saveTokenCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// TODO:
			
		}
		
		// Get cellWrapper
		let cellWrapper: 	CellWrapperBase? = self.get(cellWrapper: cellCoord)
		
		guard (cellWrapper != nil) else { return }
		
		// Get cellWrapper
		let tokenWrapper: 	TokenWrapperBase? = cellWrapper!.tokenWrapper
		
		guard (tokenWrapper != nil) else { return }
		
		// Remove from cellWrapper
		cellWrapper!.tokenWrapper = nil
		
		self.remove(tokenWrapper: tokenWrapper!)
		
		// Get model item
		let token: 			ProtocolGridScapeToken? = self.delegate?.getTokenModelItem(for: tokenWrapper!.id)
		
		if (token != nil) {
			
			self.delegate?.removeTokenModelItem(token: token!)
			
			// Save
			self.delegate?.saveToken(token: token!, oncomplete: saveTokenCompletionHandler)
			
		}
		
	}
	
	public func copy(from tokenView: ProtocolGridTokenView, to tokenWrapper: TokenWrapperBase) {
		
		let gtp: 				GridTokenProperties = tokenView.gridTokenProperties!

		tokenWrapper.column		= gtp.cellCoord!.column
		tokenWrapper.row		= gtp.cellCoord!.row
		tokenWrapper.imageName	= tokenView.tokenWrapper.imageName
		
		// Set tokenAttributesString
		tokenWrapper.set(tokenAttributesString: tokenView.tokenWrapper.tokenAttributesString)
		
	}
	

	// MARK: - Private Methods
	
	
	// MARK: - Private Methods; Cells

	
	// MARK: - Private Methods; Tiles

}
