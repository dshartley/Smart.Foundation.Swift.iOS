//
//  ProtocolGridTileView.swift
//  SFGridScape
//
//  Created by David on 16/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// Defines a class which is a GridTileView
public protocol ProtocolGridTileView {
	
	// MARK: - Stored Properties

	var delegate:				ProtocolGridTileViewDelegate?  { get set }
	var tileWrapper: 			TileWrapperBase { get }
	
	
	// MARK: - Computed Properties
	
	var gridTileProperties: 	GridTileProperties? { get set }
		
		
	// MARK: - Methods
	
	func checkHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?

	func checkHitTest(onTile point: CGPoint) -> ProtocolGridTileView?
	
	func present()
	
	func clearView()
	
	func clone() -> ProtocolGridTileView
	
	func isCompatible(with neighbour: GridCellNeighbour, neighbours: [GridCellNeighbour]) -> Bool
	
	func isCompatible(with neighbours: [GridCellNeighbour]) -> Bool
	
	func set(tileWrapper: TileWrapperBase)
	
	func set(width: CGFloat, height: CGFloat)
	
	func set(position: CellContentPositionTypes, positionFixToCellRotationYN: Bool)
	
	func set(image: UIImage?, with imageName: String?)
	
	func set(canDragYN: Bool)
	
	func set(canTapYN: Bool)
	
	func set(canLongPressYN: Bool)
	
	func set(tileAttributes: String)
	
	func set(attribute key: String, value: String?)
	
	func set(tileSideAttributes: String)
	
	func set(attribute key: String, value: String?, forSide side: CellSideTypes)
	
	func get(attribute key: String) -> String?
	
	func get(attribute key: String, forSide side: CellSideTypes) -> String?
	
	func get(tileSideAttributes side: CellSideTypes) -> [String: String]
	
	func rotateRight()
	
	func rotateLeft()
	
}
