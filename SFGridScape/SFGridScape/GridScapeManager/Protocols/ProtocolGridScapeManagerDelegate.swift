//
//  ProtocolGridScapeManagerDelegate.swift
//  SFGridScape
//
//  Created by David on 20/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

/// Defines a delegate for a GridScapeManager class
public protocol ProtocolGridScapeManagerDelegate: class {
	
	// MARK: - Methods
	
	func gridScapeManager(isBuilding sender: GridScapeManager)
	
	func gridScapeManager(isFinishedBuilding sender: GridScapeManager)

	func gridScapeManager(touchesBegan sender: GridScapeManager, on view: UIView?)
	
	func gridScapeManager(tapped indicatedPoint: CGPoint, cellCoord: CellCoord)
	
	func gridScapeManager(tapped cellView: ProtocolGridCellView, at indicatedPoint: CGPoint)
	
	func gridScapeManager(tapped tileView: ProtocolGridTileView, cellView: ProtocolGridCellView, at indicatedPoint: CGPoint)

	func gridScapeManager(tapped tokenView: ProtocolGridTokenView, cellView: ProtocolGridCellView, at indicatedPoint: CGPoint)
	
	func gridScapeManager(longPressed cellView: ProtocolGridCellView, at indicatedPoint: CGPoint, gesture: UILongPressGestureRecognizer)
	
	func gridScapeManager(longPressed tileView: ProtocolGridTileView, cellView: ProtocolGridCellView, at indicatedPoint: CGPoint, gesture: UILongPressGestureRecognizer)

	func gridScapeManager(longPressed tokenView: ProtocolGridTokenView, cellView: ProtocolGridCellView, at indicatedPoint: CGPoint, gesture: UILongPressGestureRecognizer)
	
	func gridScapeManager(cellPropertyChanged key: String, cellCoord: CellCoord, with cellView: ProtocolGridCellView?)
	
	func gridScapeManager(tilePropertyChanged key: String, cellCoord: CellCoord, with tileView: ProtocolGridTileView?)

	func gridScapeManager(tokenPropertyChanged key: String, cellCoord: CellCoord, with tokenView: ProtocolGridTokenView?)
	
	func gridScapeManager(gridScapeView: GridScapeView, cellViewForItemAt cellCoord: CellCoord) -> ProtocolGridCellView?

	func gridScapeManager(gridScapeView: GridScapeView, tokenViewForItemAt cellCoord: CellCoord, key: String?, completionHandler:@escaping (ProtocolGridTokenView?, Error?) -> Void)
	
	func gridScapeManager(unloadedCells cellCoords: [CellCoord])
	
	func gridScapeManager(unloadedCells cellCoordRange: CellCoordRange)
	
	func gridScapeManager(scrollingBegan sender: GridScapeManager)
	
	// Nb: As this is a public delegate method, expects indicatedOffsetX and indicatedOffsetY referenced to current gridPositionReferenceToType
	func gridScapeManager(scrolled sender: GridScapeManager, indicatedOffsetX: CGFloat, indicatedOffsetY: CGFloat)

	func gridScapeManager(loadCells sender: GridScapeManager, cellCoordRange: CellCoordRange)
	
	func gridScapeManager(loadCells sender: GridScapeManager, cellCoordRange: CellCoordRange, oncomplete completionHandler:@escaping (Error?) -> Void)
	
	func gridScapeManager(canDrop cellView: ProtocolGridCellView, at cellCoord: CellCoord) -> Bool
	
	func gridScapeManager(cellMoved cellView: ProtocolGridCellView, from fromCellCoord: CellCoord, to toCellCoord: CellCoord)

	func gridScapeManager(cellDropped cellView: ProtocolGridCellView, at toCellCoord: CellCoord)
	
	func gridScapeManager(canDrop tileView: ProtocolGridTileView, at cellCoord: CellCoord) -> Bool
	
	func gridScapeManager(tileMoved tileView: ProtocolGridTileView, from fromCellCoord: CellCoord, to toCellCoord: CellCoord)
	
	func gridScapeManager(tileDropped cellView: ProtocolGridTileView, at toCellCoord: CellCoord)

	func gridScapeManager(canDrop tokenView: ProtocolGridTokenView, at cellCoord: CellCoord) -> Bool
	
	func gridScapeManager(tokenMoved tokenView: ProtocolGridTokenView, from fromCellCoord: CellCoord, to toCellCoord: CellCoord)

	func gridScapeManager(tokenMoving tokenView: ProtocolGridTokenView, alongPath pathWrapper: PathWrapperBase, doBeforeStartMovingAlongPath sender: GridScapeManager, completionHandler:@escaping (MoveAlongPathResponseTypes, Error?) -> Void)
	
	func gridScapeManager(tokenMoving tokenView: ProtocolGridTokenView, alongPath pathWrapper: PathWrapperBase, from fromPathPointWrapper: PathPointWrapperBase, to toPathPointWrapper: PathPointWrapperBase, doBeforeMovePoint sender: GridScapeManager, completionHandler:@escaping (MoveAlongPathResponseTypes, Error?) -> Void)
	
	func gridScapeManager(tokenMoving tokenView: ProtocolGridTokenView, alongPath pathWrapper: PathWrapperBase, from fromPathPointWrapper: PathPointWrapperBase, to toPathPointWrapper: PathPointWrapperBase, doAfterMovePoint sender: GridScapeManager, completionHandler:@escaping (MoveAlongPathResponseTypes, Error?) -> Void)
	
	func gridScapeManager(tokenMoving tokenView: ProtocolGridTokenView, alongPath pathWrapper: PathWrapperBase, doAfterFinishedMovingAlongPath sender: GridScapeManager, completionHandler: @escaping (MoveAlongPathResponseTypes, Error?) -> Void)
	
}
