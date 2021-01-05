//
//  GridCellViewControlManager.swift
//  SFGridScape
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFController

/// Manages the GridCellView control layer
public class GridCellViewControlManager {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:			ProtocolGridCellViewControlManagerDelegate?
	public var viewManager:				GridCellViewViewManager?
	public var gridCellProperties:		GridCellProperties?
	public var isHighlightedYN:			Bool = false
	
	
	// MARK: - Private Stored Properties


	// MARK: - Initializers
	
	public init() {
	}
	
	public init(viewManager: GridCellViewViewManager) {

		self.viewManager 			= viewManager

	}
	
	
	// MARK: - Public Methods
	
	public func set(gridCellProperties: GridCellProperties) {
	
		self.gridCellProperties = gridCellProperties
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
}
