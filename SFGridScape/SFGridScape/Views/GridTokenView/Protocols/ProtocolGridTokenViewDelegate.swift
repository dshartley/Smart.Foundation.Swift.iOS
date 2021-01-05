//
//  ProtocolGridTokenViewDelegate.swift
//  SFGridScape
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a GridTokenView class
public protocol ProtocolGridTokenViewDelegate: class {
	
	// MARK: - Methods

	func gridTokenView(propertyChanged wrapper: CellPropertyChangedWrapper, cellCoord: CellCoord, with tokenView: ProtocolGridTokenView?)
	
	func gridTokenView(touchesBegan tileView: ProtocolGridTokenView)
	
	func gridTokenView(for gesture: UITapGestureRecognizer, tapped tokenView: ProtocolGridTokenView)
	
}
