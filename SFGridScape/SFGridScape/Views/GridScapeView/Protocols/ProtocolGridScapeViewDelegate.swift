//
//  ProtocolGridScapeViewDelegate.swift
//  SFGridScape
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView

/// Defines a delegate for a GridScapeView class
public protocol ProtocolGridScapeViewDelegate: class {
	
	// MARK: - Methods

	func gridScapeView(touchesBegan gridScapeView: ProtocolGridScapeView)
	
	func gridScapeView(for gesture: UITapGestureRecognizer, tapped indicatedPoint: CGPoint)
	
	func gridScapeView(for gesture: UILongPressGestureRecognizer, longPressed indicatedPoint: CGPoint)
	
	func gridScapeView(for gesture: UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes)
	
	func gridScapeView(for gesture: UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes)
	
	func gridScapeView(for gesture: UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes)
	
	func gridScapeView(for gesture: UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes)
	
	func gridScapeView(for gesture: UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes)
	
	func gridScapeView(sender: GridScapeView, cellForItemAt cellCoord: CellCoord) -> ProtocolGridCellView?
	
	func gridScapeView(sender: GridScapeView, canDrag cellView: ProtocolGridCellView) -> Bool
	
	func gridScapeView(sender: GridScapeView, draggingStarted cellView: ProtocolGridCellView)
	
	func gridScapeView(sender: GridScapeView, draggingCancelled cellView: ProtocolGridCellView)
	
	func gridScapeView(sender: GridScapeView, canDrop cellView: ProtocolGridCellView, at cellCoord: CellCoord) -> Bool
	
	func gridScapeView(sender: GridScapeView, didDrop cellView: ProtocolGridCellView, at cellCoord: CellCoord)
	
	func gridScapeView(sender: GridScapeView, canDrag tileView: ProtocolGridTileView) -> Bool
	
	func gridScapeView(sender: GridScapeView, draggingStarted tileView: ProtocolGridTileView)
	
	func gridScapeView(sender: GridScapeView, draggingCancelled tileView: ProtocolGridTileView)
	
	func gridScapeView(sender: GridScapeView, canDrop tileView: ProtocolGridTileView, at cellCoord: CellCoord) -> Bool
	
	func gridScapeView(sender: GridScapeView, didDrop tileView: ProtocolGridTileView, at cellCoord: CellCoord)
	
	func gridScapeView(sender: GridScapeView, canDrag tokenView: ProtocolGridTokenView) -> Bool
	
	func gridScapeView(sender: GridScapeView, draggingStarted tokenView: ProtocolGridTokenView)
	
	func gridScapeView(sender: GridScapeView, draggingCancelled tokenView: ProtocolGridTokenView)
	
	func gridScapeView(sender: GridScapeView, canDrop tokenView: ProtocolGridTokenView, at cellCoord: CellCoord) -> Bool
	
	func gridScapeView(sender: GridScapeView, didDrop tokenView: ProtocolGridTokenView, at cellCoord: CellCoord)
	
}
