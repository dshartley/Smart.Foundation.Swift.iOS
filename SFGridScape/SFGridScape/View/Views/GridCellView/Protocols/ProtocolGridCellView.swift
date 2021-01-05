//
//  ProtocolGridCellView.swift
//  SFGridScape
//
//  Created by David on 16/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// Defines a class which is a GridCellView
public protocol ProtocolGridCellView {
	
	// MARK: - Stored Properties

	var delegate:				ProtocolGridCellViewDelegate?  { get }
	var isPresentedYN:			Bool { get }
	var cellWrapper: 			CellWrapperBase { get }
	var tileViews:				[String: ProtocolGridTileView] { get }
	var tokenViews:				[String: ProtocolGridTokenView] { get }
	
	
	// MARK: - Computed Properties
	
	var id: 					UUID { get }
	var gridCellProperties: 	GridCellProperties? { get set }
	var isHighlighted: 			Bool { get set }
	
	
	// MARK: - Methods
	
	func checkHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
	
	func checkHitTest(onCell point: CGPoint) -> ProtocolGridCellView?
	
	func checkHitTest(onTile point: CGPoint) -> ProtocolGridTileView?
	
	func checkHitTest(onToken point: CGPoint) -> ProtocolGridTokenView?
	
	func present()
	
	func clearView()
	
	func clone() -> ProtocolGridCellView
	
	func isCompatible(with neighbour: GridCellNeighbour, neighbours: [GridCellNeighbour]) -> Bool
	
	func isCompatible(with neighbours: [GridCellNeighbour]) -> Bool
	
	func set(cellWrapper: CellWrapperBase)
	
	func set(image: UIImage?, with imageName: String?)
	
	func set(delegate: ProtocolGridCellViewDelegate?)
	
	func set(canDragYN: Bool)
	
	func set(canTapYN: Bool)
	
	func set(canLongPressYN: Bool)
	
	func set(cellAttributes: String)
	
	func set(attribute key: String, value: String?)
	
	func set(cellSideAttributes: String)
	
	func set(attribute key: String, value: String?, forSide side: CellSideTypes)
	
	func get(attribute key: String) -> String?
	
	func get(attribute key: String, forSide side: CellSideTypes) -> String?
	
	func get(cellSideAttributes side: CellSideTypes) -> [String: String]
	
	func rotateRight()
	
	func rotateLeft()
	
	func present(tileView: ProtocolGridTileView)
	
	func setPosition(tileView: ProtocolGridTileView)
	
	func canSet(tileView: ProtocolGridTileView, at position: CellContentPositionTypes) -> Bool
	
	func get(positionFor tileView: ProtocolGridTileView) -> CellContentPositionTypes?
	
	func get(tileView key: String?) -> ProtocolGridTileView?
	
	func hide(tileView key: String?)

	func present(tokenView: ProtocolGridTokenView)
	
	func get(tokenView key: String?) -> ProtocolGridTokenView?
	
	func hide(tokenView key: String?)
	
	func setBackgroundColor()
	
}
