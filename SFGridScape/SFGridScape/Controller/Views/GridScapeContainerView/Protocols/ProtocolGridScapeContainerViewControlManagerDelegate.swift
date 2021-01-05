//
//  ProtocolGridScapeContainerViewControlManagerDelegate.swift
//  SFGridScape
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

/// Defines a delegate for a GridScapeContainerViewControlManager class
public protocol ProtocolGridScapeContainerViewControlManagerDelegate: class {
	
	// MARK: - Methods
	
	func createCellModelItem(for cellWrapper: CellWrapperBase) -> ProtocolGridScapeCell?

	func getCellModelItem(for id: String) -> ProtocolGridScapeCell?
	
	func removeCellModelItem(cell: ProtocolGridScapeCell)
	
	func saveCell(cell: ProtocolGridScapeCell, oncomplete completionHandler:@escaping (Error?) -> Void)

	func createTileModelItem(for tileWrapper: TileWrapperBase) -> ProtocolGridScapeTile?
	
	func getTileModelItem(for id: String) -> ProtocolGridScapeTile?
	
	func removeTileModelItem(tile: ProtocolGridScapeTile)
	
	func saveTile(tile: ProtocolGridScapeTile, oncomplete completionHandler:@escaping (Error?) -> Void)
	
	func createTokenModelItem(for tokenWrapper: TokenWrapperBase) -> ProtocolGridScapeToken?
	
	func getTokenModelItem(for id: String) -> ProtocolGridScapeToken?
	
	func removeTokenModelItem(token: ProtocolGridScapeToken)
	
	func saveToken(token: ProtocolGridScapeToken, oncomplete completionHandler:@escaping (Error?) -> Void)
	
}
