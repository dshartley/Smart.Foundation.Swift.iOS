//
//  ProtocolGridTokenView.swift
//  SFGridScape
//
//  Created by David on 16/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFSerialization

/// Defines a class which is a GridTokenView
public protocol ProtocolGridTokenView {
	
	// MARK: - Stored Properties

	var delegate:				ProtocolGridTokenViewDelegate?  { get set }
	var tokenWrapper: 			TokenWrapperBase { get }
	
	
	// MARK: - Computed Properties
	
	var gridTokenProperties: 	GridTokenProperties? { get set }
		
		
	// MARK: - Methods
	
	func checkHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
	
	func checkHitTest(onToken point: CGPoint) -> ProtocolGridTokenView?
	
	func present()
	
	func clearView()
	
	func clone() -> ProtocolGridTokenView
	
	func isCompatible(with neighbour: GridCellNeighbour, neighbours: [GridCellNeighbour]) -> Bool
	
	func isCompatible(with neighbours: [GridCellNeighbour]) -> Bool
	
	func set(tokenWrapper: TokenWrapperBase)
	
	func set(image: UIImage?, with imageName: String?)
	
	func set(canDragYN: Bool)
	
	func set(canTapYN: Bool)
	
	func set(canLongPressYN: Bool)
	
	func set(tokenAttributes: String)
	
	func set(attribute key: String, value: String?)

	func get(attribute key: String) -> String?
	
}
