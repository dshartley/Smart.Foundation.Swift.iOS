//
//  GridTileViewControlManager.swift
//  SFGridScape
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFController

/// Manages the GridTileView control layer
public class GridTileViewControlManager {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:			ProtocolGridTileViewControlManagerDelegate?
	public var viewManager:				GridTileViewViewManager?
	public var gridTileProperties:		GridTileProperties?
	
	
	// MARK: - Private Stored Properties


	// MARK: - Initializers
	
	public init() {
	}
	
	public init(viewManager: GridTileViewViewManager) {

		self.viewManager 			= viewManager

	}
	
	
	// MARK: - Public Methods
	
	public func set(gridTileProperties: GridTileProperties) {
	
		self.gridTileProperties = gridTileProperties
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
}
