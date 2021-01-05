//
//  ProtocolGridCellViewDelegate.swift
//  SFGridScape
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a GridCellView class
public protocol ProtocolGridCellViewDelegate: class {
	
	// MARK: - Methods

	func gridCellView(propertyChanged wrapper: CellPropertyChangedWrapper, cellCoord: CellCoord, with cellView: ProtocolGridCellView?)

	func gridCellView(touchesBegan cellView: ProtocolGridCellView)
	
	func gridCellView(for gesture: UITapGestureRecognizer, tapped cellView: ProtocolGridCellView)

	func gridCellView(getTileViewDelegate sender: ProtocolGridCellView) -> ProtocolGridTileViewDelegate?
	
	func gridCellView(getTokenViewDelegate sender: ProtocolGridCellView) -> ProtocolGridTokenViewDelegate?
	
}
