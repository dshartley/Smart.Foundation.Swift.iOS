//
//  ProtocolGridTileViewDelegate.swift
//  SFGridScape
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a GridTileView class
public protocol ProtocolGridTileViewDelegate: class {
	
	// MARK: - Methods

	func gridTileView(propertyChanged wrapper: CellPropertyChangedWrapper, cellCoord: CellCoord, with tileView: ProtocolGridTileView?)
	
	func gridTileView(touchesBegan tileView: ProtocolGridTileView)
	
	func gridTileView(for gesture: UITapGestureRecognizer, tapped tileView: ProtocolGridTileView)
	
	func gridTileView(setPosition tileView: ProtocolGridTileView)
	
}
